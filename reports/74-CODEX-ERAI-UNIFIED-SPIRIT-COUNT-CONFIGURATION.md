# ERAI 74 — Unified spirit count configuration

## 结论

**IMPLEMENTED_OFFLINE**

已交付真实可运行的本地配置入口、组合参数包和 me3 profile。游戏内“双种类组合包”尚未启动验收，因此不能宣布组合功能 GAME PASS。

## 1. 实际生成文件

工作目录：`<ERAI_ROOT>\work\erai-unified-spirit-count-74`

- `Configure-Unified-74.cmd`：交互式输入入口。
- `Configure-Unified-74.ps1`：按大盾兵 1–5、孤狼 1–3 生成组合。
- `Launch-Unified-74.cmd`：用户手动启动入口；本轮未调用。
- `Validate-Unified-74.ps1`：离线启动前置检查。
- `Verify-Generated-74.ps1`：逐组合离线核验。
- `README.md`：用户说明。
- `offline-verification.json`：核验结果。
- `generated\greatshield-4-lone-wolf-2\...`：完整候选组合。
- `generated\greatshield-2-lone-wolf-3\...`：独立变化组合核验样本。

## 2. 两种骨灰的独立机制

唯一生成输入是已验收的 `AI_SUMMON_BASELINE`。每次生成都从原始输入重新读取，不从此前生成的变体继续加工。

- 大盾兵成员组：`24800000..24800004`，按选择删除尾部多余行。
- 孤狼成员组：`23200000..23200002`，按选择删除尾部多余行。
- `NpcThinkParam` 不修改。
- `BuddyStoneParam` 不修改。
- 其它 `BuddyParam` 行不删除、不改值。
- 不制作混合队伍；用户在游戏内继续用原生骨灰道具选择种类。

## 3. 已生成组合

### Greatshield=4，Lone Wolf=2

`<ERAI_ROOT>\work\erai-unified-spirit-count-74\generated\greatshield-4-lone-wolf-2\package\regulation.bin`

SHA256：`45BE1C51B7018860E83F20B846FF647C32A88539D46791D61AF95A0E89B212B6`

保留行：大盾兵 `24800000..24800003`；孤狼 `23200000..23200001`。

### Greatshield=2，Lone Wolf=3

`<ERAI_ROOT>\work\erai-unified-spirit-count-74\generated\greatshield-2-lone-wolf-3\package\regulation.bin`

SHA256：`08E0124DEDA66D4A626BE3ABA435EB2E0BF4A60E533C657DE71B7723FEF5F9D2`

保留行：大盾兵 `24800000..24800001`；孤狼 `23200000..23200002`。

每个组合 profile 只引用对应的一个 package，并设置 `start_online=false`、`natives=[]`。

## 4. 离线验证

两个组合均已验证：

- BND 版本 `11711000`，文件数 `194`。
- Buddy 行数分别为 168（4+2）和 167（2+3）。
- 两组目标 Buddy 行数与选择一致。
- 保留的大盾兵和孤狼行均为原始基线行；只删除批准的尾部行。
- 非目标 Buddy 行逐字段与原始基线一致。
- 其它 BND 条目内容不变。
- `NpcThinkParam` 字节内容不变。
- `BuddyStoneParam` 字节内容不变。
- profile 只有一个 package，`start_online=false`，`natives=[]`。
- 生成失败使用 `CreateNew`，不会覆盖上一次已有有效组合。
- 两个组合的 `Validate-Unified-74.ps1` 离线前置检查均 PASS。

源包 `AI_SUMMON_BASELINE\package\regulation.bin` SHA256：

`D3C90B8E4BDB4699E0C8D13DC23CAB050AC4CDA6413937C450E79342EB6F658F`

原始游戏 regulation 未修改，仍为既有核验值：

`766521F9508DE3A3532DF61C45A1C2D93340F1FF7ED8306AB20DF761712CA2AB`

## 5. 用户配置步骤

1. 双击 `Configure-Unified-74.cmd`。
2. 输入大盾兵数量 `1–5`。
3. 输入孤狼数量 `1–3`。
4. 生成的组合位于 `generated\greatshield-N-lone-wolf-M`。
5. 如获准进行游戏验收，再运行 `Launch-Unified-74.cmd`，它会重新检查组合、哈希、profile、游戏文件和进程状态。

游戏内仍使用原生骨灰道具选择种类；本工具不改变同时召唤两种骨灰的规则。

## 6. 待执行的最小游戏验收

只需选一个组合（建议 `Greatshield=4, Lone Wolf=2`），在同一存档中分别使用两种原生骨灰道具，确认实际数量为 4 和 2，正常退出。之后再按 L3 批准决定是否扩大组合验收。

本轮没有启动 me3 或游戏，所有组合的 `gameTested=false`。

## 7. 保护成果与回滚

没有修改 50、62、68、69、70、72、73 目录、原版 regulation、游戏 EXE、存档或全局 me3 配置。删除或不使用 74 的 `generated` 目录即可回滚；既有单种类包保持可用。

## 8. 与智能护卫的差距

74 只统一了两种已验收骨灰的数量配置。它没有实现玩家状态识别、威胁判断、成员分工、近身留守、动态回防或保护优先 AI；这些仍是独立的技术缺口。

## 9. 73 报告一致性说明

73 报告第 2 节仍保留早期 `NOT_RUN` 表格文字，而第 4 节及最终状态记录了 1 只重试后的实际 `PASS`。本报告按 73 的最终验收事实处理：孤狼 1–3 已通过；没有为修正文档重新启动游戏。

