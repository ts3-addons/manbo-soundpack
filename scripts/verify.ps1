<#
.SYNOPSIS
    校验 Manbo Soundpack 音效包的结构、配置引用与音频格式。

.DESCRIPTION
    接受两种输入：
      - .ts3_soundpack / .zip 压缩包
      - 源目录（根目录含 package.ini 与 sound/ 文件夹，即本项目 src/ 或解压后的包）

    校验项：
      1. 压缩包根目录必须存在 package.ini
      2. sound/ 下必须存在音效包文件夹，且含 settings.ini
      3. settings.ini 的 [info] 段可读（name / version / author）
      4. settings.ini 的 [soundfiles] 段引用的每个 wav 都必须存在于包内
         （${clientType} 通配符会按 friend / neutral / blocked_user 展开）
      5. 每个 wav 的 RIFF/WAVE 头符合 TS3 规格（PCM 16bit 44.1kHz；单声道或立体声）
      6. 包内是否有未被任何事件引用的孤儿 wav（警告）

    退出码：0 = 通过（无错误）；1 = 存在错误；2 = 用法/参数错误。

.EXAMPLE
    .\scripts\verify.ps1 -Path .\dist\ManboSoundpack.ts3_soundpack
    .\scripts\verify.ps1 -Path .\src
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$script:errorCount = 0
$script:warningCount = 0

function Write-Err { Write-Host "[错误] $args" -ForegroundColor Red; $script:errorCount++ }
function Write-Warn { Write-Host "[警告] $args" -ForegroundColor Yellow; $script:warningCount++ }
function Write-Ok { Write-Host "[通过] $args" -ForegroundColor Green }

# ---------- 解析输入路径 ----------
$target = (Resolve-Path $Path -ErrorAction Stop).Path
$isZip = [System.IO.Path]::GetExtension($target) -in @('.ts3_soundpack', '.zip')
$typeLabel = '源目录'
if ($isZip) { $typeLabel = 'ZIP 压缩包' }
Write-Host "==> 校验目标: $target" -ForegroundColor Cyan
Write-Host "==> 类型: $typeLabel" -ForegroundColor Cyan

# ---------- 读取文本（文件或 zip 条目） ----------
function Get-TextContent {
    param([string]$FullName, [hashtable]$Map, [string]$Base, [bool]$IsZipMode)
    if ($IsZipMode) {
        $entry = $Map[$FullName]
        if ($null -eq $entry) { return $null }
        $sr = New-Object System.IO.StreamReader($entry.Open(), [System.Text.Encoding]::UTF8)
        try { return $sr.ReadToEnd() } finally { $sr.Close() }
    } else {
        $p = Join-Path $Base $FullName
        if (-not (Test-Path $p)) { return $null }
        return [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8)
    }
}

# ---------- 读取 wav 前 44 字节头（文件或 zip 条目） ----------
function Get-WavHeader {
    param([string]$FullName, [hashtable]$Map, [string]$Base, [bool]$IsZipMode)
    try {
        if ($IsZipMode) {
            $entry = $Map[$FullName]
            if ($null -eq $entry) { return $null }
            $ms = New-Object System.IO.MemoryStream
            $es = $entry.Open()
            try { $es.CopyTo($ms) } finally { $es.Close() }
            $bytes = $ms.ToArray(); $ms.Dispose()
        } else {
            $p = Join-Path $Base $FullName
            if (-not (Test-Path $p)) { return $null }
            $bytes = [System.IO.File]::ReadAllBytes($p)
        }
        if ($bytes.Length -lt 44) { return @{ valid = $false; reason = '文件小于 44 字节，不是有效 WAV' } }
        $riff = [System.Text.Encoding]::ASCII.GetString($bytes, 0, 4)
        $wave = [System.Text.Encoding]::ASCII.GetString($bytes, 8, 4)
        $audioFmt = [BitConverter]::ToInt16($bytes, 20)
        $channels = [BitConverter]::ToInt16($bytes, 22)
        $sampleRate = [BitConverter]::ToInt32($bytes, 24)
        $bits = [BitConverter]::ToInt16($bytes, 34)
        if ($riff -ne 'RIFF' -or $wave -ne 'WAVE') { return @{ valid = $false; reason = '非 RIFF/WAVE 文件' } }
        return @{ valid = $true; audioFmt = $audioFmt; channels = $channels; sampleRate = $sampleRate; bits = $bits }
    } catch {
        return @{ valid = $false; reason = "读取失败: $_" }
    }
}

