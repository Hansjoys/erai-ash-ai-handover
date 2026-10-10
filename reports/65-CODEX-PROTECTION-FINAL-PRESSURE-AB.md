# 65 — CODEX-PROTECTION-FINAL-PRESSURE-AB

状态：**A LAUNCHED / LOADED / OBSERVED；B LAUNCHED / LOADED / OBSERVED**。两组各完成一次会话；未修改参数包、游戏文件、存档、DLL/native 或安全设置。

## 1. 测试目标与场地

目标：在同一真实威胁场景下比较 `backhomeBattleDist=999` 与 `10`，观察主动接敌、压力期间回靠、队伍分散和实际施法机会。单次结果最多支持该场景的有限保护倾向，不能升级为完整保镖系统。

场地采用 L3 指定的用户候选区域：旧火山官邸附近开阔区域。当前只有用户描述，未由 Codex 静态确认地形或敌人身份：

- 一名背对玩家的大型敌人；
- 左侧两名人形敌人（一近战、一远程）；
- 右侧两名人形敌人（一近战、一远程）。

用户启动后必须自行确认：固定位置可召唤、左右敌人可实际接近、至少存在远程压力、撤退路线安全、没有门/窄口/墙体卡位；大型敌人若介入造成碰撞或卡位，本次场景不合格。

## 2. 参数包与 me3

| 组 | 包 | SHA256 | backhomeBattleDist |
|---|---|---|---:|
| A | `<ERAI_ROOT>\work\summon-baseline-50\AI_SUMMON_BASELINE\package\regulation.bin` | `D3C90B8E4BDB4699E0C8D13DC23CAB050AC4CDA6413937C450E79342EB6F658F` | 999 |
| B | `<ERAI_ROOT>\work\summon-baseline-62\AI_RETURN_GUARD_VARIANT\package\regulation.bin` | `8ECB4C382FCF988E2644F823C123EA844D890F665769F406F7F3BA21E02F9125` | 10 |

两包仅使用已有成品，未重新制作或修改。固定 me3 C 环境：

`<USER_HOME>\AppData\Local\ERAI-UserTests\me3-0.13.0\bin\me3.exe`  
SHA256：`203A726AB40ECAC6EE9DEABA1AA96F741D87E12DEF549CDEB48F99E5FE16D52D`

两个 Profile 均为 `start_online=false`、`natives=[]`，且各自只有一个目标 package。

## 3. 独立入口与历史门禁

- A：`<ERAI_ROOT>\work\summon-baseline-62\launch-65\A-65-START.cmd`
- B：`<ERAI_ROOT>\work\summon-baseline-62\launch-65\B-65-START.cmd`
- A Profile：`<ERAI_ROOT>\work\summon-baseline-62\launch-65\A-65-AI-BASELINE.me3`
- B Profile：`<ERAI_ROOT>\work\summon-baseline-62\launch-65\B-65-RETURN-GUARD.me3`

64 号历史状态已只读核对：`launch-64\A-session-reserved.txt` 存在，`B-session-reserved.txt` 不存在，`A-CONDITIONS-REVIEWED.txt` 不存在。65 使用自己的 A/B 预留记录，不删除、不覆盖、不清除 64 标记；B 只有在 A 条件经过复核后才可由 L3/本任务后续明确放行，当前入口会因缺少 `A-CONDITIONS-REVIEWED.txt` 停止。

没有自动启动游戏。没有运行第三方实体工具。没有重启 WCM/ChrSet/heap 路线。

65 A 实际日志：`<USER_HOME>\AppData\Local\garyttierney\me3\data\logs\A-65-AI-BASELINE\2026-10-09_22-51-27.log`，SHA256=`715DDAE75E3E6464FC611ED0D6513040760FF105F445AD4FD86D8B20EA8D9D93`。日志记录 me3 0.13.0、Elden Ring 1.17.1.0 Worldwide、Host successfully attached、A regulation override；A launcher 输出包含 `LAUNCHER_EXIT_CODE=0`。B 没有日志、没有启动记录。

