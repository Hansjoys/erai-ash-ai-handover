# ERAI 73 — Lone Wolf game acceptance

## 当前状态

**PASS（孤狼 1–3 数量子集）**

3 只、2 只和 1 只均已由用户实际运行并观察正常。1 只第一次尝试因检测到已有进程而停止；关闭三只和两只的命令窗口及相关进程后，重新运行 1 只入口并正常完成。

## 1. 独立验收入口

工作目录：`<ERAI_ROOT>\work\erai-lone-wolf-acceptance-73`

- `Launch-LoneWolf-3.cmd` → 72 号 Lone Wolf 3 包
- `Launch-LoneWolf-2.cmd` → 72 号 Lone Wolf 2 包
- `Launch-LoneWolf-1.cmd` → 72 号 Lone Wolf 1 包

入口调用 `Validate-LoneWolf-73.ps1`，仅在以下条件通过后才调用 me3：

- 对应 package SHA256 匹配 72 号清单；
- profile 的 `start_online=false`、`natives=[]`；
- profile 只引用一个对应 package；
- Elden Ring EXE 与原版 regulation SHA256 匹配；
- Elden Ring、me3、me3-launcher 均未运行。

三组前置检查已分别 PASS，输出均为 `game_launch=manual_user_only`。Codex 本轮没有启动任何游戏。

## 2. 包与哈希

| 数量 | package | SHA256 | 状态 |
|---:|---|---|---|
| 3 | `<ERAI_ROOT>\work\erai-spirit-type-selection-72\variants\lone-wolf-count-3\package\regulation.bin` | `D3C90B8E4BDB4699E0C8D13DC23CAB050AC4CDA6413937C450E79342EB6F658F` | OFFLINE_VALIDATED / NOT_RUN |
| 2 | `<ERAI_ROOT>\work\erai-spirit-type-selection-72\variants\lone-wolf-count-2\package\regulation.bin` | `03257C7AE537F7851C5C84D7DC8601410BD7CAA07451000F823E5C489265C943` | OFFLINE_VALIDATED / NOT_RUN |
| 1 | `<ERAI_ROOT>\work\erai-spirit-type-selection-72\variants\lone-wolf-count-1\package\regulation.bin` | `8F803714A08E0EF4149A1A4DD1D74BBBCBA42825CBA1A1F864848682F95715FF` | OFFLINE_VALIDATED / NOT_RUN |

## 3. 用户执行顺序

在游戏和 me3 完全退出后，按顺序双击：

1. `Launch-LoneWolf-3.cmd`
2. 若 3 只正常，再运行 `Launch-LoneWolf-2.cmd`
3. 若 2 只正常，再运行 `Launch-LoneWolf-1.cmd`

每次使用游戏原生“离群野狼的骨灰”，在熟悉且允许召唤的位置数清实际出现数量，记录模型/行动是否正常，并正常退出。不要修改参数或重试失败会话。每次日志保存在 `launcher-output-<N>.txt`。

## 4. 当前验收记录

| 配置 | 是否启动 | 是否加载 | 实际数量 | 结果 |
|---:|---|---|---|---|
| 3 | LAUNCHED | LOADED（用户观察） | 3（用户观察：正常） | PASS |
| 2 | LAUNCHED | LOADED（用户观察） | 2（用户观察：正常） | PASS |
| 1 | LAUNCHED | LOADED（用户观察） | 1（用户观察：正常） | PASS |

1 只配置第一次尝试的实际前置日志为：

`WOLF73 STOP: process already running: eldenring[9132], me3[9208], me3-launcher[15828]`

随后入口输出 `WOLF73 NOT LAUNCHED - preflight failed. No game was started.` 该次未消耗游戏验收会话。之后在关闭此前命令窗口和相关进程后，1 只入口重新运行并由用户观察为正常。

3 只与 2 只的用户原始观察均为“正常”；本报告不从“正常”扩展推断模型、行为、遣返或其它未报告项目。

原生道具与 23200000 系列的离线结构证据来自 72 号报告；本轮尚未取得运行时对应证据。大盾兵 1–5 的既有游戏验收未被修改，也未在本轮重复测试。

## 5. 保护范围

没有修改 72 包、50/62/68/69/70 目录、游戏 regulation.bin、游戏 EXE、存档或全局 me3 配置；没有 DLL/native、第三方工具或游戏内存写入。

## 6. 当前判断

孤狼 1、2、3 数量配置均已获得本轮用户游戏验收通过。该结论仅覆盖孤狼 1–3 数量，不扩展到其它骨灰种类、混合队伍或智能护卫功能。
