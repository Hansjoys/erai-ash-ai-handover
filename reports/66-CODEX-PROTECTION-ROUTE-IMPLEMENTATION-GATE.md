# 66-CODEX-PROTECTION-ROUTE-IMPLEMENTATION-GATE

## 1. 裁决摘要

本轮为现有资产的只读实施门槛审查，不是保护功能实现、调参或游戏测试。

**推荐路线 3。当前智能护卫实现 NO-GO；保留召唤扩展与主动接敌资产，作为明确标注“非保护型”的有限实验版本。暂停智能护卫能力实施，等待可信的新控制依据。**

产品目标仍是“在 AI 能力范围内最大可能降低玩家风险”，并支持用户选择 1～5 只、种类与数量。这个目标没有被降级为主动进攻。实验资产保留不等于智能护卫产品完成，也不等于本轮授权制作正式发布包。

路线 1 当前不满足门槛：参数包能改变召唤和整体接敌倾向，但没有证据证明它能在持续威胁下保留部分成员护卫玩家。

路线 2 是可能需要的能力类别：原生 AI 脚本/事件或新的运行时控制。但现有资产未提供可信玩家威胁状态和安全成员控制契约，不能直接实施。本轮没有断言原生脚本、DLL 或 Hook 永远不可行。

发现并审查的具体脚本入口线索是 `NpcThinkParam.logicId / battleGoalID`。既有 22 行数据给出 `10000 / 700010`；这比继续猜 Think 距离字段更接近行为实现，但只有脚本选择元数据，没有对应逻辑和控制接口的证据。不能据此宣布找到护卫机制。

**OFFLINE PROTOTYPE = NOT CREATED。没有把模拟状态机、假玩家或离线自检称为真实保护实现。**

## 2. 范围、来源与证据等级

仓库：`<ERAI_ROOT>\工作区\erai-handover-2026-10-04`。

分支：`takeover/current-experimental-baseline`。

HEAD：`b3269455583be721fa627e78be54efd3cde2ba20`。审查前后 Git 工作树干净。

本轮读取当前源码、HANDOFF/FINDINGS、54～65 相关报告、64A 审计、50/62 包验证记录、22 的既有 Think 行原始数据、本机 PARAM 定义及 65 的实际 me3 日志。没有重新执行第三方工具，没有开展新 EXE 反汇编、全局地址扫描或运行时读取。

等级含义：

- **VERIFIED**：已有本机数据核验或限定场景游戏观察支持；只在原验证范围成立。
- **SOURCE-SUPPORTED**：源码、定义或文件接口存在；尚不等于当前游戏中的行为语义或效果成立。
- **HYPOTHESIS**：需要额外证据的技术假设。
- **UNAVAILABLE**：现有资产没有可用、可靠的接口或证据；不表示游戏本身不存在该能力。

主要证据路径：

- `<ERAI_ROOT>\_handoff-temp\50-CODEX-SUMMON-BASELINE-BUILD.md`
- `<ERAI_ROOT>\_handoff-temp\51-CODEX-SUMMON-BASELINE-LOAD-TEST.md`
- `<ERAI_ROOT>\_handoff-temp\53-CODEX-CONTROL-VS-AI-COMPARISON.md`
- `<ERAI_ROOT>\_handoff-temp\60-CODEX-AI-GUARD-DISTANCE-FEASIBILITY.md`
- `<ERAI_ROOT>\_handoff-temp\61-CODEX-AI-RETURN-GUARD-FEASIBILITY.md`
- `<ERAI_ROOT>\_handoff-temp\62-CODEX-AI-RETURN-GUARD-SINGLE-VARIABLE-TEST.md`
- `<ERAI_ROOT>\_handoff-temp\64A-CODEX-ENTITY-INSPECTOR-SOURCE-AUDIT.md`
- `<ERAI_ROOT>\_handoff-temp\65-CODEX-PROTECTION-FINAL-PRESSURE-AB.md`
- `<ERAI_ROOT>\work\summon-baseline-50\verification-manifest.json`
- `<ERAI_ROOT>\work\native-ai-pilot-22\verification.json`
- `<ERAI_ROOT>\work\native-ai-pilot-22\expected-new-think-row.bin`

