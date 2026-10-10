# 68-CODEX-ERAI-PLAYABLE-EXPERIMENTAL-BUILD

## 1. 实际生成内容

已在独立目录生成阶段性实验版：

`<ERAI_ROOT>\work\erai-experimental-build-68`

文件：

| 文件 | 用途 | SHA256 |
|---|---|---|
| `package\regulation.bin` | AI_SUMMON_BASELINE 的完整副本 | `D3C90B8E4BDB4699E0C8D13DC23CAB050AC4CDA6413937C450E79342EB6F658F` |
| `profile\erai-experimental-68.me3` | 独立 me3 profile | `C00066687896F54936C52192E216CEE1868D62899AF638D36B5451391133512B` |
| `launch\Launch-ERAI-Experimental-68.cmd` | 用户启动入口（本轮未执行） | `A87D0CF68FE98B0887D702ED65E17F624768C6E7308CC93F2319B9047DA50BA3` |
| `README.md` | 普通玩家使用、停用和限制说明 | `8DBF29507F4630AE38E751E6F7C3770F71CC4D0E9A54ECE2C09CBE900DB0EAF7` |
| `build-manifest.json` | 版本、来源、固定输入和哈希清单 | `B1D55F1EFCEBCFB1F9396B8E4B45921E8F2F893A149DAB4737386CD7CC563D0D` |

实验包来源：

`<ERAI_ROOT>\work\summon-baseline-50\AI_SUMMON_BASELINE\package\regulation.bin`

源文件和交付副本 SHA256 完全相同，未重新制作、解密或重包。

本交付不复制 me3 程序文件；启动入口固定引用已经验证的 C 环境：

`<USER_HOME>\AppData\Local\ERAI-UserTests\me3-0.13.0\bin\me3.exe`

该 me3 版本 SHA256 为：

`203A726AB40ECAC6EE9DEABA1AA96F741D87E12DEF549CDEB48F99E5FE16D52D`

## 2. 离线静态验收

已通过：

- package 文件存在；
- package 哈希等于批准的 AI_SUMMON_BASELINE 哈希；
- profile 只有一个 package，且指向交付目录自己的 `package`；
- `start_online=false`；
- `natives=[]`；
- 游戏 EXE 固定为 `<GAME_ROOT>\RING\Game\eldenring.exe`；
- profile 的 BND/游戏版本目标为 Elden Ring 1.17.1 / `11711000`；
- package 目录没有 DLL、EXE 或 ASI；
- 启动脚本只引用 C 环境 me3、固定游戏 EXE 和本目录 profile；
- 启动脚本已修正为从 `launch` 子目录正确指向上级 `profile`；
- 没有创建授权、attempt、旧 Mod Engine 配置或全局 me3 配置；
- 没有执行 launch 分支。

`AI_SUMMON_BASELINE` 的既有验证记录显示：五条大盾兵 Buddy 使用独立 Think 行，召唤扩展公共基线已经验证；me3 override 和游戏启动在此前 45/52/65 任务中验证过。本轮只是复制已验收资产，没有重新宣称这些历史结果是本目录的新游戏验收。

## 3. 当前实验版能做什么

- 复用已验证的召唤扩展，使测试环境能够使用五只 +10 大盾兵；
- 使用 AI_SUMMON_BASELINE 的原生参数，已有观察显示它比 CONTROL 更积极地发现/接近敌人；
- 通过独立 me3 profile 加载单一 regulation package，避免覆盖游戏原版文件；
- 退出游戏后停用入口即可回滚，不需要恢复游戏目录文件。

## 4. 当前未完成与限制

这不是智能护卫完成版，也没有宣称玩家保护成功。当前缺少：

- 经过验证的玩家身份和玩家受威胁状态；
- 部分成员留守、动态回防、威胁拦截和按成员目标控制；
- 箱庭/开放世界/Boss 自动场景适应；
- 稳定的法师输出窗口保证；
- 普通玩家可选择 1～5 只和骨灰种类的安全配置入口；
- 1～4 只及其它骨灰种类的逐项游戏验收。

当前交付只把“五只 +10 大盾兵”作为已验证范围，不把 5 解释为最终固定队伍规模。62 的回靠变体没有混入本包，避免把未证明的保护倾向混入基础交付。

## 5. 普通玩家启动与回滚

本轮没有启动游戏。后续若经 L3 单独批准一次用户验收，关闭 Elden Ring 后由资源管理器双击：

`<ERAI_ROOT>\work\erai-experimental-build-68\launch\Launch-ERAI-Experimental-68.cmd`

入口要求离线单机，使用同一受控存档。它不会要求用户修改原版 `regulation.bin`，也不会加载 ERAI DLL/native。用户不要把本目录文件复制到 `<GAME_ROOT>\RING\Game` 或旧 Mod 目录。

停用方式：退出游戏后不再使用该 CMD，改用原来的 Vanilla 或其它已批准 profile。删除或改名 `<ERAI_ROOT>\work\erai-experimental-build-68` 即可撤销本实验目录；原版游戏文件、50/62 包、历史 launch 目录、存档和全局配置均不在该目录内。

## 6. 原有资产不变性

本轮只在 `<ERAI_ROOT>\work\erai-experimental-build-68` 新建文件并复制 package。没有覆盖或修改：

- 游戏原版 `regulation.bin`；
- `<ERAI_ROOT>\work\summon-baseline-50`；
- `<ERAI_ROOT>\work\summon-baseline-62`；
- `native-ai-pilot-22`；
- `launch-59/62/64/65`；
- ERAI 源码仓库；
- C 环境 me3 程序；
- 存档、游戏 EXE、DLL/native 和安全设置。

源码仓库 `<ERAI_ROOT>\工作区\erai-handover-2026-10-04` 工作树保持干净。本轮没有 Git commit、构建、部署、游戏内存读取或写入。

## 7. 验收状态与下一步

**OFFLINE BUILD PASS / GAME ACCEPTANCE PENDING**

需要一次用户游戏验收，才能确认本交付目录在实际 C/me3 环境中仍能进入游戏并消费该 package；本轮不得把离线哈希和 profile 检查写成游戏通过。

距离最终智能护卫产品仍缺少可信的玩家/威胁状态来源、成员级控制接口、动态场景策略、1～5 配置层和跨场景行为验收。按照 67 号裁决，本轮不自动开启下一任务。

**68 COMPLETE — ISOLATED EXPERIMENTAL BUILD CREATED / GAME ACCEPTANCE PENDING。**
