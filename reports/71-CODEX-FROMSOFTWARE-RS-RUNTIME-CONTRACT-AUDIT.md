# 71-CODEX-FROMSOFTWARE-RS-RUNTIME-CONTRACT-AUDIT

审计范围：只读检查指定的 `universal-modder` 文档和 `fromsoftware-rs v0.14.0` 公开源码。未安装插件、未运行第三方程序、未构建或注入 DLL、未启动游戏、未读取游戏进程、未修改 ERAI 项目。

## A. 资料与版本证据

1. Universal Modder 文档：
   `https://github.com/rehan-remade/universal-modder/blob/main/knowledge/games/elden-ring/cs2-conversion-of-elden-ring-offline-native-rust-dll-via-me3.md`
   文档自述环境为 Elden Ring 1.17.1、exe ProductVersion 2.7.1.0、me3 0.13.0，并称使用 `fromsoftware-rs 0.14.0` 的 vendored/patched 副本。它还明确写明只在 Linux/Proton 实际运行，Windows 未验证。

2. `fromsoftware-rs` v0.14.0：
   `https://github.com/vswarte/fromsoftware-rs/releases/tag/v0.14.0`
   发布提交为 `9028518`。该版本发布说明包含 Elden Ring 1.16.2 更新。固定源码 `crates/eldenring/src/rva.rs` 的 `ERGameVersion` 只匹配英文 `2.6.2.0` 和日文 `2.6.2.1`，没有 1.17.1/2.7.1.0 的官方匹配。

结论：`SOURCE_EXISTS = YES`；上游 v0.14.0 对本机 Elden Ring 1.17.1 的 `VERSION_SUPPORTED = NO/UNCONFIRMED`。Universal Modder 的 `Ww2710` 说法属于 `EXTERNALLY_REPORTED`，因为其 vendored/patched 代码和精确提交未在本审计中建立为上游 v0.14.0 的版本映射。

## B. WorldChrMan.main_player

源码：`crates/eldenring/src/cs/world_chr_man.rs`。

实际定义：`#[shared::singleton("WorldChrMan")]`；字段 `main_player: Option<OwnedPtr<PlayerIns>>` 的注释为“Points to the local player”。这是比 `id == 1`、最近对象、历史 WCM 偏移猜测更强的身份语义来源。

分类：

- `SOURCE_EXISTS`：VERIFIED（公开源码中的类型和注释存在）。
- `IDENTITY_SEMANTICS`：SOURCE-SUPPORTED（源码直接把它定义为 local player）。
- `VERSION_SUPPORTED`：UNCONFIRMED（上游 v0.14.0 RVA 表不匹配目标 1.17.1）。
- `ERAI_VERIFIED`：NO。未在 ERAI 本机 1.17.1 进程中验证 singleton、指针、字段布局或生命周期。

因此它是一个新的候选语义来源，但不是可以直接接入 ERAI 的已确认玩家指针。

## C. 玩家位置、生命与最近攻击者

### 位置

`ChrIns`/`PlayerIns` 源码包含 `chunk_position`、`initial_position`、物理/模型相关字段；PlayerIns 还包含 `block_position` 和 `current_block_id`。Universal Modder 文档称 `PlayerIns.block_position/current_block_id` 与 MSB 区域位置解析一致，并声称在其 Linux/Proton 实验中验证过。

这证明了可研究的数据结构和外部实验路径，但没有证明当前 Windows/me3、当前 1.17.1 本机中这些字段的 RVA、布局和坐标语义。不能直接替代 ERAI 已验证的 SoldierPlanarPosition，也不能把它宣布为 PlayerPlanarPosition。

分类：`SOURCE_EXISTS = YES`，`EXTERNALLY_REPORTED = YES`，`ERAI_VERIFIED = NO`。

### 生命/状态

`crates/eldenring/src/cs/player_game_data.rs` 的 `PlayerGameData` 定义公开了 `character_event_id`、`player_id`、`current_hp`、`current_max_hp`、`current_fp`、`current_stamina` 等字段。文档描述其项目按 tick 比较这些值。

这提供了玩家状态的潜在只读来源，但同样没有当前 1.17.1 Windows 映射和本机运行证据。字段存在不等于读取地址已经可靠。

分类：`SOURCE_EXISTS = YES`，`EXTERNALLY_REPORTED = YES`，`ERAI_VERIFIED = NO`。

### 最近攻击者

`crates/eldenring/src/cs/chr_ins.rs` 定义 `ChrIns.last_hit_by: FieldInsHandle`，注释为最近击中该角色的 field-ins。Universal Modder 文档称可通过 `WorldChrMan.chr_inses_by_distance` 解析，并明确提醒其中 distance 是相对度量，不是米制距离。

这能支持“存在最后击中句柄”的研究方向，但不能单独证明攻击者身份、当前威胁、攻击方向或是否仍在威胁玩家。它也不是玩家受袭事件流。

分类：`SOURCE_EXISTS = YES`，`EXTERNALLY_REPORTED = YES`，`ERAI_VERIFIED = NO`。

## D. 骨灰识别与生命周期

`world_chr_man.rs` 提供了比旧通用枚举更具体的结构线索：

- `WorldChrMan.summon_buddy_manager`：管理 spirit summons。
- `SummonBuddyManager.chr_set`：SummonBuddy 的 ChrSet 引用。
- `SummonBuddyManager.groups`：按 character event id 映射到 SummonBuddy groups。
- `SummonBuddyGroup.chr_ins`：该成员的 `ChrIns`。
- `SummonBuddyGroup.buddy_param_id` 和 `buddy_stone_param_id`：成员来源身份字段。
- `warp_requested`、`disappear_requested`、`has_spawn_point`、`follow_type` 等生命周期/跟随相关状态。
- `SummonBuddyWarpManager` 暴露 warp 阶段、目标位置、距离/阻挡阈值等结构字段。