旧 HANDOFF 中的“角色、拦截、部署功能”等历史描述，必须与当前源码、后续安全裁决和实际实验分开。旧设计存在不能抵消玩家来源 CLOSED、几何写入阻断和 65 未证明保护的事实。

## 3. 已验证原生资产与真实能力边界

本轮重新计算以下三包 SHA256，均与既有核验相符：

| 资产 | 路径 | SHA256 |
|---|---|---|
| CONTROL_SUMMON_BASELINE | `<ERAI_ROOT>\work\summon-baseline-50\CONTROL_SUMMON_BASELINE\package\regulation.bin` | `A9A255487C4AA0F899BC85B29DE1038D65229D122BA573253D331F0F1C322F34` |
| AI_SUMMON_BASELINE | `<ERAI_ROOT>\work\summon-baseline-50\AI_SUMMON_BASELINE\package\regulation.bin` | `D3C90B8E4BDB4699E0C8D13DC23CAB050AC4CDA6413937C450E79342EB6F658F` |
| AI_RETURN_GUARD_VARIANT | `<ERAI_ROOT>\work\summon-baseline-62\AI_RETURN_GUARD_VARIANT\package\regulation.bin` | `8ECB4C382FCF988E2644F823C123EA844D890F665769F406F7F3BA21E02F9125` |

50 验证清单记录：版本 `11711000`；BuddyStone 共 303 个非零 ID 修改，ID=0 不变；CONTROL 的 Think/Buddy 保留原版；AI 仅增加独立 Think 行并重关联五条目标 Buddy。AI 与 CONTROL 的 BuddyStone 字节哈希相同。

已验证范围：

- 大范围召唤、五只 +10 大盾兵出现、正常战斗、遣返后不坐火再召唤、正常退出：**VERIFIED**，依据 51/52 的用户验收。
- 五条 Buddy `24800000～24800004` 引用独立 Think `270001001`：文件层 **VERIFIED**；53/59 支持该整体 AI 预设更早主动响应。
- 999→10 单变量没有破坏本轮主动接敌：**VERIFIED**，限 62/65 观察。
- 62 部分成员回靠正向信号：**VERIFIED 的定性观察**；不能推导稳定护卫。
- 65 压力期间提前回靠、稳定留守、减少全员追敌、玩家安全收益：**未证明**。

me3 已验证提供隔离加载和 regulation override；它本身不是威胁识别器或成员行为控制器。

当前五名成员共用同一 AI Think 行，没有实现“哪个成员守、哪个成员接敌”的控制策略。逐 Buddy 分配不同 Think 在文件结构上有依据，但“不同 Think = 留守职责”没有证据。仅把行拆开不能保证队伍分工。

## 4. 候选路线逐项实施门槛

### 4.1 原生 Buddy/Think 与逐成员独立 Think

| 问题 | 等级 | 审查结果 |
|---|---|---|
| 1. 实际源码/验证依据 | VERIFIED | 行复制、Buddy 重关联、严格差异核验及加载/行为观察已存在。 |
| 2. 当前玩家身份 | UNAVAILABLE（对 ERAI） | 游戏原生跟随行为存在，但参数编辑不向 ERAI 提供本地玩家身份接口。 |
| 3. 指定骨灰 | VERIFIED | 文件层可隔离五条目标 Buddy 与 NPC/Think 引用。不能等同实时对象句柄。 |
| 4. 玩家受威胁状态 | UNAVAILABLE | 当前包没有可供 ERAI 使用的攻击者、受害者、未来攻击或玩家危险状态。 |
| 5. 改变追击/返回/选目标 | VERIFIED / SOURCE-SUPPORTED | 整体接敌倾向有观察；距离等字段存在。逐字段因果、主动返回控制未建立。 |
| 6. 自动控制部分留守 | HYPOTHESIS | 分配独立 Think 行可做静态差异，但没有可信“留守/护卫”字段契约。 |
| 7. 1～5 种类/数量配置 | SOURCE-SUPPORTED | Buddy 是编辑入口；目前只验证五只大盾兵。1～4、其它种类、普通用户配置交互未验收。 |
| 8. 未验证指针/Hook依赖 | VERIFIED（现有包不依赖） | 现有包只通过原生资源加载；新增护卫字段效果仍未知。 |
| 9. 安全有限实现维护 | VERIFIED / UNAVAILABLE | 既有包可复验回滚；真实护卫机制不足，不能安全制作下一组盲目组合。 |