# ---------- 主流程 ----------
$isZipMode = $isZip

# 建立条目字典（FullName 归一化为正斜杠，兼容 / 与 \ 两种压缩器；大小写不敏感）
$entryMap = @{}
$baseDir = ''
$zip = $null
if ($isZipMode) {
    $zip = [System.IO.Compression.ZipFile]::OpenRead($target)
    foreach ($e in $zip.Entries) {
        $norm = $e.FullName.Replace('\', '/')
        if (-not $entryMap.ContainsKey($norm)) { $entryMap[$norm] = $e }
    }
} else {
    $baseDir = $target
    foreach ($file in (Get-ChildItem $baseDir -Recurse -File)) {
        $norm = $file.FullName.Substring($baseDir.Length).TrimStart('\').Replace('\', '/')
        $entryMap[$norm] = $file.FullName
    }
}

try {
    # 1) package.ini
    if ($entryMap.ContainsKey('package.ini')) {
        Write-Ok "根目录存在 package.ini"
    } else {
        Write-Err "根目录缺少 package.ini"
        if ($isZipMode) { $zip.Dispose() }
        exit 1
    }

    # 2) 定位音效包文件夹（sound/ 下的子文件夹，含 settings.ini）
    $packDirs = [System.Collections.Generic.List[string]]::new()
    foreach ($key in $entryMap.Keys) {
        if ($key.StartsWith('sound/')) {
            $rest = $key.Substring('sound/'.Length)
            if ($rest.Contains('/')) {
                $dir = $rest.Split('/')[0]
                if (-not $packDirs.Contains("sound/$dir")) { [void]$packDirs.Add("sound/$dir") }
            }
        }
    }
    if ($packDirs.Count -eq 0) { Write-Err "sound/ 下找不到音效包文件夹"; if ($isZipMode) { $zip.Dispose() }; exit 1 }
    if ($packDirs.Count -gt 1) { Write-Warn "sound/ 下存在多个音效包文件夹: $($packDirs -join ', ')（仅校验第一个）" }
    $packDir = $packDirs[0]
    $packName = $packDir.Split('/')[-1]
    Write-Ok "发现音效包: $packName"

    # 3) settings.ini
    $iniPath = "$packDir/settings.ini"
    $iniText = Get-TextContent -FullName $iniPath -Map $entryMap -Base $baseDir -IsZipMode $isZipMode
    if ($null -eq $iniText) { Write-Err "缺少 $iniPath"; if ($isZipMode) { $zip.Dispose() }; exit 1 }
    Write-Ok "settings.ini 存在"

    # 4) [info] 段
    $infoName = $null; $infoVer = $null; $infoAuthor = $null
    foreach ($line in ($iniText -split "`r?`n")) {
        if ($line -match '^\s*name\s*=\s*(.+)$') { $infoName = $Matches[1].Trim() }
        elseif ($line -match '^\s*version\s*=\s*(.+)$') { $infoVer = $Matches[1].Trim() }
        elseif ($line -match '^\s*author\s*=\s*(.+)$') { $infoAuthor = $Matches[1].Trim() }
    }
    if ($infoName) { Write-Ok "包名(name): $infoName" } else { Write-Err "settings.ini [info] 缺少 name" }
    Write-Host "       version: $infoVer | author: $infoAuthor"

    # 5) [soundfiles] 引用解析
    $refs = [System.Collections.Generic.List[string]]::new()
    foreach ($line in ($iniText -split "`r?`n")) {
        if ($line -match '^\s*[A-Z0-9_]+\s*=\s*play\("([^"]+)"\)') {
            [void]$refs.Add($Matches[1])
        }
    }
    $expanded = [System.Collections.Generic.List[string]]::new()
    foreach ($r in $refs) {
        if ($r -match '\$\{clientType\}') {
            # TS3 官方规则：${clientType} 展开为 friend / neutral / blocked_user（黑名单文件名带 _user_）
            foreach ($t in @('friend', 'neutral', 'blocked_user')) { [void]$expanded.Add($r.Replace('${clientType}', $t)) }
        } else {
            [void]$expanded.Add($r)
        }
    }
    $uniqueRefs = @($expanded | Sort-Object -Unique)
    Write-Host "==> [soundfiles] 共引用 $($refs.Count) 条规则，展开后唯一文件 $($uniqueRefs.Count) 个"

    # 6) 检查引用文件是否存在（用字典精确查找，规避管道闭包偶发问题）
    $missing = [System.Collections.Generic.List[string]]::new()
    $existingRefs = [System.Collections.Generic.List[string]]::new()
    foreach ($f in $uniqueRefs) {
        $full = "$packDir/$f"
        $exists = $false
        if ($isZipMode) {
            $exists = $entryMap.ContainsKey($full)
        } else {
            $exists = Test-Path (Join-Path $baseDir ($full.Replace('/', '\')))
        }
        if ($exists) { [void]$existingRefs.Add($f) } else { [void]$missing.Add($f) }
    }
    if ($missing.Count -eq 0) {
        Write-Ok "所有引用文件均存在（$($existingRefs.Count) 个）"
    } else {
        foreach ($m in $missing) { Write-Err "引用但缺失: $packName/$m" }
    }

    # 7) WAV 格式校验
    $fmtWarn = 0
    foreach ($f in $existingRefs) {
        $full = "$packDir/$f"
        $h = Get-WavHeader -FullName $full -Map $entryMap -Base $baseDir -IsZipMode $isZipMode
        if ($null -eq $h) { Write-Err "无法读取 $f"; continue }
        if (-not $h.valid) { Write-Err "格式异常 $f : $($h.reason)"; continue }
        if ($h.audioFmt -ne 1) { Write-Err "非 PCM 编码 $f (format=$($h.audioFmt))"; continue }
        if ($h.sampleRate -ne 44100) { Write-Warn "$f 采样率 $($h.sampleRate) Hz，TS3 推荐 44100 Hz"; $fmtWarn++ }
        if ($h.bits -ne 16) { Write-Warn "$f 位深 $($h.bits) bit，TS3 推荐 16 bit"; $fmtWarn++ }
        if ($h.channels -gt 2) { Write-Warn "$f 声道数 $($h.channels)，建议单声道/双声道"; $fmtWarn++ }
    }
    if ($fmtWarn -eq 0) { Write-Ok "所有 wav 格式符合 TS3 规格（PCM / 44.1kHz / 16bit）" }

    # 8) 孤儿文件检查（包内存在但未被引用）
    $allWav = [System.Collections.Generic.List[string]]::new()
    foreach ($key in $entryMap.Keys) {
        if ($key.StartsWith("$packDir/") -and $key.EndsWith('.wav')) {
            [void]$allWav.Add($key.Split('/')[-1])
        }
    }
    $orphans = @($allWav | Where-Object { $existingRefs -notcontains $_ } | Sort-Object -Unique)
    if ($orphans.Count -gt 0) {
        Write-Warn "存在未被引用的孤儿 wav（不影响运行，可删除）: $($orphans -join ', ')"
    } else {
        Write-Ok "无孤儿 wav 文件"
    }

    # ---------- 汇总 ----------
    Write-Host ""
    if ($script:errorCount -gt 0) {
        Write-Host "==> 校验结果: 失败（$script:errorCount 个错误，$script:warningCount 个警告）" -ForegroundColor Red
        if ($isZipMode) { $zip.Dispose() }
        exit 1
    } else {
        Write-Host "==> 校验结果: 通过（$script:warningCount 个警告）" -ForegroundColor Green
        if ($isZipMode) { $zip.Dispose() }
        exit 0
    }
} catch {
    if ($isZipMode -and $zip) { $zip.Dispose() }
    Write-Host "==> 校验脚本异常: $_" -ForegroundColor Red
    exit 1
}
