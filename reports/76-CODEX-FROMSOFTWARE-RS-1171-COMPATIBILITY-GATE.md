# 76-CODEX-FROMSOFTWARE-RS-1171-COMPATIBILITY-GATE

审计性质：公开源码与本机文件的有界只读核验。未启动游戏，未读取游戏进程，未构建或注入 DLL，未修改 ERAI、游戏、参数、存档或安全设置。

## 结论

**TRACEABLE_MAPPING_FOUND**，但映射精度为“ProductVersion/RVA 表可追溯”，不是“本机 EXE SHA256 已由上游逐字节确认”。

上游存在明确提交 `29fd1381ce458d5748c1fd2d188a808471f11972`（`[ER] Update RVAs for 1.17.1`），其 `rva.rs` 将英文 `2.7.1.0` 映射为 `Ww2710`，并选择 `rva_ww::RVAS`。因此当前本机版本有可追溯的版本映射来源。该提交没有声明或提供本机 EXE SHA256 白名单；RVA 表也不是本机运行时验证。结构定义和所有候选接口仍须在本机 Windows/1.17.1 中另行、受控验证，不能直接接入 ERAI。

## A. 本机目标核验

- 文件：`<GAME_ROOT>\RING\Game\eldenring.exe`
- FileVersion：`2.7.1.0`
- ProductVersion：`2.7.1.0`
- 大小：`87042128` bytes
- SHA256：`1A3547101327F65D0C76DA2F9190AC0AA66871EA42BAE2AECC61E11A8B597891`
- 该 SHA256 与任务给定值一致。
- 未将同一 ProductVersion 自动等同于同一二进制布局；上游映射提交没有列出该 SHA256。

## B. 来源、提交与版本映射

1. `https://github.com/vswarte/fromsoftware-rs/commit/29fd1381ce458d5748c1fd2d188a808471f11972`
   - 提交消息：`[ER] Update RVAs for 1.17.1`
   - `crates/eldenring/src/rva.rs`：`(LANG_ID_EN, "2.7.1.0") => Some(Self::Ww2710)`。
   - 同一提交更新 WW/JP RVA 文件；这是当前版本映射的直接来源。
2. `https://github.com/vswarte/fromsoftware-rs/blob/29fd1381ce458d5748c1fd2d188a808471f11972/crates/eldenring/src/rva/rva_ww.rs`
   - WW 2.7.1.0 RVA bundle。已核对存在 `game_data_man=0x3d61f98`、`player_ins_vmt=0x2a7fbb0`、`chr_ins_vmt=0x2a310c8`、`chr_set_vmt=0x2a41348` 等条目。
   - 该表没有把 WorldChrMan 全局槽作为一个可直接采集的旧式固定地址来源。
3. 结构更新提交：`b0809157d82316257f9f0909a68aeb7cfc966d92`，消息 `[ER] Update some strucs for 1.17`。
   - 提交只显示部分 `ChrIns` 与 `PlayerGameData` 字段布局更新；它不是一份“本机 2.7.1.0 SHA256 结构验证报告”。
4. v0.14.0 标签完整对象 SHA：`b5d74dac46090adad74e3b425f598d0a9ca3764f`。
   - v0.14.0 的 `rva.rs` 只登记 2.6.2.x（WW `Ww262`），没有 2.7.1.0；因此不能把 v0.14.0 标签本身当作当前 1.17.1 映射。
5. 外部说明：`https://github.com/rehan-remade/universal-modder/commit/fd57f274d3f488660414fef6bf7fc3fb5c3882c1`。
   - 文档声称 `2.7.1.0 = Ww2710`，并记录 Linux/Proton 实验路线；同时明确 Windows、其它版本和联机未验证。它是外部作者实验描述，不是 ERAI 本机验证。

## C. 玩家身份候选：WorldChrMan.main_player

来源：固定提交中的 `crates/eldenring/src/cs/world_chr_man.rs` 和 `crates/eldenring/src/cs/chr_ins.rs`。

- `WorldChrMan` 使用 `#[shared::singleton("WorldChrMan")]`；字段 `main_player: Option<OwnedPtr<PlayerIns>>` 的源码注释是 “Points to the local player”。
- `PlayerIns` 直接包含 `chr_ins: ChrIns` 与 `player_game_data: NonNull<PlayerGameData>`。
- `PlayerGameData` 有 `is_main_player: bool`，源码注释是该数据属于 main/local player。

证据等级：

- `main_player` 语义：**SOURCE-SUPPORTED**（明显强于 `id==1`、最近对象或历史 WCM 偏移猜测）。
- 当前本机地址、singleton 解析、指针有效性和 1.17.1 运行时生命周期：**UNAVAILABLE / ERAI_VERIFIED=NO**。
- 不能把该字段注释直接升级为本机可靠玩家来源。`WorldChrMan::instance()` 还依赖 shared singleton/reflection 机制，不能按旧固定 WCM 槽直接读取。

## D. 骨灰对象识别：SummonBuddyManager

同一 `world_chr_man.rs` 定义：

- `WorldChrMan::summon_buddy_manager: OwnedPtr<SummonBuddyManager>`，源码注释为管理 spirit summons（不含 Torrent）。
- `SummonBuddyManager::groups: DLMap<i32, DLList<SummonBuddyGroup>>`，注释为按 character event id 映射到其拥有的 summon buddy groups。
- `SummonBuddyGroup::chr_ins: NonNull<ChrIns>`，并有 `buddy_param_id`、`buddy_stone_param_id`、`warp_requested`、`disappear_requested`、`disable_pc_target_share`、`follow_type` 等字段。