`pcFollowType` 的本机定义说明 PC 跟随/warp，`disablePCTargetShare` 说明目标共享开关，`isGuard_Act` 说明自身行动举盾；都没有说明“分出成员保护玩家”。举盾和传送不是阻断玩家受袭的可靠接口。`TeamAttackEffectivity` 限制同时攻击人数的说明也不规定剩余成员站在玩家附近；21 原值为 0 的停止裁决保留。

结论：当前纯参数路线可维护，但未达到保护 MVP 门槛。不得继续 backhomeBattleDist 或盲目字段组合。

### 4.2 原生 AI 逻辑/战斗 Goal 与事件控制——新候选类别审查

具体来源：

- 本机定义 `<GAME_ROOT>\Smithbox_2_2_6_2026_09_20_b\Assets\PARAM\ER\Defs\NpcThinkParam.xml` 第 29～41 行：`s32 logicId`，说明脚本逻辑 ID；`s32 battleGoalID`，说明战斗 Goal ID。
- 同定义第 177～194 行把 backhome 等描述为 `COMMON_SetBattleActLogic` 的参数。说明这些字段由更深的行为逻辑解释，不能仅凭名称推出玩家保护语义。
- 22 已有 `expected-new-think-row.bin` 长 228 B，按上述定义读取 +0x04/+0x08 小端 s32 得到 `logicId=10000`、`battleGoalID=700010`。这是既有预期新行的实际字节，非运行时对象地址，也不是本轮重新解包得到的调用证明。
- 本轮检查仓库与 <OWNER>-Mod-Workshop 中相关 Lua/luabnd/EMEVD/ESD 文件名，没有取得对应目标 AI 脚本或玩家保护事件实现。该检查仅针对受审目录，不能推出游戏没有这些资源。

| 问题 | 等级 | 审查结果 |
|---|---|---|
| 1. 实际源码/验证依据 | SOURCE-SUPPORTED | 选择字段、ID和行关联真实存在；目标脚本实现尚未取得。 |
| 2. 当前玩家身份 | UNAVAILABLE | 是否能在脚本上下文获得召唤者/本地玩家，需真实脚本/API证据。 |
| 3. 指定骨灰 | SOURCE-SUPPORTED | Buddy→Think→逻辑/Goal 可作为文件入口；没有已验独立脚本隔离契约。 |
| 4. 玩家受威胁状态 | UNAVAILABLE | 未取得 owner、威胁/受击事件或相关状态函数的当前版本证据。 |
| 5. 改变追击/返回/目标 | HYPOTHESIS | 若目标 Goal 提供相关控制，可有直接行为价值；当前没有函数与语义证明。 |
| 6. 部分自动留守 | HYPOTHESIS | 需可区分成员并改变任务优先级，现有元数据不足。 |
| 7. 1～5 配置 | HYPOTHESIS | 静态关联可扩展；成员身份、不同种类和数量下的逻辑必须另验。 |
| 8. 指针/Hook依赖 | UNAVAILABLE | 不能假定需要或不需要注入；要先确认资源脚本控制能力及加载方式。 |
| 9. 安全有限实现维护 | UNAVAILABLE | 缺当前版本脚本资源、反编译可靠性、控制语义和局部重包证据。 |

事件路线也存在同样缺口：BuddyStone 的召唤 Flag 是已验召唤机制，不是持续威胁检测和按成员护卫的事件契约。没有受审脚本支持时，不编造 Flag、事件 ID 或危险判断逻辑。

结论：这是比继续静态距离调参更有信息量的候选入口类别，但还不是合格实现入口。只能推进定点证据取得；本轮不改 logicId、Goal、事件或资源包。

### 4.3 新运行时控制——能力必要性与当前缺口

