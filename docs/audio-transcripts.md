# 音频文字内容对照表（Manbo Soundpack）

> 此表保留旧版英文事件文本和中文参考翻译，供对照使用；尚未核对当前曼波语音的实际内容。
> 当前音频位置：`src\sound\Manbo Soundpack\*.wav`（共 79 个文件）。

## 一、连接与常规

| 文件名 | 音频英文原文 | 中文参考翻译 | 触发场景 |
| --- | --- | --- | --- |
| connected.wav | Connected. | 已连接。 | 成功连接服务器 |
| disconnected.wav | Disconnected. | 已断开连接。 | 主动断开 |
| connection_lost.wav | Connection lost. | 连接中断。 | 连接丢失 |
| error.wav | Error. | 错误。 | 操作出错 |
| insufficient_permissions.wav | Insufficient permissions. | 权限不足。 | 权限不足 |
| you_were_poked.wav | Hey, wake up. | 嘿，醒醒。 | 被戳一戳 |
| filetransfer_complete.wav | File transfer complete. | 文件传输完成。 | 文件传输完成 |
| filetransfer_failed.wav | File transfer failed. | 文件传输失败。 | 文件传输失败 |
| away_activated.wav | See you soon. | 回头见。 | 设为离开状态 |
| away_deactivated.wav | Welcome back. | 欢迎回来。 | 回到在线状态 |
| greeting.wav | Welcome to TeamSpeak. | 欢迎使用 TeamSpeak。 | 问候（孤儿文件，未绑定事件） |
| testsound.wav | Testing your playback sound system. | 正在测试你的播放声音系统。 | 播放测试音 |
| 3d_test.wav | （无语音，纯音效） | — | 3D 定位测试 |
| stop_talking.wav | （无语音，纯音效） | — | 静音时说话提示 |
| mic_click_on.wav | （无语音，纯音效） | — | 按下按键说话 |
| mic_click_off.wav | （无语音，纯音效） | — | 松开按键说话 |
| whisper_notify.wav | （无语音，纯音效） | — | 悄悄话提示音 |

## 二、频道 / 服务器

| 文件名 | 音频英文原文 | 中文参考翻译 | 触发场景 |
| --- | --- | --- | --- |
| channel_created.wav | Channel created. | 频道已创建。 | 你创建频道 |
| channel_deleted.wav | Channel deleted. | 频道已删除。 | 你删除频道 |
| channel_edited.wav | Channel edited. | 频道已修改。 | 你修改其他频道 |
| your_channel_was_edited.wav | Your channel was edited. | 你的频道被修改了。 | 你的当前频道被他人修改 |
| channel_moved.wav | Channel moved. | 频道已移动。 | 你移动频道 |
| channel_switched.wav | Channel switched. | 频道已切换。 | 你切换频道 |
| you_edited_server.wav | You edited the server. | 你编辑了服务器。 | 你编辑服务器 |
| channelgroup_changed.wav | Channel group changed. | 频道组已变更。 | 你的频道组变更 |
| servergroup_assigned.wav | Server group assigned. | 已分配服务器组。 | 你获得服务器组 |
| servergroup_revoked.wav | Server group revoked. | 服务器组已撤销。 | 你的服务器组被移除 |
| you_were_moved.wav | You were moved. | 你被移动了。 | 你被移动到其他频道 |

## 三、他人加入 / 离开 / 移动（friend = 好友 / neutral = 中立 / blocked_user = 黑名单）

### 进入频道（connection_connected / switched_tocurrentchannel）

| 文件名 | 音频英文原文 | 中文参考翻译 |
| --- | --- | --- |
| friend_connection_connected_currentchannel.wav | Buddy entered your channel. | 好友进入了你的频道。 |
| neutral_connection_connected_currentchannel.wav | User entered your channel. | 用户进入了你的频道。 |
| blocked_user_connection_connected_currentchannel.wav | Blocked user entered your channel. | 黑名单用户进入了你的频道。 |
| friend_switched_tocurrentchannel.wav | Buddy joined your channel. | 好友加入了你的频道。 |
| neutral_switched_tocurrentchannel.wav | User joined your channel. | 用户加入了你的频道。 |
| blocked_user_switched_tocurrentchannel.wav | Blocked user joined your channel. | 黑名单用户加入了你的频道。 |

### 离开频道（switched_awayfromcurrentchannel）

