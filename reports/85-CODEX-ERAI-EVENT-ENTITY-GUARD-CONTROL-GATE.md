# 85-CODEX-ERAI-EVENT-ENTITY-GUARD-CONTROL-GATE

审计范围：仅阅读指定公开源码与文档；未运行第三方 DLL、未启动游戏、未修改 81 号资产。

## 1. 来源与版本

- `KamiyamaShiki0704/ER_Summon`：README.md、`src/lib.rs`、`src/chr_lifecycle.rs`、`src/retirement.rs`，当前公开 `main` 源码快照；仓库未在本次资料中提供可固定的提交 SHA，因此不能把分支快照当作不可变版本证据。
- README 声称实体注册和释放路径在 Worldwide 2.7.1.0（App Ver. 1.17.1）实测；源码也在 `src/lib.rs` 的版本检测中识别 `2.7.1.0`。这是第三方项目的外部运行声明，不是 ERAI 本机验证。
- `zoloypzuo/EldenRingAI/010000_logic.dec.lua`：公开脚本快照，仓库为旧版脚本资料，未证明与当前 1.17.1 的完整运行时脚本版本一致。
- ElaDiDu readable-ds-lua：公开 API 语义文档，提供事件请求、AI 目标和路径函数的参考定义，不是当前本机版本验证。

## 2. 成员身份机制

`ER_Summon` 的配置为每个 `[[summons]]` 条目提供独立的 `event_entity_id`。README 说明正整数 ID 用于事件脚本控制，多个同时存在的单位应使用不同 ID，并且同一角色集合内发生冲突时注册会被拒绝。

`src/lib.rs` 的生成路径先调用 `spawn_debug_character` 创建配置中的 NPC（包含 `npc_param_id`、`npc_think_param_id` 和 `event_entity_id`），绑定后再调用 `register_event_entity_id`。`src/chr_lifecycle.rs` 约 195–260 行通过 `FieldInsHandle`、`ChrSet` 条目一致性检查、角色字段和 `entity_id_mapping` 建立映射；约 282–340 行可按 ID 查找当前拥有该 ID 的句柄。

这证明了：

- 对项目自行生成并由该 DLL 绑定的 NPC，可以建立多个可区分的实体 ID。
- 映射有冲突拒绝和句柄/条目一致性检查。
- 释放路径会清理映射；但 README 明确说明切图、世界或玩家重置时不保证跨地图保存，不能把生命周期清理视为在所有场景可靠。

它没有证明：81号已经存在的原生大盾兵或孤狼会自动获得这些 ID。该项目的身份链建立在自己的生成/绑定流程上；没有看到把既有原生骨灰按 BuddyParam 或现有召唤句柄接入该注册流程的证据。因此对81号原生骨灰属于 `IDENTITY_ONLY` 的自定义实体机制，不能直接复用为原生成员身份契约。

## 3. 事件与 AI 行为证据

`ER_Summon` README 给出的 EMEVD 示例是 `ForceAnimationPlayback(event_entity_id, ...)`。这只能证明事件实体 ID 被作为事件寻址对象使用；不能证明动画指令会改变导航、追击目标或返回玩家。README 的日志说明也明确：角色集合映射能解析到该单位，并不代表所有事件指令都已验证。

`010000_logic.dec.lua` 只有 25 行：读取 `arg0:GetEventRequest()`；当请求为 100/110 时加入 `GOAL_COMMON_ApproachTarget`，请求为 80 且为 NPC 玩家时加入等待目标。它没有显示“返回玩家”“停止追敌”或按指定实体选择目标的契约，且 `TARGET_SELF`/`POINT_INITIAL` 的具体语义不能被解释成玩家回防。该文件不能证明它就是当前目标 81 号 Think 行的完整逻辑。

readable-ds-lua 文档确实描述了：

- `GetEventRequest` 与事件脚本的 `RequestCharacterAICommand`/`INTERUPT_EventRequest` 通信；
- `AddTopGoal`、`FollowPath`、目标/距离读取等 AI 脚本函数；
- `GetBuddyFollowType` 读取 BuddyParam 的跟随类型。

这些是脚本/API 语义参考，未给出当前 1.17.1 中针对某个原生骨灰实体的事件 ID、控制命令和目标数据流，也未证明存在“停止远追并回到玩家”的单一事件指令。

## 4. 与目标行为的对应关系

| 要求 | 结论 | 依据 |
|---|---|---|
| 每个自生成 NPC 可有独立身份 | SOURCE-SUPPORTED / 外部版本声明 | `event_entity_id` 配置、注册映射、冲突拒绝 |
| 81号原生骨灰可直接获得该身份 | UNAVAILABLE | 未发现原生 Buddy 成员接入注册路径 |
| 事件请求能触发某种 AI goal | SOURCE-SUPPORTED（脚本语义） | `GetEventRequest` + `AddTopGoal` 示例 |
| 事件请求能停止追敌并回玩家 | UNAVAILABLE | 无具体当前版本命令/目标契约 |
| `ForceAnimationPlayback` 提供导航控制 | 不成立 | 仅动画播放，不能替代导航/目标控制 |
| 成员死亡/释放时映射清理 | SOURCE-SUPPORTED，但跨图不完整 | `release_event_ids_for_handle`；README 的跨地图限制 |

## 5. 对ERAI的结论

**最终分类：`IDENTITY_ONLY`。**

新资料带来了比旧参数路线更清楚的“自生成 NPC → event_entity_id → ChrSet 映射”身份线索，也有 1.17.1 外部实测声明。但它不覆盖81号原生骨灰成员，且没有建立指定成员级停止追敌、跟随或回防的当前版本控制契约。没有满足“身份 + 控制”双门槛，不能提出真实回防实验，也不能称为智能护卫实现。

## 6. 首次回防仍缺少的证据

1. 能把81号原生 Buddy 成员安全绑定到独立、稳定的事件实体 ID；
2. 当前 1.17.1 的事件命令到该成员 AI 上下文的实际调用关系；
3. 一个明确改变目标/路径/追击状态的成员级命令，而非动画请求；
4. 成员死亡、切图和召回后的撤销与恢复契约。

若继续，需要用户另行批准运行时 DLL/Hook/游戏函数调用和内存写入，并先在隔离的自生成 NPC 上做最小验证；这不授权本轮执行，也不能替代81号原生骨灰方案。

## 7. 架构影响与建议

若未来只有自生成 NPC 才能获得可靠身份，ERAI 可能需要改变召唤架构，从原生 Buddy 成员转向受控自生成实体；这会引入 DLL、版本绑定、生命周期和兼容性风险，不能作为81号的小改动处理。

**结论：`IDENTITY_ONLY`；不建议进入86号运行时实验。**

引用：
- https://github.com/KamiyamaShiki0704/ER_Summon
- https://raw.githubusercontent.com/KamiyamaShiki0704/ER_Summon/master/src/lib.rs
- https://raw.githubusercontent.com/KamiyamaShiki0704/ER_Summon/master/src/chr_lifecycle.rs
- https://github.com/zoloypzuo/EldenRingAI/blob/master/010000_logic.dec.lua
- https://eladidu.github.io/readable-ds-lua/