| 问题 | 等级 | 审查结果 |
|---|---|---|
| 1. 实际源码/验证依据 | SOURCE-SUPPORTED | RoleController、Interpose、AutoEngage、HuntMoveTarget 等代码存在；不是当前有效控制证明。 |
| 2. 当前玩家身份 | UNAVAILABLE | Evidence-Only 明确没有批准 provider；旧方案 1/2 CLOSED。 |
| 3. 指定骨灰 | VERIFIED（限定历史记录） | 已批准目标大盾兵定位/二维参考；不是可推广的实体控制接口。 |
| 4. 玩家受威胁状态 | UNAVAILABLE | 受击、目标、敌对关系及威胁方向没有可信当前版本接口。 |
| 5. 改变追击/返回/目标 | SOURCE-SUPPORTED / UNAVAILABLE | 写路径存在，但字段语义、生命周期、导航控制和引擎一致性未验。 |
| 6. 自动部分留守 | HYPOTHESIS | 可写算法不代表存在可靠执行器；旧几何路径被阻断。 |
| 7. 1～5 配置 | HYPOTHESIS | 算法可按成员数规划；真实身份、成员替换/死亡和不同骨灰仍缺契约。 |
| 8. 未验证技术依赖 | SOURCE-SUPPORTED | 旧代码依赖缓存、扫描/偏移和写入；恢复这些路径不获本轮授权。 |
| 9. 有限维护 | UNAVAILABLE（当前实施） | 未满足状态来源和安全控制两道门槛，无法形成稳定受控实现。 |

DLL/native/Hook 不是永久禁用的技术类别。未来若取得当前 1.17.1 的可信状态来源与游戏拥有的任务/目标/导航接口，潜在收益是按成员优先级、持续威胁和玩家状态动态决策；风险是版本变化、对象寿命、游戏调用约定、并发、错误写入和性能。收益可能高于继续静态参数调节，但当前研究成本没有可靠上界，不能仅因旧代码已有函数就直接恢复。

64A 的实体工具仍为 REFERENCE_ONLY。其 WCM/ChrSet/heap 与 RTTI 类型候选没有补齐本地玩家身份，也没有提供可靠攻击者-受害者/保护控制关系；不进入本任务。

## 5. 真实状态与控制接口核对

源码路径均相对于上述仓库的 `plugin-src`，本轮没有调用这些函数。

### 玩家与威胁

- `src/main.cpp` 的 `ExistingPlayerEvidenceCandidates`：Evidence-Only 返回空；普通分支读取旧 `g_others/g_known_chars` 缓存，标签明确身份、计数器语义和坐标系未知。`id==1` 只是 hint，roster 不是身份依据。
- `src/world/player_evidence_live.cpp` 的 `RunPlayerPlanarEvidenceProbe`：Evidence-Only 直接返回 `NO_CANDIDATE_PROVIDER / NEED-L3`。
- `src/world/player_evidence.cpp/.h` 有有界 A/B 采样和保守比较，不产生 player provider。离线比较算法存在不代表获得玩家。
- `g_player_pos/g_player_valid` 是旧缓存，不升级为 VERIFIED；动画变化 proxy 也不升级为玩家受伤或被谁攻击。
- 玩家与 SoldierPlanarPosition 是否同坐标系：仍 UNAVAILABLE。

### 骨灰

- `src/world/soldier_locator.cpp` 的 `FindTargetSoldiersReadOnly/MatchesTargetSoldierReadOnly` 有目标 ID、uid/liveness 检查和已批准的大盾兵历史来源。
- 该实现仍有地址 hint 窗口及可读 MEM_PRIVATE region walk；名称“目标定位”不等于无扫描。代码中的数量终止也不是任意规模的硬读取/时间预算，本轮禁止执行，未来不能自动沿用作为广泛实体 provider。
- `src/world/soldier_planar.*` 的 +0x24/+0x28 仅为已验证 Soldier.base 的水平分量。不是玩家坐标，不是完整 XYZ，不是寻路/目标控制地址。
- 未来 1～5 可选种类不能只替换 target_id 就宣称通过身份、布局和生命周期验证。

### 控制

- `src/main.cpp`：AutoEngage 写候选目标/Threat；ApplyTargetRedirect 修改目标指向；Interpose、RoleController 等依赖旧几何/玩家假设。HuntMoveTarget 没有形成已验导航任务契约。
- `src/core/mem.cpp:51～59` 的 SafeWrite 实际使用 VirtualProtect、WriteProcessMemory；有 API 不等于允许或正确控制。
- `src/audit/journal.cpp` 的 JournaledWrite / RollbackWrites 保留 EvidenceOnly 拒绝；几何站点有 `UNVERIFIED_GEOMETRY_BLOCKED`。回滚日志只能处理已记录写入，不证明未知字段写入安全。
- `src/core/evidence_only.*` 的执行隔离和写保险必须保留。它是安全资产，不是护卫控制实现。
- `src/world/chrman.cpp` 中旧集合结构仍有候选布局和交叉验证不足。该路线 CLOSED，不重新运行。