| 文件名 | 音频英文原文 | 中文参考翻译 |
| --- | --- | --- |
| friend_switched_awayfromcurrentchannel.wav | Buddy left your channel. | 好友离开了你的频道。 |
| neutral_switched_awayfromcurrentchannel.wav | User left your channel. | 用户离开了你的频道。 |
| blocked_user_switched_awayfromcurrentchannel.wav | Blocked user left your channel. | 黑名单用户离开了你的频道。 |

### 断开 / 超时（connection_disconnected / connection_connectionlost）

| 文件名 | 音频英文原文 | 中文参考翻译 |
| --- | --- | --- |
| friend_connection_disconnected_currentchannel.wav | Buddy disconnected from your channel. | 好友与你的频道断开了连接。 |
| neutral_connection_disconnected_currentchannel.wav | User disconnected from your channel. | 用户与你的频道断开了连接。 |
| blocked_user_connection_disconnected_currentchannel.wav | Blocked user disconnected from your channel. | 黑名单用户与你的频道断开了连接。 |
| friend_connection_connectionlost_currentchannel.wav | Buddy in your channel timed out. | 你频道里的好友超时了。 |
| neutral_connection_connectionlost_currentchannel.wav | User in your channel timed out. | 你频道里的用户超时了。 |
| blocked_user_connection_connectionlost_currentchannel.wav | Blocked user in your channel timed out. | 你频道里的黑名单用户超时了。 |

### 被移入 / 移出频道（moved_tocurrentchannel / moved_awayfromcurrentchannel）

| 文件名 | 音频英文原文 | 中文参考翻译 |
| --- | --- | --- |
| friend_moved_tocurrentchannel.wav | Buddy was moved to your channel. | 好友被移到了你的频道。 |
| neutral_moved_tocurrentchannel.wav | User was moved to your channel. | 用户被移到了你的频道。 |
| blocked_user_moved_tocurrentchannel.wav | Blocked user was moved to your channel. | 黑名单用户被移到了你的频道。 |
| friend_moved_awayfromcurrentchannel.wav | Buddy was moved out of your channel. | 好友被移出了你的频道。 |
| neutral_moved_awayfromcurrentchannel.wav | User was moved out of your channel. | 用户被移出了你的频道。 |
| blocked_user_moved_awayfromcurrentchannel.wav | Blocked user was moved out of your channel. | 黑名单用户被移出了你的频道。 |

### 被踢入 / 踢出频道（kicked_channel_tocurrentchannel / kicked_channel_awayfromcurrentchannel）

| 文件名 | 音频英文原文 | 中文参考翻译 |
| --- | --- | --- |
| friend_kicked_channel_tocurrentchannel.wav | Buddy was kicked to your channel. | 好友被踢到了你的频道。 |
| neutral_kicked_channel_tocurrentchannel.wav | User was kicked to your channel. | 用户被踢到了你的频道。 |
| blocked_user_kicked_channel_tocurrentchannel.wav | Blocked user was kicked to your channel. | 黑名单用户被踢到了你的频道。 |
| friend_kicked_channel_awayfromcurrentchannel.wav | Buddy was kicked out of your channel. | 好友被踢出了你的频道。 |
| neutral_kicked_channel_awayfromcurrentchannel.wav | User was kicked out of your channel. | 用户被踢出了你的频道。 |
| blocked_user_kicked_channel_awayfromcurrentchannel.wav | Blocked user was kicked out of your channel. | 黑名单用户被踢出了你的频道。 |

### 被踢出服务器 / 被拉黑（kicked_server / banned_server）

| 文件名 | 音频英文原文 | 中文参考翻译 |
| --- | --- | --- |
| friend_kicked_server_currentchannel.wav | Buddy in your channel was kicked from the server. | 你频道里的好友被踢出了服务器。 |
| neutral_kicked_server_currentchannel.wav | User in your channel was kicked from the server. | 你频道里的用户被踢出了服务器。 |
| blocked_user_kicked_server_currentchannel.wav | Blocked user in your channel was kicked from the server. | 你频道里的黑名单用户被踢出了服务器。 |
| friend_banned_server_currentchannel.wav | Buddy in your channel was banned from the server. | 你频道里的好友被封禁了。 |
| neutral_banned_server_currentchannel.wav | User in your channel was banned from the server. | 你频道里的用户被封禁了。 |
| blocked_user_banned_server_currentchannel.wav | Blocked user in your channel was banned from the server. | 你频道里的黑名单用户被封禁了。 |

