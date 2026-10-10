# 70-CODEX-ERAI-CONFIGURABLE-SUMMON-COUNT-GAME-ACCEPTANCE

日期：2026-10-10

## 1. 启动入口与一致性检查

独立目录：`<ERAI_ROOT>\work\erai-count-acceptance-70`

- 选择入口：`Choose-Count-70.cmd`
- 启动入口：`Launch-Selected-Count-70.cmd`
- 选择来源：`<ERAI_ROOT>\work\erai-configurable-summon-69\selected\selection.json`
- 使用 me3：`<USER_HOME>\AppData\Local\ERAI-UserTests\me3-0.13.0\bin\me3.exe`
- 游戏：`<GAME_ROOT>\RING\Game\eldenring.exe`
- 每次启动前核验：选择数量 1～5、selection/profile/package 一致、包 SHA256、`natives=[]`、`start_online=false`、仅一个 `regulation.bin`、游戏与 me3 进程不存在。
- 启动入口不修改 69 号目录中的参数包，不修改原版游戏文件、存档或全局配置。
- 首次入口的 Windows PowerShell 5.1 执行策略拦截已在独立 70 号入口中改用既有 PowerShell 7 路径解决；没有修改系统执行策略。

## 2. 每个数量的加载与游戏结果

| 数量 | 状态 | 实际包 SHA256 | me3 加载日志 | 用户观察 | 游戏退出 |
|---:|---|---|---|---|---|
| 3 | `OFFLINE_VALIDATED / LAUNCHED / LOADED / COUNT_OBSERVED / PASS` | `08EEE87761CC7DBD59A0925C94F6DA28FEE3848534FF3A374D1961F4A00D6571` | `<USER_HOME>\AppData\Local\garyttierney\me3\data\logs\ERAI-Selected\2026-10-10_00-43-46.log`，记录 override 到 `variants\count-3\package\regulation.bin` | 实际出现 3 只大盾兵 | 正常 |
| 1 | `OFFLINE_VALIDATED / LAUNCHED / LOADED / COUNT_OBSERVED / PASS` | `12B4006FDF093DC92C2F8D2B7678218362BB8F96BC1FE317F556BAB6144B0DFA` | `<USER_HOME>\AppData\Local\garyttierney\me3\data\logs\ERAI-Selected\2026-10-10_00-46-47.log`，记录 override 到 `variants\count-1\package\regulation.bin` | 实际出现 1 只大盾兵 | 正常 |
| 2 | `OFFLINE_VALIDATED / LAUNCHED / LOADED / COUNT_OBSERVED / PASS` | `08E0124DEDA66D4A626BE3ABA435EB2E0BF4A60E533C657DE71B7723FEF5F9D2` | `<USER_HOME>\AppData\Local\garyttierney\me3\data\logs\ERAI-Selected\2026-10-10_00-48-48.log`，记录 override 到 `variants\count-2\package\regulation.bin` | 实际出现 2 只大盾兵 | 正常 |
| 4 | `OFFLINE_VALIDATED / LAUNCHED / LOADED / COUNT_OBSERVED / PASS` | `E2E070B4B738D816FEA874AA32C0BA3F2B7FE13E646CCCF38915357C577A0642` | `<USER_HOME>\AppData\Local\garyttierney\me3\data\logs\ERAI-Selected\2026-10-10_00-50-50.log`，记录 override 到 `variants\count-4\package\regulation.bin` | 实际出现 4 只大盾兵 | 正常 |
| 5 | `HISTORICALLY_VERIFIED / NOT_RUN` | `D3C90B8E4BDB4699E0C8D13DC23CAB050AC4CDA6413937C450E79342EB6F658F` | 本任务未启动 | 由此前 51/52 等验收记录支持 | 本任务未运行 |

每次实际启动均只加载一个对应 package，日志同时确认 Elden Ring 1.17.1.0、me3 0.13.0、`natives=[]` 和 `start_online=false`。

## 3. Buddy 行副作用检查

本任务没有改写任何参数包。69 号离线差异清单显示 1～4 号变体只移除目标大盾兵 Buddy 行的尾部成员行，保留剩余行字节，Think 表不变；5 号与 AI_SUMMON_BASELINE 相同。四次游戏中均出现与选择一致的数量，没有报告异常模型、召唤崩溃或游戏异常退出。没有发现由删除尾部 Buddy 行引起的额外副作用。

## 4. 最终用户选择流程

1. 双击 `<ERAI_ROOT>\work\erai-count-acceptance-70\Choose-Count-70.cmd`。
2. 输入 1～5；脚本写入 69 号 `selected\selection.json` 和 `selected\ERAI-Selected.me3`。
3. 双击 `<ERAI_ROOT>\work\erai-count-acceptance-70\Launch-Selected-Count-70.cmd`。
4. 入口核验选定包哈希和 profile 后才允许 me3 启动；出现任何门禁错误都不会启动游戏。
5. 停用时退出游戏并停止使用该入口即可；原版文件和旧实验包未被覆盖。

## 5. 结论

1～4 号均完成一次有效游戏验收并通过；5 号此前已有历史游戏验收，本任务未重复运行。因而“选择数量并生成真实有效参数包”的数量 MVP 已获得 1～5 的实际支持，其中 5 的证据来自既有验收，1～4 的证据来自本任务。

这只验证召唤数量，不验证 AI 保护、行为改善、其它骨灰类型或正式发布稳定性。

最终状态：`IMPLEMENTED_OFFLINE + GAME_ACCEPTANCE_PASS (1-5)`