所需控制契约至少包括：当前玩家/召唤者身份、威胁状态含义与时效、指定骨灰对象寿命、返回/接敌任务的真实语义、谁拥有目标/导航状态、引擎是否会覆盖任务、失效时只停用而不错误写入。现有资产未补齐。

## 6. 为什么提前接敌没有变成保护

现有干预是相同 Think 预设作用于五个 Buddy，改变整体接敌倾向；没有新增“留守配额、守护玩家、按威胁切换任务”的实现。

因此不能从“更早发现/接近敌人”推导“部分成员保持附近”。65 中五只集中右侧和全员接敌是用户观察；内部原因尚未识别，不能直接归因于某个参数。B 两次施法成功可能受压力分布影响，不是保护控制的证明。

“被攻击后改目标”“越界传送”“战后靠拢”“附近举盾”均有不同语义与混淆。真正保护至少要在威胁仍可达时改善玩家受压或施法体验。当前证据没有建立这个因果链。

## 7. 原型门槛与产品差距

本轮未制作原型、未构建、未运行 selftest。原因是缺少真实控制执行入口；只制作模拟状态机不能推进这个门槛。

既有 synthetic 测试可证明二维计算、输入拒绝、Evidence-Only 隔离及比较规则，不证明玩家身份、攻击威胁、引擎任务消费或护卫效果。

| 产品需求 | 当前实际状态 | 仍缺什么 |
|---|---|---|
| 1～5 数量、种类可选 | 五只大盾兵验证；配置方向存在 | 1～4和其它种类逐项验证、安全输入校验、普通玩家交互 |
| 非战斗部分近身 | 有一般跟随观察 | 留守配额和近身任务的可信入口 |
| 探索部分前出/部分留守 | 未实现 | 成员分配、位置/导航、可靠场景状态 |
| 开放世界保护优先 | 主动接敌而非稳定保护 | 威胁识别、回防/拦截任务、失败降级 |
| Boss牵制/输出空间 | 理论可能 | 不能由单个大敌测试推导跨Boss收益 |
| 自动场景适应 | 未实现 | 场景/战斗/玩家状态来源及切换规则 |
| 稳定性能与维护 | 参数加载路线验证 | 动态控制预算、版本兼容、生命周期、异常停用 |

用户不应需要手改 Think ID 或字段。未来配置层可以封装已确认的能力，但不能通过 UI 隐藏底层能力缺失。

## 8. 65 报告一致性复核

本轮没有改写 65 或 64。

65 的真实运行证据：

- A：`<USER_HOME>\AppData\Local\garyttierney\me3\data\logs\A-65-AI-BASELINE\2026-10-09_22-51-27.log`，SHA256 `715DDAE75E3E6464FC611ED0D6513040760FF105F445AD4FD86D8B20EA8D9D93`。
- B：`<USER_HOME>\AppData\Local\garyttierney\me3\data\logs\B-65-RETURN-GUARD\2026-10-09_23-16-25.log`，SHA256 `3BAB45C5607AEDC8F42D3D7E2F0CA856B589D78F5EAA8C6AC6071A5E4DA7FE5A`。
- 两日志支持 me3 0.13.0、Elden Ring 1.17.1.0、host attached、各自 package override、正常退出记录。日志不单独证明行为效果；行为来自用户原始观察。

早期 B 未放行属于 A 后条件核验前的时间状态。用户随后确认正常恢复敌人、可再次召唤五只 +10，后来 B 实际加载并观察。最终事实是 A/B 各完成一次；不能把早期未放行状态当作最终 B 未执行。

**65 第 11 节目前仍把核心指标全部写成 NOT TESTED，确实是未随结果更新的编辑性错误。** 其第 6/8/10 节和最终状态已有 A/B 观察。这些指标应分别归为已观察、未观察到改善或 INCONCLUSIVE，不应一律 NOT TESTED。