## 四、录音 / 发言权

| 文件名 | 音频英文原文 | 中文参考翻译 | 触发场景 |
| --- | --- | --- | --- |
| neutral_recording_active_currentchannel.wav | User in your channel is recording. | 你频道里的用户正在录音。 | 有人在频道里录音 |
| neutral_recording_started_currentchannel.wav | User in your channel started recording. | 你频道里的用户开始录音了。 | 有人开始录音 |
| neutral_recording_stopped_currentchannel.wav | User in your channel stopped recording. | 你频道里的用户停止录音了。 | 有人停止录音 |
| talkpower_granted.wav | Talk power granted. | 已授予发言权。 | 你被授予发言权 |
| talkpower_revoked.wav | Talk power revoked. | 发言权已撤销。 | 你的发言权被收回 |
| talkpower_requested.wav | User requested talk power. | 用户请求了发言权。 | 有人请求发言权 |

## 五、自己（被踢 / 拉黑 / 麦克风 / 声音）

| 文件名 | 音频英文原文 | 中文参考翻译 | 触发场景 |
| --- | --- | --- | --- |
| you_kicked_server.wav | You were kicked from the server. | 你被踢出了服务器。 | 你被踢出服务器 |
| you_kicked_channel.wav | You were kicked from the channel. | 你被踢出了频道。 | 你被踢出频道 |
| you_were_banned.wav | You were banned from the server. | 你被封禁了。 | 你被拉黑 |
| mic_activated.wav | Microphone activated. | 麦克风已启用。 | 麦克风恢复 |
| mic_muted.wav | Microphone muted. | 麦克风已静音。 | 麦克风被静音 |
| sound_muted.wav | Sound muted. | 声音已静音。 | 输出被静音 |
| sound_resumed.wav | Sound resumed. | 声音已恢复。 | 输出恢复 |

## 六、悄悄话（Whisper）

| 文件名 | 音频英文原文 | 中文参考翻译 |
| --- | --- | --- |
| whisperlist_is_empty.wav | Whisper list is empty. | 悄悄话列表为空。 |
| no_whisper_target_found.wav | No whisper target found. | 未找到悄悄话目标。 |
| too_many_whisper_targets.wav | Too many whisper targets. | 悄悄话目标太多。 |
| whisper_notify.wav | （无语音，纯音效） | — |

## 七、聊天消息

| 文件名 | 音频英文原文 | 中文参考翻译 |
| --- | --- | --- |
| chat_message_inbound.wav | （无语音，纯音效） | — |
| chat_message_outbound.wav | （无语音，纯音效） | — |

> 注：官方默认包（Female）中这两个文件为 `play()` 音效事件（收到/发送消息的提示音），不含语音文字；官方 TTS 版对应文本为 "Message received" / "Message sent"。

## 附录：纯音效文件清单（无语音文字，共 7 个）

| 文件 | 对应事件 | 说明 |
| --- | --- | --- |
| 3d_test.wav | SPECIAL_3D_TEST | 3D 定位测试音 |
| stop_talking.wav | SPECIAL_TALKING_WHILE_MUTED | 静音时说话的提示音 |
| mic_click_on.wav | SPECIAL_MIC_CLICK_SELF/OTHER_ON | 按键咔哒声 |
| mic_click_off.wav | SPECIAL_MIC_CLICK_SELF/OTHER_OFF | 松键咔哒声 |
| whisper_notify.wav | SPECIAL_WHISPER_NOTIFY | 悄悄话提示音 |
| chat_message_inbound.wav | CHAT_RECEIVED_MESSAGE_* | 收到消息提示音 |
| chat_message_outbound.wav | CHAT_SENT_MESSAGE_* | 发送消息提示音 |

---

### 验证说明

- 转写工具：faster-whisper（small → 初转全部 79 个文件；medium / large-v3 → 复核低置信度与存疑文件）。
- 复核点：`friend_*`/`neutral_*`/`blocked_user_*` 系列中的 "in your channel"（初转曾误听为 "and your"）、`you_were_banned`（误听为 "bound"，确认 "banned"）等均已由 large-v3 高置信度修正。
- 音效判定：7 个音效文件经 whisper 多模型多参数测试（仅产生低置信度幻觉）、MediaKit 语音活动检测（无有效人声段）、时长特征（0.03–0.47s）三重交叉验证。
- 原始转写数据：`docs/transcripts.json`；转写脚本：`scripts/transcribe_all.py`。
