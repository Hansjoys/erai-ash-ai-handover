# ERAI 72 — Spirit type selection MVP

## 结论

**PARTIAL**

本轮在独立目录生成了 Lone Wolf（孤狼）1、2、3 名成员的离线参数包。它们没有经过游戏验收；因此不能宣布新种类功能 PASS。已经通过游戏验收的 Greatshield Soldier 1–5 数量功能未改动。

## 1. 已核验的种类选择和成员结构

- 原生游戏已有骨灰道具选择入口；本轮没有制作一个会绕过原生选择的伪 UI。
- 当前本机 1.17.1 BuddyParam 证据文件 `<ERAI_ROOT>\work\erai-handover-2026-10-04\config\data\ash_base_count.json` 将 Lone Wolf 登记为：
  - Buddy 基准 ID：`23200000`
  - NpcParam ID：`140700000`
  - 连续成员行：`23200000`、`23200001`、`23200002`
  - 默认成员数：3
  - 证据等级：verified（离线结构证据）
- 同一证据将 Greatshield Soldier 登记为 `24800000..24800004`、`170001000`、5 名；这些行在本轮所有输出包中保留。
- BuddyStoneParam 当前已验证的召唤扩展是对 303 个非零行的公共修改，不能作为“某个道具专属 Lone Wolf 映射”的独立证明。解析结果中的 `buddyId` 不能提供可靠的直接道具→Buddy 行闭环，因此该闭环仍待游戏/更具体资源证据确认。

## 2. 实际生成的离线包

工作目录：`<ERAI_ROOT>\work\erai-spirit-type-selection-72`

所有包均来自已验收的 `<ERAI_ROOT>\work\summon-baseline-50\AI_SUMMON_BASELINE`，BND 版本为 `11711000`，文件数为 194，`natives = []`，`start_online = false`。

| 变体 | 保留 Lone Wolf 行 | 删除的行 | Buddy 行总数 | 包 SHA256 | 游戏验收 |
|---|---|---|---:|---|---|
| `variants\lone-wolf-count-1` | 23200000 | 23200001、23200002 | 168 | `8F803714A08E0EF4149A1A4DD1D74BBBCBA42825CBA1A1F864848682F95715FF` | NOT_RUN |
| `variants\lone-wolf-count-2` | 23200000、23200001 | 23200002 | 169 | `03257C7AE537F7851C5C84D7DC8601410BD7CAA07451000F823E5C489265C943` | NOT_RUN |
| `variants\lone-wolf-count-3` | 23200000、23200001、23200002 | 无 | 170 | `D3C90B8E4BDB4699E0C8D13DC23CAB050AC4CDA6413937C450E79342EB6F658F` | NOT_RUN |

count-3 与原 `AI_SUMMON_BASELINE` 包字节相同，因为没有需要删除的成员行。

每个变体有对应 profile：

- `variants\lone-wolf-count-1\profile\erai-wolf-1.me3`
- `variants\lone-wolf-count-2\profile\erai-wolf-2.me3`
- `variants\lone-wolf-count-3\profile\erai-wolf-3.me3`

操作方式仍是使用游戏原生的孤狼骨灰道具选择种类；profile/package 只负责该种类的成员行子集。没有制作混合种类队伍，也没有新增图形 UI。

## 3. 离线差异核验

源包：

- `AI_SUMMON_BASELINE\package\regulation.bin`：`D3C90B8E4BDB4699E0C8D13DC23CAB050AC4CDA6413937C450E79342EB6F658F`
- `AI_SUMMON_BASELINE\expected.bnd4`：`B1D2D909F5AA3490311CF27627B037DFA495E24DA1545CA6616CFCBBB9FECFCD`
- 当前游戏原版 `<GAME_ROOT>\RING\Game\regulation.bin`：`766521F9508DE3A3532DF61C45A1C2D93340F1FF7ED8306AB20DF761712CA2AB`，只读核验未改变。

验证结果（`offline-verification.json`）：

- 三个输出均可解密回读，BND 版本 `11711000`、文件数 `194`。
- 目标 Lone Wolf 行数分别为 1、2、3，且 ID 连续从 `23200000` 开始。
- 五条 Greatshield 行 `24800000..24800004` 在三个输出中均保留，仍引用 `npcParamId=170001000`、`npcThinkParamId=270001001`。
- `NpcThinkParam` 文件哈希与源包一致。
- `BuddyStoneParam` 文件哈希与源包一致。
- 非目标 Buddy 行数量保持为 167；生成逻辑只删除批准的 Lone Wolf 尾部成员行。
- 没有 DLL、native、游戏内存写入、原版文件写入或存档改动。

生成及验证脚本仅位于 72 目录：

- `make-lone-wolf-variants.ps1`
- `verify-72.ps1`

详细清单见 `lone-wolf-variants-manifest.json` 与 `offline-verification.json`。

## 4. 是否需要额外配置 UI

不需要新增种类 UI：游戏已有骨灰道具选择种类的入口，本轮应复用它。新增的 profile 名称只表达成员数量，不能替代游戏内骨灰道具选择。

## 5. 对 70 号成果的影响

没有修改 `erai-configurable-summon-69`、`erai-count-acceptance-70`、`erai-experimental-build-68`、50/62 包或原版 regulation。72 包是独立目录；其中 Greatshield 五行保留，不能反向改变 70 号已验收功能。

## 6. 尚待游戏验收的内容

必须在后续单独批准的游戏会话中确认：

1. 选择原生孤狼骨灰道具时，游戏是否确实消费对应 23200000 系列 Buddy 行；
2. 1、2、3 三个变体实际召唤数量是否分别为 1、2、3；
3. 遣返、战斗、重复召唤和模型/行为是否正常；
4. 72 包与现有公共召唤扩展组合是否存在未预见副作用。

在这些会话完成前，1–3 仅为 `OFFLINE_VALIDATED`，不是 `GAME_PASS`。

## 7. 回滚

不把任何 72 包复制到游戏目录即可回滚；继续使用原有 C/me3 profile 或既有 50/62/68/69 目录即可。原版和历史包未被覆盖。

## 8. 产品增量与阻碍

实际增量是：有真实 Buddy 行依据的第二种骨灰（Lone Wolf）1–3 成员独立离线包及 profile，而不是只显示名称的界面。

唯一关键阻碍是：本机离线资料没有形成“原生召唤道具 → BuddyStone/23200000 成员组”的独立、当前版本运行时闭环证据；此外 1–3 尚未游戏验收。因此本轮不能声称自由骨灰种类选择已经完成。

**状态：PARTIAL**