正确事实归纳：A/B 均 LAUNCHED / LOADED / OBSERVED；B 主动接敌 OBSERVED；稳定留守与提前回靠改善未观察到；施法保护因果 INCONCLUSIVE；玩家安全收益 NOT DEMONSTRATED。任何预测的“若有其它敌人将无法回防”仅保留为用户担忧，不能登记为已发生第三敌人攻击。

## 9. GO / NO-GO 与预算裁决建议

| 裁决 | 结果 | 理由 |
|---|---|---|
| 路线1：现有参数足够实现保护MVP | NO-GO | 缺可靠部分留守/威胁响应机制；65未证明保护。 |
| 路线2：立即实施新事件/运行时控制 | NO-GO（当前实施） | 必需状态和执行接口未确认；旧路线不能恢复。 |
| 路线3：保留有限实验资产、暂停护卫实施 | 推荐 | 不丢失召唤/接敌成果，不冒充保护完成，停止重复消耗。 |
| 既有非保护型召唤/接敌资产 | GO（资产保留） | 已有数据/加载/行为证据；本轮不制作发布包。 |

这不是证明“所有原生 AI 都不可能保护”。它是证据不足下的实施 NO-GO。优先级仍为玩家体验、生存保护及稳定性，不能用简单可做的追敌功能替代目标验收。

预算风险：继续距离/忘却组合可能再次只得到回靠或追敌信号；脚本可能不可取得或不暴露 owner/任务；新运行时路线可能再次陷入身份和结构搜索。必须先验证控制契约，再投入产品逻辑或游戏测试。

## 10. 下一项唯一、具体任务（需 L3 另行批准，本轮不执行）

**建议：67-TARGET-SPIRIT-AI-SCRIPT-CONTRACT-AUDIT，定点核验目标大盾兵的原生 AI 脚本控制契约。**

入口固定为既有目标 Think 的 `logicId=10000 / battleGoalID=700010`，不得切换任意其它角色或 singleton。

实施边界：只从当前本机 1.17.1 对应资源及已有可信工具取得该目标逻辑/Goal 与直接公共依赖的离线证据；先确认版本、对应关系和可可靠解析性，不运行第三方未知程序，不改原文件、不制包、不调用游戏、不恢复旧扫描。若需要新增工具/依赖，先交 L3 批准。

唯一要交付的真实契约问题：这些目标脚本是否提供召唤者/玩家上下文，是否能观测与玩家相关的持续威胁，是否存在可改变当前成员接敌/返回任务的原生接口。每项必须有实际脚本位置、调用参数和控制数据流，不能只列函数名。

止损：仅目标逻辑、Goal和直接公共依赖；资源不存在、无法可靠解释、需要广泛逆向/动态调用/多级未知来源时立即 NO-CONTRACT，不自动换路线。没有契约就不开发新的状态机或控制代码。

成功最多升级为“有 SOURCE-SUPPORTED 的原生控制候选”，再由 L3 决定是否批准真实接口的隔离原型；仍不能宣称保护完成。失败则继续路线3暂停护卫，不进行下一轮距离试验。

选择该任务的依据是本轮取得的具体行引用与本机定义，而非泛泛寻找新框架。它可能允许使用引擎已拥有的上下文，避免重开玩家地址扫描；这一点目前只是待验证可能性。

## 11. 修改与停止记录

- 本轮仅新增本报告：`<ERAI_ROOT>\_handoff-temp\66-CODEX-PROTECTION-ROUTE-IMPLEMENTATION-GATE.md`。
- 源码修改 0；Git commit 0；构建 0；新参数包 0。
- 游戏启动 0；运行时内存读取/写入 0；第三方实体工具执行 0。
- 三个已验证参数包不变；游戏、存档、DLL/native、me3/C、权限和安全设置未修改。
- 历史玩家来源1/2、6.2′、WCM、ChrSet、ChrArray、HUD、输入控制器路线继续 CLOSED / STOP。
- backhomeBattleDist 重复调参和同类压力测试停止。

**66 COMPLETE — ROUTE 3 RECOMMENDED / SMART GUARD IMPLEMENTATION NO-GO / WAITING FOR L3。**
