# 67-CODEX-TARGET-SPIRIT-AI-SCRIPT-CONTRACT-AUDIT

## 1. 最终裁决

**最终分类：`NO_CONTRACT`**

本轮完成了限定范围内的离线核验，但没有取得从目标 Think 行到可解析的原生 AI 逻辑/Goal 资源，再到召唤者上下文、玩家威胁状态和成员级行为控制的证据闭环。

因此：

- 不制作参数包；
- 不修改 `logicId` 或 `battleGoalID`；
- 不启动游戏或读取游戏进程；
- 不构建控制 DLL；
- 不恢复 WCM、ChrSet、ChrArray、heap、HUD 或输入控制器路线；
- 不建议立即制作真实保护原型。

**后续是否继续原生脚本路线，需由 L3 重新裁决。** 本报告不自动开启另一轮逆向。

## 2. 审计对象、版本与安全边界

### 2.1 游戏版本依据

本机目标 EXE：

`<GAME_ROOT>\RING\Game\eldenring.exe`

既有核验 SHA256：

`1A3547101327F65D0C76DA2F9190AC0AA66871EA42BAE2AECC61E11A8B597891`

既有运行日志标记：`Elden Ring 1.17.1.0 Worldwide`。

参数包与本机 1.17.1 定义均标记 BND 版本 `11711000`。本轮没有修改或重包游戏文件。

### 2.2 研究范围

只核对：

- `NpcThinkParam` 目标行 `270001001`；
- 原目标行 `170001000` 的继承关系；
- `BuddyParam` 行 `24800000`～`24800004`；
- `logicId=10000`；
- `battleGoalID=700010`；
- 取得上述字段映射所必需的直接资源证据。

没有遍历无关 NPC、地图、全游戏 AI、全堆内存或运行时对象。

### 2.3 可信工具与资源边界

已有可信参数处理依据为本机 `Andre.SoulsFormats.dll` 与已完成的 50/62 验证脚本；它们能够解析参数/BND/DCX，并核验逐表、逐行差异，但没有提供本机当前版本 AI 逻辑脚本或 battle Goal 的语义解析器。

游戏目录主要资源仍封装在 `Data*.bdt/.bhd`、`sd*.bdt/.bhd` 等归档中；本轮没有为了追踪脚本安装新工具、下载依赖、运行未知 EXE 或执行资源解包脚本。现有项目资料中没有可证明 `10000`、`700010` 的当前 1.17.1 脚本正文、函数参数、调用图或资源索引。

因此，以下“缺少映射”是证据边界，不是断言游戏没有该资源。

## 3. 当前成品包的 Think/Buddy 字段核验

### 3.1 AI_SUMMON_BASELINE

文件：

`<ERAI_ROOT>\work\summon-baseline-50\AI_SUMMON_BASELINE\package\regulation.bin`

SHA256：

`D3C90B8E4BDB4699E0C8D13DC23CAB050AC4CDA6413937C450E79342EB6F658F`

验证清单：`<ERAI_ROOT>\work\summon-baseline-50\verification-manifest.json`。

- BND 版本：`11711000`；194 个条目；`NpcThinkParam` 2216 行；`BuddyParam` 170 行。
- 原始 Think 行 2215 行保留。
- 新行恰好 1 条，ID `270001001`。
- 新行与已验收 22 号 Think 行逐字节一致：`new_think_row_matches_ai22=true`。
- 目标 Buddy 引用变化数：5；五条 `24800000`～`24800004` 均从 `npcThinkParamId=170001000` 指向 `270001001`。
- BuddyStone 与 CONTROL 相同；303 个非零 BuddyStone 行属于召唤公共基线，不能充当 AI 脚本映射证据。

### 3.2 AI_RETURN_GUARD_VARIANT

文件：

`<ERAI_ROOT>\work\summon-baseline-62\AI_RETURN_GUARD_VARIANT\package\regulation.bin`

SHA256：

`8ECB4C382FCF988E2644F823C123EA844D890F665769F406F7F3BA21E02F9125`

验证清单：`<ERAI_ROOT>\work\summon-baseline-62\AI_RETURN_GUARD_VARIANT\verification-manifest.json`。

- BND 版本：`11711000`；194 个条目。
- 仅改变 `NpcThinkParam[270001001].backhomeBattleDist`。
- 偏移 `+0x40`，类型 `u16`；AI 基线值 `999`，变体值 `10`，变化 2 字节。
- `buddy_stone_identical_to_ai=true`。
- `buddy_references_unchanged=true`。
- `other_think_fields_unchanged=true`。

所以，62 变体没有改变 `logicId`、`battleGoalID` 或五条 Buddy 关联；它仍使用同一目标 AI 逻辑元数据。

### 3.3 字段实际值

本机 `NpcThinkParam.xml` 定义为 228 B/行、DV2：

