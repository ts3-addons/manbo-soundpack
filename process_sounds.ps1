# 音频处理脚本
$sourceDir = Join-Path $PSScriptRoot 'src\sound\Manbo Soundpack'
$outputDir = Join-Path $PSScriptRoot 'sound_processed'

# 创建输出目录
if (Test-Path $outputDir) {
    Remove-Item $outputDir -Recurse -Force
}
New-Item -ItemType Directory -Path $outputDir | Out-Null

# 获取所有mp3文件
$files = Get-ChildItem $sourceDir -Filter *.mp3

Write-Host "开始处理 $($files.Count) 个文件..."

foreach ($file in $files) {
    # 去掉文件名开头的序号（如 1., 10., 48. 等）和结尾的数字后缀（如 _2599, _3729 等）
    $newName = $file.BaseName -replace '^\d+\.', '' -replace '_\d+$', ''
    $outputFile = Join-Path $outputDir "$newName.wav"

    Write-Host "处理: $($file.Name) -> $newName.wav"

    # 使用ffmpeg处理：
    # 1. 转换为wav格式（16bit, 48kHz, stereo）
    # 2. 归一化音量（loudnorm滤镜）
    # 3. 添加50ms首尾静音
    & ffmpeg -i $file.FullName `
        -af "loudnorm=I=-16:TP=-1.5:LRA=11,apad=pad_dur=0.05,adelay=50|50" `
        -ar 48000 -ac 2 -sample_fmt s16 `
        -y $outputFile 2>$null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ 完成" -ForegroundColor Green
    } else {
        Write-Host "  ✗ 失败" -ForegroundColor Red
    }
}

Write-Host "`n处理完成！输出目录: $outputDir" -ForegroundColor Cyan
