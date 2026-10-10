# 69-CODEX-ERAI-CONFIGURABLE-SUMMON-COUNT-MVP

## 最终状态

**`IMPLEMENTED_OFFLINE`**

已在独立目录制作真实的 1～5 只大盾士兵参数包、me3 Profile、数量选择脚本和逐表/逐行验证证据。没有启动游戏，因此 1～4 只的实际召唤数量仍是 `GAME ACCEPTANCE PENDING`；这没有被写成游戏验收通过。

68 号实验版和 50/62 原始资产均保持不变。

## A. 召唤数量的实际控制机制及证据

### 已确认的机制

当前本机 `BuddyParam` 定义：

`<GAME_ROOT>\Smithbox_2_2_6_2026_09_20_b\Assets\PARAM\ER\Defs\BuddyParam.xml`

目标大盾行：`24800000`～`24800004`。既有 50/51 证据确认：

- 五行的 `npcParamId` 均为 `170001000`；
- 五行的 `npcThinkParamId` 均为 AI_SUMMON_BASELINE 的 `270001001`；
- 同一连续 Buddy 行组对应五只实际出现的大盾兵；
- 既有日志记录 `scan complete: 5 candidate(s)`，并与该五行集合吻合。

项目既有只读人数报告 `docs/PLAN-阶段3b-人数生效.md` 的 H1 结论是：同名连续 BuddyParam 行数与基础召唤数量相符；大盾 5 行、狼 3 行、权贵 5 行和其它已抽样种类也有交叉记录。该证据足以支持本任务的窄范围子集：只对已经确认的五条大盾行做尾部删减。

### 没有使用的伪入口

- BuddyStone 的 `activateRange`、`overwriteReturnRange`、`summonedEventFlagId` 只控制召唤条件/区域/重复召唤相关行为，不是成员数量入口；本轮没有改它们。
- 已有代码常量/容量候选没有被改写；没有修改 EXE、DLL、native 或运行时内存。
- 没有按字段名称猜测其它参数，也没有删除未知 Buddy 行。

## B. 实际制作的内容

根目录：

`<ERAI_ROOT>\work\erai-configurable-summon-69`

### 生成器和用户入口

- `make-count-variants.ps1`：使用已存在的 PowerShell 7 和 `Andre.SoulsFormats.dll`，从 AI_SUMMON_BASELINE 生成 1～5 变体；拒绝覆盖已有产物。
- `verify-count-variants.ps1`：逐条目、逐保留 Buddy 行和 Profile 做离线校验。
- `Choose-Count.cmd` / `Select-Count.ps1`：只接受单个数字 `1`～`5`，校验哈希后生成 `selected\ERAI-Selected.me3` 和 `selected\selection.json`，不启动 me3 或游戏。
- `README.md`：普通玩家说明、限制和回滚。

工具仅依赖本机已有的 Smithbox 组件：

`<GAME_ROOT>\Smithbox_2_2_6_2026_09_20_b\Andre.SoulsFormats.dll`

SHA256：`854742628B9054E94FCE9790364BE8E13396649E73BDD6C63FB592B44C9257D3`。

脚本通过已验证的 BND/PARAM/DCX 读写路径生成文件；没有修改该工具目录。

### 每种配置

每个 `variants\count-N` 都包含：

- `package\regulation.bin`
- `profile\erai-count-N.me3`

Profile 固定：

- `start_online=false`
- `natives=[]`
- 游戏 EXE：`<GAME_ROOT>\RING\Game\eldenring.exe`
- 只引用自己的 `count-N\package`

## C. 用户如何选择数量

资源管理器双击：

`<ERAI_ROOT>\work\erai-configurable-summon-69\Choose-Count.cmd`

输入 `1`、`2`、`3`、`4` 或 `5`。脚本不会修改游戏目录，也不会启动游戏。随后由经过 L3 批准的独立 me3 入口加载 `selected\ERAI-Selected.me3`；本轮没有创建或执行该启动流程。

无效输入（例如 `0`、`6`、`1.5`、`-1`、`abc`、`01`）已离线验证为拒绝，并且不会覆盖上一次有效选择。

## D. 每种配置的差异验证

基础输入：