65 B 实际日志：`<USER_HOME>\AppData\Local\garyttierney\me3\data\logs\B-65-RETURN-GUARD\2026-10-09_23-16-25.log`，SHA256=`3BAB45C5607AEDC8F42D3D7E2F0CA856B589D78F5EAA8C6AC6071A5E4DA7FE5A`。日志记录 me3 0.13.0、Elden Ring 1.17.1.0 Worldwide、Host successfully attached、B regulation override；B launcher 输出包含 `LAUNCHER_EXIT_CODE=0`。两组均为 `natives=[]`、offline。

## 4. 64 号历史报告矛盾记录

64 报告存在必须保留的内部矛盾：前文记录了 A 的 launcher exit code、me3 attach、Elden Ring 1.17.1.0 host attach 和 AI package override，并写明 A 会话完成；但报告末尾旧版段落仍写着“没有启动游戏/本轮 NOT RUN”。本报告不默默选择其中一条，也不覆盖历史报告。

本次按可核验日志处理：64 A 曾实际启动并加载 A 包，但其压力场景证据被用户判定不足；64 B 未启动。64 的 A 观察不作为 65 的对照数据。

## 5. 本轮执行状态

| 阶段 | 状态 |
|---|---|
| 包哈希与 Profile 静态核对 | PASS |
| launch-65 入口准备 | PASS |
| A 启动 | LAUNCHED |
| A me3 加载 | LOADED |
| A 场地有效性 | 有远程压力和双侧受威胁迹象；大型敌人未造成卡位 |
| B 启动 | LAUNCHED |
| B me3 加载 | LOADED |
| 行为观察 | OBSERVED，但保护对照未显示明确改善 |

## 6. A 组实际观察

用户记录：

- 左右两组敌人理论上可接近；实际存在远程攻击压力。
- 大型敌人没有造成卡位。
- 正常施法有概率被远程攻击打断。
- 未观察到盾兵主动阻断远程敌人、挡住箭矢或法术；没有提前预防式护卫证据。
- 玩家按原路线后撤至大门口时，骨灰没有明显主动回靠意图；主要表现为超出某个范围后的回退/传送，或玩家受到攻击后的回靠。
- 玩家被左右两侧围击时，骨灰大部分在右侧、少部分在左侧。左侧远程命中玩家后，右侧骨灰把目标转向攻击玩家的敌人，但未能及时阻断攻击。
- A 会话中一只骨灰阵亡。

### A 指标分类

| 指标 | A 状态 |
|---|---|
| 远程威胁 | OBSERVED |
| 施法可能被打断 | OBSERVED |
| 提前回靠/预防性拦截 | 未观察到 |
| 受击后目标转向 | OBSERVED，但未阻断伤害 |
| 玩家附近稳定保护 | INCONCLUSIVE |
| 队伍是否全员追敌/部分回靠 | INCONCLUSIVE，现场未能稳定观察 |
| 骨灰存活 | 一只阵亡，具体原因未归因 |

A 的场景相较 64 更有压力区分力，但“左右敌人理论上可接近”仍需在 B 前确认实际路线和数量可复现。A 不能单独证明保护成功，也不能作为 B 的结果。

## 7. 用户执行 A 时的固定流程

1. 确保 Elden Ring 已退出，普通双击 `A-65-START.cmd`，只执行一次。
2. 在候选开阔区域确认召唤成功，召唤五只 +10 大盾兵。
3. 确认左右两组人形敌人确实可接近，并且至少一名远程敌人形成可观察压力；大型敌人不得造成卡位。
4. 不主动攻击、不锁定、不故意承伤。按相同接近路线让敌人进入威胁范围。
5. 在敌人尚未被消灭且仍可达时，尝试一次与 B 相同的正常施法；记录完成、被迫中断或无法判断。
6. 按相同开放路线撤退，观察部分骨灰回靠、部分牵制、全员追敌、玩家被接近等现象。
7. 若场景条件不成立、群战失控、危险地形或游戏异常，立即结束，不重试。

用户返回时只需记录：召唤结果、左右敌人数量/方向、远程是否实际攻击、是否有大敌介入、是否完成施法、骨灰是否全追/部分回靠、退出是否正常。

## 8. B 实际观察

用户记录：

