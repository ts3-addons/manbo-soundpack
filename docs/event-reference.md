# 音效事件 → 文件名 对照表

`src\sound\Manbo Soundpack\settings.ini` 的 `[soundfiles]` 段把 TS3 事件映射到音频文件。
下表是常用事件对照（完整列表以 settings.ini 为准）。

> `${clientType}` 通配符：TS3 会按与你的关系展开为 `friend`（好友）/ `neutral`（中立）/ `blocked_user`（黑名单，官方文件名带 `_user_`）三类，因此一个规则对应三个文件。

## 连接与常规

| 事件 | 触发场景 | 文件名 |
| --- | --- | --- |
| CONNECTION_CONNECTED | 成功连接服务器 | `connected.wav` |
| CONNECTION_DISCONNECTED | 主动断开 | `disconnected.wav` |
| CONNECTION_LOST_CONNECTION | 连接中断 | `connection_lost.wav` |
| OTHER_RECEIVED_POKE | 被戳一戳 | `you_were_poked.wav` |
| OTHER_FILETRANSFER_COMPLETE | 文件传输完成 | `filetransfer_complete.wav` |
| OTHER_FILETRANSFER_FAILED | 文件传输失败 | `filetransfer_failed.wav` |
| SPECIAL_SOUND_TEST | 测试音效 | `testsound.wav` |
| SPECIAL_3D_TEST | 3D 定位测试 | `3d_test.wav` |
| SPECIAL_TALKING_WHILE_MUTED | 麦克风被静音时说话 | `stop_talking.wav` |
| SPECIAL_MIC_CLICK_SELF_ON / OFF | 自己按下/松开按键说话 | `mic_click_on.wav` / `mic_click_off.wav` |

## 频道 / 服务器

| 事件 | 触发场景 | 文件名 |
| --- | --- | --- |
| CHANNEL_CREATED_BY_YOU | 你创建频道 | `channel_created.wav` |
| CHANNEL_DELETED_BY_YOU | 你删除频道 | `channel_deleted.wav` |
| CHANNEL_EDITED_CURRENT_BY_OTHER | 你的当前频道被他人修改 | `your_channel_was_edited.wav` |
| CHANNEL_EDITED_OTHER_BY_YOU | 你修改其他频道 | `channel_edited.wav` |
| CHANNEL_MOVED_BY_YOU | 你移动频道 | `channel_moved.wav` |
| YOU_SWITCHED_CHANNEL | 你切换频道 | `channel_switched.wav` |
| YOU_WERE_MOVED_TO_DIFFERENT_CHANNEL | 你被移动到其他频道 | `you_were_moved.wav` |
| SERVER_EDITED_BY_YOU | 你编辑服务器 | `you_edited_server.wav` |
| SERVER_ERROR | 操作出错 | `error.wav` |
| SERVER_INSUFFICIENT_PERMISSIONS | 权限不足 | `insufficient_permissions.wav` |

## 他人加入 / 离开 / 移动（含通配）

| 事件 | 文件名模板 |
| --- | --- |
| CLIENT_CONNECTION_CONNECTED_CURRENT_CHANNEL | `${clientType}_connection_connected_currentchannel.wav` |
| CLIENT_CONNECTION_DISCONNECTED_CURRENT_CHANNEL | `${clientType}_connection_disconnected_currentchannel.wav` |
| CLIENT_CONNECTION_LOST_CONNECTION_CURRENT_CHANNEL | `${clientType}_connection_connectionlost_currentchannel.wav` |
| CLIENT_SWITCHED_TO_CURRENT_CHANNEL_APPEARS | `${clientType}_switched_tocurrentchannel.wav` |
| CLIENT_SWITCHED_FROM_CURRENT_CHANNEL_DISAPPEARS | `${clientType}_switched_awayfromcurrentchannel.wav` |
| CLIENT_MOVED_TO_CURRENT_CHANNEL_APPEARS | `${clientType}_moved_tocurrentchannel.wav` |
| CLIENT_MOVED_FROM_CURRENT_CHANNEL_DISAPPEARS | `${clientType}_moved_awayfromcurrentchannel.wav` |
| CLIENT_WAS_KICKED_FROM_SERVER_CURRENT_CHANNEL | `${clientType}_kicked_server_currentchannel.wav` |
| CLIENT_WAS_BANNED_CURRENT_CHANNEL | `${clientType}_banned_server_currentchannel.wav` |

> 展开示例：`neutral_connection_connected_currentchannel.wav`（中立用户进入）、`friend_switched_tocurrentchannel.wav`（好友切到本频道）、`blocked_user_kicked_server_currentchannel.wav`（黑名单用户被踢出服务器）。

## 自己 / 权限 / 状态

| 事件 | 触发场景 | 文件名 |
| --- | --- | --- |
| YOU_WERE_KICKED_FROM_SERVER | 你被踢出服务器 | `you_kicked_server.wav` |
| YOU_WERE_KICKED_FROM_CHANNEL | 你被踢出频道 | `you_kicked_channel.wav` |
| YOU_WERE_BANNED | 你被拉黑 | `you_were_banned.wav` |
| YOU_WERE_GRANTED_TALK_POWER | 你被授予发言权 | `talkpower_granted.wav` |
| YOU_WERE_REVOKED_TALK_POWER | 你的发言权被收回 | `talkpower_revoked.wav` |
| YOU_SERVERGROUP_ADDED_BY_USER | 你获得服务器组 | `servergroup_assigned.wav` |
| YOU_SERVERGROUP_REMOVED_BY_USER | 你被移除服务器组 | `servergroup_revoked.wav` |
| YOU_CHANNELGROUP_CHANGED_BY_USER | 你频道组变更 | `channelgroup_changed.wav` |
| CLIENT_RECORDING_START / STOP | 有人开始/停止录音 | `neutral_recording_started/stopped_currentchannel.wav` |

## 聊天 / 麦克风状态

| 事件 | 触发场景 | 文件名 |
| --- | --- | --- |
| CHAT_RECEIVED_MESSAGE_CLIENT | 收到私聊消息 | `chat_message_inbound.wav` |
| CHAT_SENT_MESSAGE_CLIENT | 发送私聊消息 | `chat_message_outbound.wav` |
| SOUND_CAPTURE_MUTED | 麦克风被静音 | `mic_muted.wav` |
| SOUND_CAPTURE_UNMUTED | 麦克风恢复 | `mic_activated.wav` |
| SOUND_PLAYBACK_MUTED | 输出被静音 | `sound_muted.wav` |
| SOUND_PLAYBACK_UNMUTED | 输出恢复 | `sound_resumed.wav` |
| STATUS_SET_AWAY | 离开状态 | `away_activated.wav` |
| STATUS_SET_PRESENT | 回到在线状态 | `away_deactivated.wav` |