证据等级：

- 组→成员 `chr_ins` 及 Buddy 参数标识：**SOURCE-SUPPORTED**。
- 能在当前 Windows/1.17.1 进程中安全取得该 manager、遍历容器、确认五只目标成员及生命周期：**ERAI_VERIFIED=NO / UNAVAILABLE**。
- 这是一个对象关系候选来源，不能与已完成的 regulation 验收混为一谈。

## E. 玩家状态：PlayerGameData

固定结构中可见：

- `current_hp`、`current_max_hp`、`base_max_hp`（以及 FP/stamina 对应字段）。
- `is_main_player`。
- `PlayerIns.player_game_data` 指向该结构。

证据等级：

- 字段存在及源码语义：**SOURCE-SUPPORTED**。
- 当前 EXE 中字段偏移、读取安全性、采样时序及和玩家威胁的实时关系：**UNAVAILABLE / ERAI_VERIFIED=NO**。
- 外部文档关于 HP/FP/stamina 的描述同样只是外部实验记录，不能替代本机验证。

## F. 威胁候选：ChrIns.last_hit_by

- `ChrIns::last_hit_by: FieldInsHandle`，源码注释是“what field ins you were last hit by”。
- 外部固定文档称可通过 `WorldChrMan.chr_inses_by_distance` 解析，并明确指出 `last_hit_by` 会永久保留最后攻击者；死亡归因可能陈旧。

证据等级：

- 字段是“最后一次命中者句柄”：**SOURCE-SUPPORTED**。
- 它是当前威胁、攻击目标或玩家受袭实时状态：**UNAVAILABLE**。不能直接用作实时 threat/aggro 判据。
- 依赖 `chr_inses_by_distance` 的解析也属于对象遍历路径；本任务没有授权恢复旧全局/人物扫描。

## G. 成员级目标/返回/导航控制

在限定的 `WorldChrMan`、`SummonBuddyManager`、`SummonBuddyGroup`、`ChrIns`、`PlayerGameData` 源码范围内：

- 可见管理字段和状态字段（例如 `warp_requested`、`disappear_requested`、`follow_type`、`disable_pc_target_share`）。
- 未找到可由公开源码证明的、针对指定成员安全设置目标、终止追击、导航或“部分留守/部分接敌”的高层控制 API。
- `warp_requested`/`disappear_requested` 是状态/请求字段，不能据此推导安全运行时写接口。
- `ChrIns` 中的公开 setter/动作相关字段也不是已验证的成员 AI 控制契约。

结论：成员级目标/返回/导航 API = **UNAVAILABLE**；不能从可写字段推断可实施的动态护卫控制。

## H. 与当前 EXE 的匹配程度

| 项目 | 状态 | 说明 |
|---|---|---|
| 文件版本 | VERSION_SUPPORTED | 本机 File/ProductVersion 均为 2.7.1.0 |
| Ww2710 版本映射 | TRACEABLE / SOURCE_EXISTS | 固定提交 29fd… 的 `rva.rs` 明确登记 |
| 精确 EXE SHA256 映射 | UNAVAILABLE | 上游提交没有该 SHA 白名单或逐字节声明 |
| RVA 表 | SOURCE_EXISTS | 固定提交提供 WW 2.7.1.0 bundle |
| WorldChrMan/main_player 结构 | SOURCE-SUPPORTED | 语义清晰，但本机布局/指针未验证 |
| SummonBuddyManager/groups/chr_ins | SOURCE-SUPPORTED | 关系定义清晰，但运行时容器未验证 |
| PlayerGameData HP/is_main_player | SOURCE-SUPPORTED | 字段定义存在，偏移/时序未验证 |
| last_hit_by 实时威胁 | UNAVAILABLE | 仅最后命中句柄，外部资料也警告会陈旧 |
| 成员级 AI 控制 API | UNAVAILABLE | 本次限定审计没有可信控制契约 |
| Windows/me3 C 环境实测 | UNAVAILABLE | 外部资料只实测 Linux/Proton；本轮未启动游戏 |

## I. 对下一步有限只读原型的批准意见

本报告不批准直接运行原型。若 L3 仍要推进，唯一合理的下一步是另行批准一个**极小、纯只读、Windows 用户桌面启动的单快照结构验证**：仅验证 `WorldChrMan` singleton 解析→`main_player`→`PlayerIns.player_game_data` 的指针有效性和只读 HP/is_main_player 读取；不枚举角色，不访问 `SummonBuddyManager.groups`，不使用 `last_hit_by` 作威胁判据，不写内存，不调用游戏函数，不注入 DLL。该动作必须先固定构建来源、Windows/me3 运行环境与失败止损规则。

在没有该验证之前，不能把 main_player、HP、SummonBuddyGroup 或 last_hit_by 登记为 ERAI 可用运行时接口，也不能据此宣称智能护卫可行。

## J. 保护边界与唯一下一步建议

- 本轮没有游戏启动、进程读写、DLL/native 构建、参数修改或文件部署。
- 当前已验收的召唤数量/种类资产不受影响。
- 唯一建议：由 L3 裁决是否批准上述“单快照、只读 main_player 结构验证”；若不批准，应保持 71 的 REFERENCE_ONLY 结论，不再从公开结构推导玩家保护功能。

**最终裁决：TRACEABLE_MAPPING_FOUND（仅版本/RVA 可追溯；精确 EXE SHA、运行时布局、成员控制均未验证）。**