`<ERAI_ROOT>\work\summon-baseline-50\AI_SUMMON_BASELINE\package\regulation.bin`

输入 SHA256：

`D3C90B8E4BDB4699E0C8D13DC23CAB050AC4CDA6413937C450E79342EB6F658F`

所有变体均为 `11711000`、194 个 BND 条目、DCX_ZSTD。差异和哈希：

| 数量 | 输出 SHA256 | 移除 Buddy 行 | Buddy 行数 | 游戏验收 |
|---:|---|---|---:|---|
| 1 | `12B4006FDF093DC92C2F8D2B7678218362BB8F96BC1FE317F556BAB6144B0DFA` | 24800001～24800004 | 166 | 未运行 |
| 2 | `08E0124DEDA66D4A626BE3ABA435EB2E0BF4A60E533C657DE71B7723FEF5F9D2` | 24800002～24800004 | 167 | 未运行 |
| 3 | `08EEE87761CC7DBD59A0925C94F6DA28FEE3848534FF3A374D1961F4A00D6571` | 24800003～24800004 | 168 | 未运行 |
| 4 | `E2E070B4B738D816FEA874AA32C0BA3F2B7FE13E646CCCF38915357C577A0642` | 24800004 | 169 | 未运行 |
| 5 | `D3C90B8E4BDB4699E0C8D13DC23CAB050AC4CDA6413937C450E79342EB6F658F` | 无 | 170 | 使用既有五只基线验收 |

逐表校验结果：

- 1～4 只变体只有 BND 条目索引 15（BuddyParam）发生 payload 差异；其它 193 个条目字节哈希保持一致；
- NpcThinkParam 整表字节哈希保持一致；AI 行和 `backhomeBattleDist` 均未改变；
- BuddyStone 整表保持一致；
- BuddyParam 中所有未删除行按 ID 逐行字节哈希保持一致；
- 每个保留的大盾行仍为 `npcParamId=170001000`、`npcThinkParamId=270001001`；
- 必要的 PARAM 行目录、偏移和 BND 重排被记录为序列化结构变化，不包含其它参数行为修改。

完整证据：

- `count-variants-manifest.json`
- `independent-byte-verification.json`

## E. 哪些数量通过离线验证

离线生成、格式、哈希、行集合和 Profile 校验：**1、2、3、4、5 全部 PASS**。

真实游戏数量：

- 5：已有 50/51/52 历史验收，且 count-5 是 AI_SUMMON_BASELINE 的字节相同副本；
- 1～4：本任务没有启动游戏，不能宣称实际召唤数量已验证。

## F. 未完成的游戏验收

需要后续 L3 单独批准的最小验收：每个数量最多一次离线游戏会话，使用同一 C/me3 环境，确认召唤瞬间实际出现数量分别为 1、2、3、4；出现数量不符或加载异常立即停止，不改参数继续尝试。

本轮没有进入游戏，也没有自动开始该验收。

## G. 回滚

不需要恢复原版文件。停用时停止使用 69 的 Profile，改回 68 或其它已批准 Profile；删除或停用 `<ERAI_ROOT>\work\erai-configurable-summon-69` 即可撤销本功能。50、62、68 包、原版 `regulation.bin`、游戏 EXE、存档和全局 me3 配置没有被覆盖。

## H. 是否形成实际新增功能

**是，形成了真实的离线配置功能子集：**用户输入 1～5 会选择不同真实 `BuddyParam` 行集合对应的参数包，而不是只改变显示文字。

边界是：数量效果尚未对 1～4 进行游戏验收；骨灰类型自由选择仍未实现；这不是智能护卫功能。

## I. 保护与安全记录

- 68 实验版未改动；
- AI_SUMMON_BASELINE 原始包未改动；
- 游戏原版 `regulation.bin` SHA256 仍为 `766521F9508DE3A3532DF61C45A1C2D93340F1FF7ED8306AB20DF761712CA2AB`；
- 游戏 EXE 未改动；
- 没有 DLL/native、内存写入、Hook、第三方实体工具或存档修改；
- 没有提交 Git 或修改 ERAI 源码仓库。

**69 COMPLETE — IMPLEMENTED_OFFLINE / 1–4 GAME ACCEPTANCE PENDING。**
