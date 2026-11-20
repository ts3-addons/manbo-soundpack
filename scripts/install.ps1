<#
.SYNOPSIS
    安装 Manbo Soundpack 到 TeamSpeak 3 用户音效目录。

.DESCRIPTION
    把构建产物 dist/ManboSoundpack.ts3_soundpack 中的音效包
    安装到 %APPDATA%\TS3Client\sound\<包名>\，
    供 TeamSpeak 3 客户端在 设置 -> 播放 -> 音效包 中选择。
    若目标目录已存在同包名，会先备份为 <包名>.bak.<时间戳> 再覆盖。

.EXAMPLE
    .\scripts\install.ps1
    .\scripts\install.ps1 -Source .\dist\ManboSoundpack.ts3_soundpack
#>
param(
    [string]$Source = (Join-Path (Split-Path $PSScriptRoot -Parent) 'dist\ManboSoundpack.ts3_soundpack'),
    [string]$Ts3SoundDir = (Join-Path $env:APPDATA 'TS3Client\sound')
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $Source)) {
    Write-Host "==> 找不到产物: $Source（请先运行 build.ps1）" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $Ts3SoundDir)) {
    Write-Host "==> 找不到 TS3 音效目录: $Ts3SoundDir" -ForegroundColor Red
    Write-Host "    请确认已安装 TeamSpeak 3 客户端。" -ForegroundColor Yellow
    exit 1
}

Write-Host "==> 安装: $Source" -ForegroundColor Cyan
Write-Host "==> 目标: $Ts3SoundDir" -ForegroundColor Cyan

Add-Type -AssemblyName System.IO.Compression.FileSystem

# 解压到临时目录，定位 sound/ 下的音效包文件夹
$tmp = Join-Path $env:TEMP ("ts3_install_" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tmp -Force | Out-Null
try {
    [System.IO.Compression.ZipFile]::ExtractToDirectory($Source, $tmp)
    $soundRoot = Join-Path $tmp 'sound'
    if (-not (Test-Path $soundRoot)) {
        Write-Host "==> 产物中缺少 sound/ 目录，不是有效音效包" -ForegroundColor Red
        exit 1
    }
    $packDirs = @(Get-ChildItem $soundRoot -Directory)
    if ($packDirs.Count -eq 0) {
        Write-Host "==> 产物中 sound/ 下没有音效包文件夹" -ForegroundColor Red
        exit 1
    }
    foreach ($p in $packDirs) {
        $dest = Join-Path $Ts3SoundDir $p.Name
        if (Test-Path $dest) {
            $bak = "$dest.bak.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            Move-Item $dest $bak
            Write-Host "--> 已备份旧版本 -> $bak" -ForegroundColor Yellow
        }
        Copy-Item $p.FullName $dest -Recurse -Force
        $wavCount = (Get-ChildItem $dest -Filter *.wav).Count
        Write-Host "--> 已安装音效包: $($p.Name)（$wavCount 个音频）" -ForegroundColor Green
    }
} finally {
    if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue }
}

Write-Host ""
Write-Host "==> 安装完成 ✓" -ForegroundColor Green
Write-Host "    在 TeamSpeak 3 中打开：设置(Settings) -> 播放(Playback) -> 音效包(Sound Pack) -> 选择 Manbo Soundpack" -ForegroundColor Cyan
exit 0
