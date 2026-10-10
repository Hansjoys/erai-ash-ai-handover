# ERAI 75 — Unified 4+2 minimal game acceptance

## 当前状态

**GAME PASS**

用户手动完成了一次 4+2 组合游戏会话，实际数量和正常退出均已确认。

## 1. 启动入口真实机制

入口：

`<ERAI_ROOT>\work\erai-unified-acceptance-75\Launch-4plus2-75.cmd`

它不询问数量，也不调用 74 生成器；固定引用：

- Profile：`<ERAI_ROOT>\work\erai-unified-spirit-count-74\generated\greatshield-4-lone-wolf-2\profile\erai-unified-4-2.me3`
- Package：`<ERAI_ROOT>\work\erai-unified-spirit-count-74\generated\greatshield-4-lone-wolf-2\package\regulation.bin`

启动前由 `Validate-4plus2-75.ps1` 实时检查 package SHA256、Profile、单 package、`start_online=false`、`natives=[]`、游戏与 me3 文件、原版 regulation SHA256，以及 Elden Ring/me3 进程状态。

离线检查输出：`UNIFIED75 PREFLIGHT PASS`，`game_launch=manual_user_only`。

## 2. 固定 4+2 包

实际 package：

`<ERAI_ROOT>\work\erai-unified-spirit-count-74\generated\greatshield-4-lone-wolf-2\package\regulation.bin`

SHA256：

`45BE1C51B7018860E83F20B846FF647C32A88539D46791D61AF95A0E89B212B6`

Profile 只加载该一个 package，且 `start_online=false`、`natives=[]`。

## 3. 游戏验收记录

| 项目 | 状态 | 实际结果 |
|---|---|---|
| 4+2 package 加载 | PASS | me3 日志确认指定 package 已 override |
| 原生大盾兵道具 | LOADED | 用户使用并召唤成功 |
| 大盾兵实际数量 | PASS | 4 只 |
| 原生孤狼道具 | LOADED | 遣返后用户使用并召唤成功 |
| 孤狼实际数量 | PASS | 2 只 |
| 明显召唤异常 | PASS | 用户未报告异常 |
| 游戏正常退出 | PASS | 用户确认正常退出 |

修正后的 4+2 package 加载状态：`PASS`。me3 日志确认：

- me3 `0.13.0`；
- Profile 中 `packages` 只有 `erai-unified-4-2`；
- 实际 override 路径为 `<ERAI_ROOT>\work\erai-unified-spirit-count-74\generated\greatshield-4-lone-wolf-2\package\regulation.bin`；
- 实际 SHA256 为 `45BE1C51B7018860E83F20B846FF647C32A88539D46791D61AF95A0E89B212B6`；
- 游戏为 Elden Ring `1.17.1.0 Worldwide`。

## 4. 用户手动步骤

1. 确认 Elden Ring、me3、me3-launcher 均已关闭。
2. 双击 `Launch-4plus2-75.cmd`。
3. 使用原生大盾兵骨灰道具，记录是否出现 4 只。
4. 按正常流程结束或遣返后，使用原生孤狼骨灰道具，记录是否出现 2 只。
5. 正常退出，并保留 `launcher-output-75.txt`。

如现场无法在同一会话切换骨灰，可在正常退出后使用同一个入口再次手动启动一次；总计最多两次有效会话。数量错误、崩溃或加载异常时停止，不重新生成包。

## 5. 当前裁决边界

本次通过只证明一个 `Greatshield=4 / Lone Wolf=2` 组合：同一 package 下，大盾兵实际 4 只、遣返后孤狼实际 2 只，游戏正常退出。不能推广到其它组合、混合同时召唤或智能护卫功能。
