# ERAI 90-B-V1 Guard Action Experiment

状态：A_GROUP_GUARD_V1_PREPARED（仅离线候选，未启动游戏）

## 文件
- Lua源：<ERAI_ROOT>\work\erai-ai-source-90\group-guard-v1\700010_battle.guard-v1.lua
- 编译LuaP：<ERAI_ROOT>\work\erai-ai-source-90\group-guard-v1\build\700010_battle.guard-v1.lua
- 重包资源：<ERAI_ROOT>\work\erai-ai-source-90\group-guard-v1\package\script\700010_battle.luabnd.dcx
- regulation副本：<ERAI_ROOT>\work\erai-ai-source-90\group-guard-v1\package\regulation.bin
- Profile：<ERAI_ROOT>\work\erai-ai-source-90\group-guard-v1\erai-90-group-guard-v1.me3
- Manifest：<ERAI_ROOT>\work\erai-ai-source-90\group-guard-v1\manifest.json

SHA256：
- regulation.bin：45BE1C51B7018860E83F20B846FF647C32A88539D46791D61AF95A0E89B212B6（81副本，未改）
- 700010_battle.luabnd.dcx：F4B2C5E60C78CF1D0E830F719494829E93E607088895DC958640C6DECD121B2B
- Lua源码：8100E85093D9417B243F0C3B31DDD09C4B47D119DEA8EF038DDD73F7A0F2E5F7
- 编译LuaP：3F5DC726C3F596DE65E0D040B91711AA8AE4F05B52C9031E006CD0C9E8B29682
- 原始89资源：A57684D1826E7246139262057E7834D1141E15112A4922144E97C31A02908194

## Lua差异
在Goal.Activate读取现有GetDist(TARGET_ENE_0)之后，增加GetDist(TARGET_HOSTPLAYER)。当自身到玩家不超过8、到当前敌人不超过12，并且不处于10312+10317/10318强制分支时，将动作权重24设为100。新增注册BuddyStandardShield700010_Act24，动作顺序为：
1. GOAL_COMMON_ApproachTarget，目标TARGET_HOSTPLAYER，3秒、距离3；
2. GOAL_COMMON_Guard，目标TARGET_ENE_0，5秒。

其余Think/Buddy、Goal编号、其他AI资源均未改动。容器重包后内部文件仍为ID 1000的700010_battle.lua与ID 1000000的luagnl；luagnl保持原始1456字节。

## 编译与预检
LuaCompiler已成功编译，输出44481字节；DCX/KRAK重包成功，输出6976字节；再次解包核对内部文件名、ID和大小通过。Profile保持start_online=false、
atives=[]，只引用本目录一个package。未启动游戏。

## 风险与测试边界
这是共享700010 Goal，四名成员都可能同时满足几何条件；因此可能四名同时靠近玩家并举盾，不能保证只有一名执行，也不能保证其他三名继续攻击。该条件是几何近邻，不是攻击意图预测；TARGET_ENE_0是每个实例自己的当前目标。动作终止依赖子Goal的3秒/5秒结束及下一次Goal.Activate，未新增状态变量。若后续获准人工测试，观察四名是否同时触发、是否恢复攻击、是否出现反复覆盖或全员脱战；异常立即停止并恢复81 Profile/package。

恢复：停用本Profile，改回81号已验收Profile和原package；本候选不覆盖81文件。