`<GAME_ROOT>\Smithbox_2_2_6_2026_09_20_b\Assets\PARAM\ER\Defs\NpcThinkParam.xml`

既有 `expected-new-think-row.bin` 为 228 B，实际小端读取：

| 字段 | 行内偏移 | 类型 | `270001001` 实际值 | 证据状态 |
|---|---:|---|---:|---|
| `logicId` | `+0x04` | `s32` | `10000` | VERIFIED（文件字节） |
| `battleGoalID` | `+0x08` | `s32` | `700010` | VERIFIED（文件字节） |
| `backhomeBattleDist` | `+0x40` | `u16` | 999 / 10（两包分别） | VERIFIED（包差异） |

`logicId` 定义说明“脚本逻辑 ID”，`battleGoalID` 定义说明“战斗 Goal ID”。这确认字段的文件含义，不确认 ID 指向哪段当前运行脚本，更不确认它们包含玩家保护控制。

## 4. Think → AI 逻辑/Goal 映射证据

### 已获得

1. `BuddyParam.npcThinkParamId` 的文件关联已核验：五条目标 Buddy → `270001001`。
2. `270001001` 是从 `170001000` 复制的独立 Think 行；22/50 清单确认原行不变。
3. 行内 `logicId=10000`、`battleGoalID=700010` 的字节值已核验。
4. 两个游戏会话日志证明各自 `regulation.bin` 被 me3 override 并加载；这证明包加载，不证明脚本 Goal 的内部语义。

### 没有获得

- `logicId 10000` 对应脚本文件的当前 1.17.1 路径；
- `battleGoalID 700010` 对应 Goal 定义、函数或状态机正文；
- 目标逻辑的入口参数、返回值和调用者；
- 目标逻辑如何取得召唤者、本地玩家或跟随目标；
- 目标逻辑如何读取玩家受袭、敌人仇恨、攻击目标或威胁接近；
- 目标逻辑如何终止追敌、改变任务优先级或只影响部分成员；
- 目标逻辑是否被所有使用该 ID 的 NPC 共用，以及是否存在 Buddy 专用分支。

文件名、数字相等、参数定义注释和运行中“更早接敌”的观察，都不能代替上述映射。当前映射只能标为：

`Think row → logic/Goal numeric selector = VERIFIED`

`numeric selector → actual current script/Goal semantics = UNAVAILABLE`

## 5. A：召唤者上下文

**结论：`UNAVAILABLE`。**

没有取得目标脚本正文或调用链，因此无法列出一个有证据的：

`AI logic/Goal → summon owner/player context`

数据来源。

需要特别区分：

- BuddyParam 里存在 `pcFollowType` 和 `disablePCTargetShare` 等跟随/目标共享字段，属于原生参数选择，**SOURCE-SUPPORTED**；
- 这不等于脚本向 ERAI 暴露一个可读取的玩家指针、owner 对象或可控跟随任务；
- 项目现有 `g_player_pos`、`g_player_valid`、`g_others`、roster 和旧 WCM/ChrSet 不能作为本轮上下文来源。玩家来源方案 1、2 已 CLOSED，Evidence-Only 也明确无批准 player provider。

不能提交召唤者 root、owner 地址或可供运行时读取的低深度链。

## 6. B：玩家威胁接口

**结论：`UNAVAILABLE`。**

未取得以下任一可解释接口：

- 玩家正在受击/被锁定的事件；
- 敌人对玩家的目标或仇恨状态；
- 远程攻击/弹体向玩家接近的事件；
- 触发回防或优先护卫的 Goal 状态；
- 伤害、攻击者和受害者之间的关系数据流。

`battleGoalID` 只是数字选择器；`backhomeBattleDist` 只是参数字段；这些都不能单独证明威胁检测。

当前源码的 `g_player_hit` 也只是历史动画变化代理，项目文件已标注不等于可靠玩家受伤状态。64A 第三方实体工具的 SpEffect/动画/HP 观察只能作未来参考，且没有 1.17.1 玩家身份和攻击者关系闭环，不得在本轮升级。

## 7. C：骨灰行为控制接口

### 原生资源侧

**等级：`SOURCE-SUPPORTED`，但控制语义不完整。**

文件证据支持：

- 通过 Buddy → Think 行选择一组原生 AI 参数；
- 可独立复制 Think 行并只重关联目标 Buddy；
- `backhomeBattleDist`、`backhomeDist`、`pcFollowType`、忘却字段、`logicId`、`battleGoalID` 等字段可被文件系统编码。

但没有证据支持这些字段能够：

- 在持续威胁中指定一部分成员回到玩家；
- 让一个成员终止追击而另一个成员继续牵制；
- 根据玩家危险状态动态切换；
- 仅对指定一个实时实体执行，而不是对共享 Think 的全部成员生效。

