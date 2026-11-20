<#
.SYNOPSIS
    构建 Manbo Soundpack 的原版或曼波特别版。
.EXAMPLE
    .\scripts\build.ps1
    .\scripts\build.ps1 -Variant Manbo -Install
    .\scripts\build.ps1 -Variant All -Version v1.0
#>
param(
    [ValidateSet('Original', 'Manbo', 'All')]
    [string]$Variant = 'Original',
    [ValidatePattern('^v\d+\.\d+(\.\d+)?$')]
    [string]$Version,
    [switch]$NoVerify,
    [switch]$Install
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$src = Join-Path $root 'src'
$distDir = Join-Path $root 'dist'
$verifyScript = Join-Path $PSScriptRoot 'verify.ps1'
$installScript = Join-Path $PSScriptRoot 'install.ps1'
$replacement = Join-Path $root 'variants\manbo\you_were_poked.wav'
$pokedPath = 'sound/Manbo Soundpack/you_were_poked.wav'

if ($Install -and $Variant -eq 'All') { throw '请指定一个版本安装，不能同时安装两个版本。' }
if ($Variant -ne 'Original' -and -not (Test-Path -LiteralPath $replacement -PathType Leaf)) {
    throw "找不到曼波特别版音频: $replacement"
}
if ($Version) {
    $packageInfo = [IO.File]::ReadAllText((Join-Path $src 'package.ini'))
    $settings = [IO.File]::ReadAllText((Join-Path $src 'sound\Manbo Soundpack\settings.ini'))
    $expected = [regex]::Escape($Version.Substring(1))
    if ($packageInfo -notmatch "(?m)^\s*Version\s*=\s*v?$expected\s*$" -or
        $settings -notmatch "(?m)^\s*version\s*=\s*v?$expected\s*$") {
        throw "版本 $Version 与 package.ini 或 settings.ini 不一致。"
    }
}

if (-not $NoVerify) {
    & $verifyScript -Path $src
    if ($LASTEXITCODE -ne 0) { throw '源码校验未通过。' }
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.IO.Compression
if (-not (Test-Path $distDir)) { New-Item -ItemType Directory -Path $distDir | Out-Null }
$variants = if ($Variant -eq 'All') { @('Original', 'Manbo') } else { @($Variant) }

foreach ($current in $variants) {
    $versionSuffix = if ($Version) { "-$Version" } else { '' }
    $variantSuffix = if ($current -eq 'Manbo') { '-Manbo' } else { '' }
    $outName = "ManboSoundpack$versionSuffix$variantSuffix.ts3_soundpack"
    $out = Join-Path $distDir $outName
    $tmpZip = "$out.zip"
    if (Test-Path $tmpZip) { Remove-Item -LiteralPath $tmpZip -Force }
    $fs = [IO.File]::Open($tmpZip, [IO.FileMode]::CreateNew)
    try {
        $archive = New-Object IO.Compression.ZipArchive($fs, [IO.Compression.ZipArchiveMode]::Create, $false)
        try {
            foreach ($file in Get-ChildItem $src -Recurse -File) {
                $rel = $file.FullName.Substring($src.Length).TrimStart('\').Replace('\', '/')
                $source = if ($current -eq 'Manbo' -and $rel -eq $pokedPath) { $replacement } else { $file.FullName }
                $entry = $archive.CreateEntry($rel, [IO.Compression.CompressionLevel]::Optimal)
                $entryStream = $entry.Open()
                try {
                    $bytes = [IO.File]::ReadAllBytes($source)
                    $entryStream.Write($bytes, 0, $bytes.Length)
                } finally { $entryStream.Dispose() }
            }
        } finally { $archive.Dispose() }
    } finally { $fs.Dispose() }

    if (-not $NoVerify) {
        & $verifyScript -Path $tmpZip
        if ($LASTEXITCODE -ne 0) { throw "产物校验未通过: $outName" }
    }
    Move-Item -LiteralPath $tmpZip -Destination $out -Force
    Write-Host "--> 已生成: $out" -ForegroundColor Green

    if ($Install) {
        & $installScript -Source $out
        if ($LASTEXITCODE -ne 0) { throw '安装失败。' }
    }
}

Write-Host '==> 构建完成' -ForegroundColor Green
