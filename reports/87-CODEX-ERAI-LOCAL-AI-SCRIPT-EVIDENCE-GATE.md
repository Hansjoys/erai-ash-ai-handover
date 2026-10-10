# 87-CODEX-ERAI-LOCAL-AI-SCRIPT-EVIDENCE-GATE

范围：只读核验；未启动游戏、未修改81号或游戏文件、未运行 DLL/Hook。

## 1. 81号实际参数映射

核验包：`<ERAI_ROOT>\work\erai-usable-experimental-81\generated\greatshield-4-lone-wolf-2\package\regulation.bin`

SHA256：`45BE1C51B7018860E83F20B846FF647C32A88539D46791D61AF95A0E89B212B6`

使用现有可信 `Andre.SoulsFormats.dll` 与 Elden Ring 11711000 参数定义离线读取：

- BuddyParam `24800000–24800003`（4只大盾兵）均引用 `npcParamId=170001000`、`npcThinkParamId=270001001`。
- 81号实际使用的复制 Think 行是 `270001001`，不是直接使用历史原行 `170001000`。
- `NpcThinkParam 270001001`：`logicId=10000`、`battleGoalID=700010`、`isBuddyAI=1`、`backhomeDist=9999`、`backhomeBattleDist=999`。
- 原始 `170001000` 也为 `logicId=10000`、`battleGoalID=700010`，但其回靠字段为81号变体的基础来源，不能替代对成品行的核验。

证据文件：

- `<ERAI_ROOT>\work\l3\recheck-2026-10-07\_t6.txt`
- `<ERAI_ROOT>\work\l3\recheck-2026-10-07\_t5.txt`
- `<ERAI_ROOT>\work\erai-usable-experimental-81\Configure-ERAI.ps1`

## 2. 本机 AI 资源检查

只读检查结果：

- `<GAME_ROOT>\RING\Game` 中未发现可读取的 Elden Ring AI Lua、`logic.dec.lua`、Goal 脚本或等价解包 AI 资源。
- 发现的 `modengine2\lua.dll` 和 Lua 头文件属于运行框架，不是游戏 AI 逻辑正文。
- 已有 Smithbox 目录提供参数定义和编辑器资源，但未发现当前游戏 AI Lua/Goal 正文或可信 AI 脚本解析结果。
- `<ERAI_ROOT>\work` 中存在旧的参数审计资料和第三方/历史文本，但没有与当前81号 `logicId=10000`、`battleGoalID=700010` 绑定的本机1.17.1脚本正文。
- 本轮没有安装或下载解析工具，也没有扩大文件扫描。

## 3. 可确认与不可确认内容

已确认：

- 81号大盾兵确实使用 `logicId=10000` / `battleGoalID=700010` 的 NpcThink 行。
- 当前成品行和历史目标行的映射可由本机参数文件直接读取。

无法确认：

- `logicId=10000` 在本机1.17.1实际对应的 Lua 文件正文；
- `battleGoalID=700010` 对应的 Goal 脚本；
- 接敌目标选择、追敌距离判断、TARGET_LOCALPLAYER 分支；
- 事件请求响应、回防或跟随行为切换。

公开旧版 Lua 参考不能代替本机当前版本资源，因此不用于升级结论。

## 4. 结论

**PARAM_MAPPING_ONLY**

参数映射已确认，但没有得到可验证的当前1.17.1 AI脚本正文。不能提出基于真实脚本的最小护卫原型，也不能把历史 `logicId`/`battleGoalID` 数字解释成已知回防逻辑。

主要阻碍是：当前游戏安装目录没有可读取的目标 AI 资源，现有可信工具也没有提供已解包、版本固定的 AI Lua/Goal 正文。按照止损规则，本轮不安装工具、不下载资源、不开展反编译。

## 5. 是否值得继续

在获得当前1.17.1对应 AI 脚本资源及可信版本标记之前，不值得继续投入参数或运行时实验。若未来 L3批准，唯一必要前提是取得与当前 EXE/版本匹配的 `logicId=10000` 和 `battleGoalID=700010` 脚本正文；本报告不授权获取或修改该资源。