### ERAI 运行时代码侧

项目源码确实存在 `AutoEngage`、`ApplyTargetRedirect`、`Interpose`、`RoleController`、`HuntMoveTarget` 等函数，但这只是**SOURCE-SUPPORTED 的代码存在**：

- 它们依赖旧 `g_others`/玩家候选/威胁偏移或历史几何假设；
- `RoleController` 和 `Interpose` 需要写位置，`AutoEngage`/`ApplyTargetRedirect` 需要写目标指针；
- `src/core/mem.cpp` 的 `SafeWrite` 实际使用 `VirtualProtect` 和 `WriteProcessMemory`；
- `src/audit/journal.cpp` 仅提供日志、Evidence-Only 拒绝和已知几何站点阻断，不证明未知目标/导航写入安全；
- 玩家身份、威胁状态、对象生命周期和控制字段均未在当前 1.17.1 形成验证闭环。

所以这些函数不能作为本轮可实施控制入口，不能恢复、运行或重构。

## 8. D：成员级隔离能力

**结论：`UNAVAILABLE`。**

文件层面可以给五条 Buddy 重新关联不同 Think 行，这说明静态配置上存在“按 Buddy 行隔离”的可能；但是：

- 当前五条目标 Buddy 使用同一 `270001001`；
- 没有证据证明拆分 Think 后会得到留守/牵制两个已知行为；
- 没有实时成员 owner、任务句柄或导航控制接口；
- 没有证据证明引擎不会在战斗状态、目标共享或召唤生命周期中覆盖该分工。

因此不能把“每条 Buddy 可改引用”写成“可实现部分成员留守”。

## 9. 证据矩阵

| 能力问题 | 结论 |
|---|---|
| Think 行与五条 Buddy 关联 | `VERIFIED` |
| `logicId=10000`、`battleGoalID=700010` 文件值 | `VERIFIED` |
| 数字 ID 映射到当前 1.17.1 脚本正文 | `UNAVAILABLE` |
| 脚本取得召唤者/本地玩家 | `UNAVAILABLE` |
| 玩家受袭/敌人仇恨/威胁事件 | `UNAVAILABLE` |
| 脚本改变接敌、回靠或任务优先级 | `HYPOTHESIS` |
| 按实时成员隔离行为 | `UNAVAILABLE` |
| Buddy 静态行级隔离可能性 | `SOURCE-SUPPORTED` |
| 当前 ERAI 旧运行时代码能安全执行护卫控制 | `UNAVAILABLE` |

## 10. 与已观察行为的关系

52/59/62/65 的观察只能支持：

- AI 包加载成功；
- 五只骨灰可以主动接敌；
- `backhomeBattleDist=10` 的变体仍能主动接敌，并出现过部分回靠倾向；
- 65 没有证明持续威胁中的提前回靠、稳定留守、减少全员追敌或玩家安全收益。

这些行为不能反向证明 `logicId=10000` 或 `battleGoalID=700010` 内部拥有召唤者/保护接口。没有目标脚本正文时，也不能说行为是由某个 Goal 而非其它共用 AI 状态或环境因素造成。

## 11. 是否值得真实原型

**当前不值得直接投入真实原型，结论：NO-GO。**

理由：缺口同时出现在三层：

1. **资源层**：没有可靠的当前版本脚本/Goal 映射；
2. **状态层**：没有召唤者身份、玩家威胁或攻击者-受害者状态；
3. **控制层**：没有已验证的成员级任务/目标/返回接口。

制作一个模拟状态机、把 `logicId` 换成另一个数字、或恢复旧 DLL 写路径，都无法补齐这三层，并会制造“已实现保护”的假证据。

## 12. 唯一后续动作（需 L3 另行批准）

本报告建议的唯一后续动作：

**由 L3 单独批准一次 `NO_CONTRACT` 后的产品/技术路线裁决，不自动进行下一轮原生 AI 逆向。**

如果 L3 仍坚持验证脚本路线，必须先批准一个新的、独立的资源获取与解析任务，明确提供可信的当前 1.17.1 AI/Goal 资源和解析工具来源；该任务应重新定义止损，不得直接运行游戏或恢复运行时写入。当前证据不足以列出可实施的真实原型任务。

## 13. 修改与安全记录

- 源码修改：0。
- 参数包修改：0；原版 `regulation.bin` 未修改。
- Git commit：0；当前仓库工作树未因本轮改变。
- 游戏启动：0；游戏进程内存读取/写入：0。
- DLL、native、Hook、游戏函数调用：0。
- 旧 WCM/ChrSet/ChrArray/heap/HUD/输入控制路线：未恢复。
- 目标 Think、Buddy、`logicId`、`battleGoalID`：未改动。
- 既有 50/62 成品包：未改动。

**67 COMPLETE — NO_CONTRACT / STOP / NEED-L3。**
