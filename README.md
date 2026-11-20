# Manbo Soundpack

曼波语音包，适用于 TeamSpeak 3。项目包含语音素材，以及构建、校验和安装脚本。

## 安装

从 Release 下载原版或 `-Manbo` 特别版，双击 `.ts3_soundpack` 文件安装，然后在 TeamSpeak 3 的 **设置 → 播放 → 音效包** 中选择 **Manbo Soundpack**。

特别版将戳一戳音效替换为“曼波！”。两个版本使用相同的音效包名称，安装其中一个即可切换。

也可以在 Windows PowerShell 5.1 或更高版本中，从项目根目录构建并安装：

```powershell
.\scripts\build.ps1 -Install
```

## 构建

```powershell
.\scripts\build.ps1
```

默认构建原版。使用以下命令可构建特别版或同时构建两个版本：

```powershell
.\scripts\build.ps1 -Variant Manbo
.\scripts\build.ps1 -Variant All
```

产物位于 `dist/`。构建脚本会校验源码和产物；只需校验源码时：

```powershell
.\scripts\verify.ps1 -Path .\src
```

语音文件和事件映射位于 `src/sound/Manbo Soundpack/`。修改音频后重新构建即可；音频规格和事件映射说明见 `docs/`。

推送与 `src/package.ini` 和 `settings.ini` 中版本一致的标签（例如 `v1.0.0`）后，GitHub Actions 会测试并发布两个安装包。

## 许可证

[Apache License 2.0](LICENSE)