- 五只骨灰全部主动跑到右侧并进入战斗，保留主动接敌。
- 先完成一次施法，再向后撤后完成第二次施法；本次两次施法均未被打断。
- 施法未中断不能单独归因于 `backhomeBattleDist=10`：五只骨灰集中在右侧，整体威胁压力减少。
- 玩家回到大门处，骨灰没有明显回靠，仍继续全员接敌。
- 骨灰再次减员一名。
- 玩家仍暴露在空地；若此时出现其它敌人，骨灰无法及时回防。

### B 指标分类

| 指标 | B 状态 |
|---|---|
| 主动接敌 | OBSERVED |
| 压力持续时提前回靠 | 未观察到 |
| 部分牵制、部分靠近玩家 | 未观察到；五只集中右侧 |
| 减少全员远距离追敌 | 未观察到；回到大门后仍全员接敌 |
| 实际施法 | OBSERVED，两次完成 |
| 施法中断减少 | INCONCLUSIVE；压力集中导致混淆 |
| 预防性阻断远程攻击 | 未观察到 |
| 玩家安全/回防 | 未观察到；玩家仍暴露 |
| 骨灰存活 | 一只阵亡，具体原因未归因 |

## 9. B 放行条件

只有 A 同时满足以下条件，才由后续裁决放行 B：

- A 场地确实开放，无门/墙/窄口或大型敌人卡位；
- 左右敌人和远程压力实际存在且可达；
- A 未因无法召唤、敌人状态不一致或异常而失效；
- 两次会话之间敌人已通过正常游戏机制恢复到可比较状态；
- A 的固定路线、施法动作和观察方法已记录。

本次 A 条件已满足到可以进行一次 B：远程压力实际存在，大型敌人未卡位，敌人和五只骨灰在 B 前通过正常机制恢复。B 已完成，后续不再启动第三次或更换场地。

## 10. A/B 逐项比较与最终判定

| 指标 | A（999） | B（10） | 判定 |
|---|---|---|---|
| 主动接敌 | 有压力下的战斗记录 | 五只主动跑向右侧并接敌 | B 保留主动接敌，OBSERVED |
| 压力期间回靠 | 后撤时未形成可稳定观察 | 回到大门仍未明显回靠 | 未显示 B 改善 |
| 队伍分散 | 左右受压，骨灰分布不均 | 五只集中右侧 | 场面分布不同，不能据此推导固定分工 |
| 全员追敌 | A 记录不足以稳定判断 | 明确仍全员接敌 | B 未减少全员追敌 |
| 法术窗口 | 有概率被打断 | 两次完成 | B 有表面改善，但被压力集中混淆，保护因果 INCONCLUSIVE |
| 预防性拦截/回防 | 未观察到 | 未观察到；玩家仍暴露 | 保护改善未证明 |
| 骨灰减员 | 一只阵亡 | 一只阵亡 | 无可见存活改善 |

最终有限结论：`backhomeBattleDist=10` 在本次场景中保留主动接敌，但没有显示出敌人仍可达时的提前回靠、部分护卫或减少全员追敌；两次施法完成不能单独作为保护成功。**PROTECTION IMPROVEMENT = NOT DEMONSTRATED；本候选在本场景的保护目标 FAIL/INCONCLUSIVE。**

这不证明原生 AI 在所有地图完全没有保护能力，只说明该单变量在这次有限 A/B 中没有形成可验证的玩家保护收益。

## 11. 尚无结果的核心指标

主动接敌、压力期间回靠、部分牵制/部分回靠、减少全员追敌、实际施法完成率、施法中断、玩家安全、回靠过度或消极化：均为 `NOT TESTED`。

## 12. 保护边界

即使 B 相对 A 观察到回靠和施法改善，最多记录“该场景下出现有限正向证据”。不能宣布完整保镖 MVP、普遍玩家保护、动态职业分工或跨地图可靠性。敌人未命中、战后传送、附近举盾或单次定性动作不能单独判为保护成功。

## 13. 当前修改与停止

仅新增独立 `launch-65` Profile、CMD、准备清单和本报告；两个 regulation.bin、游戏、存档、旧 DLL/native、C 环境和安全设置保持原样。A/B 各只运行一次；不自动重试、不调参、不切换场地。

**65 STATUS = A LAUNCHED / LOADED / OBSERVED / B LAUNCHED / LOADED / OBSERVED / FINAL = PROTECTION IMPROVEMENT NOT DEMONSTRATED**
