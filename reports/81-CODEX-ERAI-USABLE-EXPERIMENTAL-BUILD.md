# 81-CODEX-ERAI-USABLE-EXPERIMENTAL-BUILD

## 最终状态

**USABLE_EXPERIMENTAL_BUILD_READY**（离线构建与门禁核验通过；本轮未启动游戏）。

## 1. 实际交付目录

`<ERAI_ROOT>\work\erai-usable-experimental-81`

新增/整合入口：

- `Configure-ERAI.cmd`
- `Configure-ERAI.ps1`
- `Launch-ERAI.cmd`
- `Launch-ERAI.ps1`
- `Validate-ERAI.ps1`
- `README.md`
- `selection.json`

独立生成/复用包：

- `generated\greatshield-4-lone-wolf-2\package\regulation.bin`
- `generated\greatshield-4-lone-wolf-2\profile\erai-unified-4-2.me3`
- `generated\greatshield-2-lone-wolf-3\package\regulation.bin`
- `generated\greatshield-2-lone-wolf-3\profile\erai-unified-2-3.me3`
- `generated\greatshield-3-lone-wolf-1\package\regulation.bin`
- `generated\greatshield-3-lone-wolf-1\profile\erai-unified-3-1.me3`

## 2. 复用关系

- 配置和参数处理逻辑直接复制74号 `Configure-Unified-74.ps1` 到81号并仅将输出根目录改为81目录。
- 74号已生成的4+2和2+3包复制到81目录；未修改74号、75号或50/62号资产。
- 75号的离线 me3/C 启动参数模式被收敛到81号 `Launch-ERAI.ps1`，通过 `selection.json` 读取当前组合。
- 81号不加载 DLL/native，不使用旧运行时路线。

## 3. 用户操作

1. 双击 `<ERAI_ROOT>\work\erai-usable-experimental-81\Configure-ERAI.cmd`。
2. 输入 Greatshield `1-5` 与 Lone Wolf `1-3`。
3. 配置器生成或复用本目录组合，并更新 `selection.json`。
4. 双击 `Launch-ERAI.cmd`。入口重新核验包、Profile、游戏版本/哈希、进程状态、`start_online=false`、`natives=[]`，然后才调用用户手动选择的 C 环境 me3 Profile。
5. 游戏内仍使用原生骨灰道具选择种类；不支持两种骨灰同时在场。

## 4. 离线核验

已执行 PowerShell 7 配置和门禁核验：

- 4+2：复用包 SHA256 `45BE1C51B7018860E83F20B846FF647C32A88539D46791D61AF95A0E89B212B6`，验证通过。
- 2+3：复用包 SHA256 `08E0124DEDA66D4A626BE3ABA435EB2E0BF4A60E533C657DE71B7723FEF5F9D2`，验证通过。
- 3+1：在81目录独立生成，SHA256 `9B4D43FFE89F360640038DA683ECBD5890E0204BB3F4EB2AFBE906A1E7E3D53E`，回读和门禁核验通过。
- 选择范围：大盾兵1-5、孤狼1-3；非法输入由参数验证拒绝。
- Profile：只引用当前组合的唯一 package，`start_online=false`、`natives=[]`。
- 游戏：ProductVersion `2.7.1.0`，SHA256 `1A3547101327F65D0C76DA2F9190AC0AA66871EA42BAE2AECC61E11A8B597891`。
- 进程门禁：检测 Elden Ring、me3、me3-launcher 并发进程。

## 5. 游戏验收边界

- 4+2 已有75号 GAME PASS：大盾兵4只，遣返后孤狼2只。
- 大盾兵1-5和孤狼1-3分别已有历史 GAME PASS。
- 81号3+1只是 OFFLINE_VALIDATED，未宣称游戏通过。
- 74号理论上的其它组合没有被自动升级为 GAME PASS。
- 本轮没有启动游戏，也没有重复验收。

## 6. 停用与回滚

关闭游戏后停止使用81号入口，改用原版或既有 me3 启动入口。81号不覆盖游戏目录、原版 regulation.bin、存档、全局 me3 配置、DLL 或 native；删除81目录即可停用，不需要恢复其它目录。

## 7. 与智能护卫的差距

该实验版只固定数量和两种骨灰的原生参数组合。尚未实现混合队伍、玩家威胁识别、成员级目标/跟随/返回/导航控制、自动场景适应或玩家保护优先逻辑。
## 8. 启动入口整改

原问题：旧 `Launch-ERAI.ps1` 在调用 PowerShell 验证脚本后检查 `$LASTEXITCODE`。该验证脚本不是原生子进程，导致门禁通过后可能提前退出，未执行后续 me3 调用。

修复：

- 保留原 Validate-ERAI 全部安全门禁；
- 改用 `try/catch` 判断验证失败；
- 通过后读取当前 `selection.json`；
- 复用75号已验证的 me3 命令参数：`--crash-reporting=false --profile-dir ... launch --game eldenring --exe ... --profile ... --online=false --disable-arxan=false --skip-steam-init=false`；
- 写入 `launcher-output-81.txt`；
- me3 或门禁失败时显示中文错误并等待回车，不闪退。

离线检查：

- PowerShell 脚本解析：PASS；
- Validate-ERAI：PASS；
- 当前4+2 package SHA256：`45BE1C51B7018860E83F20B846FF647C32A88539D46791D61AF95A0E89B212B6`；
- me3 文件存在：PASS；
- 未执行 Launch-ERAI，未启动 me3 或游戏。

用户应双击：

`<ERAI_ROOT>\work\erai-usable-experimental-81\Launch-ERAI.cmd`
## 9. 用户真实启动验收

用户手动双击81号 `Launch-ERAI.cmd`，结果：

- 正常进入游戏；
- 使用4+2配置召唤出4只大盾兵；
- 遣返后召唤出2只孤狼；
- 正常退出游戏。

因此，81号一键启动入口及已验收的 `Greatshield=4 / Lone Wolf=2` 组合在该次用户会话中通过。其它未进行游戏验收的组合仍保持原报告状态，不作推广。