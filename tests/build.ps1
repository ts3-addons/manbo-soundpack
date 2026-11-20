$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$root = Split-Path $PSScriptRoot -Parent
$testRoot = Join-Path $env:TEMP ('manbo-build-test-' + [guid]::NewGuid().ToString('N'))
$shell = Join-Path $PSHOME 'powershell.exe'
if (-not (Test-Path $shell)) { $shell = (Get-Process -Id $PID).Path }

function Get-EntryHash($archive, $name) {
    $entry = $archive.GetEntry($name)
    if ($null -eq $entry) { throw "包中缺少文件: $name" }
    $stream = $entry.Open()
    $sha = [Security.Cryptography.SHA256]::Create()
    try { return [BitConverter]::ToString($sha.ComputeHash($stream)) }
    finally { $sha.Dispose(); $stream.Dispose() }
}

try {
    New-Item -ItemType Directory -Path $testRoot | Out-Null
    foreach ($dir in @('src', 'scripts', 'variants')) {
        Copy-Item -LiteralPath (Join-Path $root $dir) -Destination $testRoot -Recurse
    }
    $package = [IO.File]::ReadAllText((Join-Path $testRoot 'src\package.ini'))
    if ($package -notmatch '(?m)^\s*Version\s*=\s*v?(\d+\.\d+(?:\.\d+)?)\s*$') { throw '无效的包版本。' }
    $version = 'v' + $Matches[1]
    $build = Join-Path $testRoot 'scripts\build.ps1'
    & $shell -NoProfile -ExecutionPolicy Bypass -File $build -Variant All -Version $version
    if ($LASTEXITCODE -ne 0) { throw '双版本构建失败。' }

    $originalFile = Join-Path $testRoot "dist\ManboSoundpack-$version.ts3_soundpack"
    $manboFile = Join-Path $testRoot "dist\ManboSoundpack-$version-Manbo.ts3_soundpack"
    $original = [IO.Compression.ZipFile]::OpenRead($originalFile)
    $manbo = [IO.Compression.ZipFile]::OpenRead($manboFile)
    try {
        $originalNames = @($original.Entries | ForEach-Object { $_.FullName } | Sort-Object)
        $manboNames = @($manbo.Entries | ForEach-Object { $_.FullName } | Sort-Object)
        if (Compare-Object $originalNames $manboNames) { throw '两个包的文件列表不同。' }
        $poked = 'sound/Manbo Soundpack/you_were_poked.wav'
        foreach ($name in $originalNames) {
            $originalHash = Get-EntryHash $original $name
            $manboHash = Get-EntryHash $manbo $name
            if ($name -eq $poked) {
                $source = (Get-FileHash (Join-Path $testRoot 'src\sound\Manbo Soundpack\you_were_poked.wav')).Hash
                $alternative = (Get-FileHash (Join-Path $testRoot 'variants\manbo\you_were_poked.wav')).Hash
                if ($originalHash.Replace('-', '') -ne $source -or $manboHash.Replace('-', '') -ne $alternative -or $source -eq $alternative) {
                    throw '戳一戳音频与版本不匹配。'
                }
            } elseif ($originalHash -ne $manboHash) { throw "版本之间存在额外差异: $name" }
        }
    } finally { $original.Dispose(); $manbo.Dispose() }

    $ErrorActionPreference = 'Continue'
    try {
        & $shell -NoProfile -ExecutionPolicy Bypass -File $build -Variant Original -Version v999999.0 2>&1 | Out-Null
        $invalidVersionExitCode = $LASTEXITCODE
    } finally { $ErrorActionPreference = 'Stop' }
    if ($invalidVersionExitCode -eq 0) { throw '不匹配的版本号应导致构建失败。' }
    Write-Host '双版本构建测试通过。' -ForegroundColor Green
} finally {
    if (Test-Path -LiteralPath $testRoot) { Remove-Item -LiteralPath $testRoot -Recurse -Force }
}