这些字段在语义上比“全局扫描找到一个像骨灰的对象”更强，而且可以按 SummonBuddy 成员关联到 `BuddyParam`。但是它们依赖未验证的 1.17.1 RVA、布局和指针有效性。源码只展示结构和部分数据访问；没有发现一个已证实、按成员设置目标/跟随/导航任务的安全高层 API。

分类：对象识别和生命周期结构 `SOURCE_EXISTS/SOURCE-SUPPORTED`；当前版本 `ERAI_VERIFIED = NO`；目标控制 API `UNAVAILABLE`。

## E. 控制接口审计

发现的接口性质：

1. `WorldChrMan::chr_ins_by_handle` / `ChrSet::chr_ins_by_handle`：可按句柄查找 `ChrIns`，属于读取/对象解析帮助，不是 AI 目标控制。
2. `IChrFinder` / `NearEnemyFinder`：描述按敌对 team type 查找角色的 finder，属于搜索结构；没有证明它能把结果写入骨灰 AI 任务。
3. `ChrInsExt::apply_speffect`、`remove_speffect`：源码明确通过 RVA 转换后调用游戏函数，属于游戏状态写入路径，不是本轮允许的只读接口，也不能据此宣称护卫控制。
4. `WorldChrMan::spawn_debug_character`：设置 debug creator 并触发 spawn，属于写/生成行为，禁止纳入 ERAI 方案。
5. `SummonBuddyWarpManager` 的字段和 `follow_type`：是结构状态证据，不是已经证明可安全设置的返回/导航 API。

结论：当前公开源码没有找到经过 1.17.1 验证、无需调用游戏函数即可按成员改变目标、跟随、返回或导航的真实 API。`SOURCE_EXISTS` 不等于 `CONTROL_CONTRACT`。

## F. 对 ERAI 需求的回答

| 问题 | 证据分类 | 结论 |
|---|---|---|
| fromsoftware-rs 0.14.0 是否支持本机 1.17.1 | `VERSION_SUPPORTED` | 上游固定 RVA 表不支持；仅外部 patched 项目声称有 Ww2710。 |
| `WorldChrMan.main_player` 是否是可靠身份来源 | `SOURCE-SUPPORTED` | 语义上是 local player，明显强于旧 id/WCM 偏移路线；本机未验证。 |
| 玩家位置、生命、最近攻击者 | `SOURCE_EXISTS / EXTERNALLY_REPORTED` | 结构字段和外部使用存在；当前 Windows/1.17.1 未验证，不能直接接入。 |
| 骨灰对象和生命周期 | `SOURCE-SUPPORTED` | SummonBuddyManager/Group 提供成员、BuddyParam、句柄和生命周期字段；当前版本未验证。 |
| 按成员控制目标/跟随/返回/导航 | `UNAVAILABLE` | 没有发现可提交的、已验证的高层控制契约；写入函数不在本轮安全边界内。 |
| 当前 Windows/me3 C 环境可直接使用 | `UNAVAILABLE` | 外部项目在 Linux/Proton；文档明确 Windows 未验证，且其 DLL 为 vendored/patched Rust native。 |

## G. 与 ERAI 旧路线的关系

这不是旧 `id == 1`、g_others、roster、ChrSet 全局扫描或历史 WCM 槽位的直接重复：`main_player` 和 `SummonBuddyManager.groups` 提供了明确的引擎语义名和成员归属。另一方面，实际取得它们仍需要 singleton/RVA/进程内结构访问；因此不能绕过既有 CLOSED/STOP 决策，不能直接恢复旧扫描，也不能以公开字段名替代当前版本验证。

## H. 安全与运行时缺口

仍缺少：

1. 精确的、对应本机 Elden Ring 1.17.1 EXE SHA256 的 `Ww2710` RVA bundle；
2. `WorldChrMan`、`PlayerIns`、`SummonBuddyManager` 在该版本中的布局和指针验证；
3. Windows/me3 0.13.0 下 native DLL 加载、初始化时机和安全只读封装验证；
4. 以 `main_player` 读取位置/HP、以 `SummonBuddyGroup` 识别当前 1～5 个大盾兵的最小运行时证据；
5. 不写内存的威胁状态来源；
6. 成员级 AI 目标/返回/导航控制契约。

## I. 对玩家保护系统的实际价值

这些资料能把未来“玩家是谁”和“哪些 `ChrIns` 属于召唤组”从无身份依据的猜测，推进到有明确源码语义的候选结构；`last_hit_by` 还能作为受袭记录的候选证据。它们不能证明玩家保护已经实现，也不能证明存在安全的成员级控制入口。当前最小价值是未来建立只读身份/状态验证，不能直接形成护卫行为。

## J. 最小下一步（需要新的 L3 授权）

只允许做一次静态兼容性核验：取得 Universal Modder 使用的、明确固定提交的 vendored `Ww2710` RVA/结构来源，与本机 1.17.1 EXE 版本和哈希逐项对照；不构建、不注入、不启动、不读进程。若无法取得固定来源或映射不闭合，立即停止，不转入运行时验证。

## K. 最终分类

`REFERENCE_ONLY`

理由：公开源码确实提供了有价值的 `main_player`、玩家状态、`last_hit_by`、SummonBuddy 分组和生命周期结构，但上游 v0.14.0 没有本机 1.17.1 官方 RVA 映射，外部文档使用的是未固定的 patched/vendor 版本，且未提供成员级护卫控制契约。当前不能登记为 `NEW_CONTRACT_CANDIDATE`，也不应称为 ERAI 已验证来源。
