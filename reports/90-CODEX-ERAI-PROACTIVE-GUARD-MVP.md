# 90-CODEX-ERAI-PROACTIVE-GUARD-MVP

最新追加状态：RECOMPILED_AI_BASIC_RUNTIME_PASS（L3转述用户验收）；首代护卫候选仍未制作，阻塞于当前版本的脚本内单成员身份读取契约。以下早期状态保留为历史。

状态：**NO_PROTOYPE / BLOCKED**

本轮未启动游戏、未修改81号、89号或游戏原版，未制作参数包、Lua补丁、DLL、Hook或内存写入工具。

## A. 已确认的技术路径与证据

89号已取得当前本机1.17.1的 `010000_logic.lua` 和 `700010_battle.lua` 反编译文本。

- `700010_battle.dec.lua` 的 `Goal.Activate` 读取 `GetDist(TARGET_ENE_0)`，并按当前敌人距离选择攻击/接近动作。
- Act05/06/07/16/19 使用 `TARGET_ENE_0` 的接近或攻击Goal。
- Act40读取 `GetDist(TARGET_HOSTPLAYER)`，并包含向 `TARGET_HOSTPLAYER` 的 `ApproachTarget`/`LeaveTarget`。
- Interrupt中的特殊效果83/90分支也可先接近 `TARGET_HOSTPLAYER`，再攻击 `TARGET_ENE_0`。
- 但当前 `Goal.Activate` 的权重和注册路径没有选择Act40；特殊效果83/90的来源和可安全触发方式也没有证据。

这些证据支持已有AI动作构件，不能证明主动预防性威胁判断。

## B. 是否制作90号原型

没有制作。

原因是三个关键条件不能同时满足：

1. `GetDist(TARGET_HOSTPLAYER)` 是骨灰到玩家距离，`GetDist(TARGET_ENE_0)` 是骨灰到当前敌人距离；没有当前脚本证据显示敌人到玩家距离、敌人攻击目标、移动方向或“即将袭击玩家”的状态。两项距离不能可靠构造指定威胁判断。
2. 四条BuddyParam可分别引用ThinkParam，但当前唯一已核实的战斗Goal仍是 `700010`。复制Think行并继续使用700010不能创建护卫专用Goal；没有当前版本可加载的独立Goal/logic资源。
3. 没有成员级运行时身份和职责绑定证据，不能保证一名成员护卫而另外三名继续独立战斗。

因此制作一个“改变Think值”或“显示护卫配置”的包，会把参数差异冒充主动预防性保护，验收不具备区分力。

## C. 文件和基线

81号基线保持不变：

`<ERAI_ROOT>\work\erai-usable-experimental-81`

89号反编译证据保持不变：

`<ERAI_ROOT>\work\erai-ai-source-89\analysis\decompiled\010000_logic.dec.lua`

`<ERAI_ROOT>\work\erai-ai-source-89\analysis\decompiled\700010_battle.dec.lua`

本轮没有新增可运行实验文件，也没有改变这些文件的内容。

## D. 最短可行后续路径

只有取得以下两项新的、当前版本可核验的证据，才值得再次申请原型：

1. 能在未受击前识别“敌人正在接近玩家”的状态或目标关系；
2. 能把护卫Goal稳定绑定到指定单个召唤成员，并让其余成员保持原战斗Goal。

在此之前应保持81号可用实验版，停止继续修改 `backhomeBattleDist`、复制Think行或猜测特殊效果。

## E. 最终结论

**未成功制作90号最小护卫原型。** 当前距离主动预防性保护仍缺少威胁信息来源和成员级控制/隔离契约。没有安全、可审查、可实际验证的下一步运行时实验；任何DLL、Hook或内存写入仍需另行批准，并且不能替代上述缺失证据。

## 补充核验：GetDistAtoB / GetNpcThinkParamID（2026-10-10）

### A. GetDistAtoB

公开 ERAiAPI 文档将 `GetDistAtoB(targetA, targetB)` 描述为读取两个目标之间的距离，并说明目标距离包含碰撞胶囊：
https://eladidu.github.io/readable-ds-lua/d1/d81/class_ai_func.html

证据等级：**REFERENCE-ONLY / SOURCE-DOCUMENTED**。该页面不是本机1.17.1脚本或运行时验证，也没有给出当前大盾兵Goal的调用实例。

对当前 `700010_battle.dec.lua` 的实际核对结果：文件中没有 `GetDistAtoB` 调用，只有 `GetDist(TARGET_ENE_0)`、`GetDist(TARGET_HOSTPLAYER)`等已存在调用。因此不能把 `ai(TARGET_ENE_0, TARGET_HOSTPLAYER)`直接加入当前资源并声称兼容；其参数形式、绑定环境和当前版本可执行性仍未知。即使可用，几何距离也只会是敌人与玩家的近邻条件，不会证明攻击意图或威胁排序。

### B. GetNpcThinkParamID

同一公开页面将 `GetNpcThinkParamID()` 描述为返回当前角色的NpcThinkParam ID。证据等级同样是 **REFERENCE-ONLY / SOURCE-DOCUMENTED**。

当前大盾兵反编译文本没有该调用。现有参数证据能证明四条BuddyParam分别引用 `270001001`，89号单成员候选能把一条引用改到`270001002`，但没有脚本内读取该ID并分支的证据。因此不能在共享700010 Goal中确认“仅270001002进入保护分支”。公开函数名不等于当前版本脚本可调用契约。

### C. 共享Goal条件分支与资源部署

静态上，若当前运行时同时提供上述两个函数，理论上可以在同一Goal中写出“ID匹配 + 敌人与玩家距离阈值”的分支；但本机没有两个函数的当前版本调用证据，且没有成员级行为验证。

现有89号工具链只能可靠地反编译LuaP并读写/重包已知参数资源。DSLuaDecompiler不生成游戏可执行LuaP；本轮没有获得可审查的Lua编译器/重编译流程，也没有确认当前me3能直接覆盖`700010_battle` Lua容器。因此修改反编译文本不能形成可加载实验资源。

结论：三个必要条件（当前版本GetDistAtoB、当前版本GetNpcThinkParamID、修改Lua后的可追溯重包/加载）未同时成立，未生成90号原型。81号、89号固定成果和游戏文件保持不变。

### D. 最小剩余阻碍

需要一份与Elden Ring 1.17.1匹配、可验证的AI函数调用证据（至少在实际目标Lua或可信版本绑定中出现），以及不依赖猜测的LuaP编译/重包和me3覆盖流程。即使补齐，也仍需一次隔离游戏验证，确认恰好一名成员分支生效、其余三名保持原战斗逻辑；本轮不申请或执行该实验。

补充结论：**NO_PROTOYPE / INCONCLUSIVE_INTERFACE**。

## AI资源加载验证准备（2026-10-10）

已建立一次可撤销、只加载原始AI容器的90号me3测试包；本轮未启动me3或游戏。

### A. 测试包

目录：`<ERAI_ROOT>\work\erai-ai-source-90\load-test`

内容：

- `package\regulation.bin`：复制自81号4+2已验收包，SHA256 `45BE1C51B7018860E83F20B846FF647C32A88539D46791D61AF95A0E89B212B6`。
- `package\script\700010_battle.luabnd.dcx`：复制自89号原始提取文件，未修改，SHA256 `A57684D1826E7246139262057E7834D1141E15112A4922144E97C31A02908194`，3776字节。
- `erai-90-ai-resource-load-test.me3`：单一package、`start_online=false`、`natives=[]`，package路径指向上述`package`目录。
- `resource-manifest.json`：记录完整路径、相对路径、大小与SHA256。
- `Validate-90-AI-RESOURCE.ps1`：只做文件、进程、Profile和哈希检查。
- `Launch-90-AI-RESOURCE.cmd`：复用75号已验收的me3命令行流程；只在用户双击时启动，Codex未执行。

离线预检输出为：`RESOURCE_PREPARED`，没有游戏或me3进程运行。

### B. 手动命令

用户可双击：

`<ERAI_ROOT>\work\erai-ai-source-90\load-test\Launch-90-AI-RESOURCE.cmd`

其实际me3命令等价于：

`<USER_HOME>\AppData\Local\ERAI-UserTests\me3-0.13.0\bin\me3.exe --crash-reporting=false --profile-dir "<ERAI_ROOT>\work\erai-ai-source-90\load-test\profile-runtime" launch --game eldenring --exe "<GAME_ROOT>\RING\Game\eldenring.exe" --profile "<ERAI_ROOT>\work\erai-ai-source-90\load-test\erai-90-ai-resource-load-test.me3" --online=false --disable-arxan=false --skip-steam-init=false`

### C. 日志判定

`launcher-output-90.txt`中必须先出现me3成功解析该Profile、登记唯一package并启动游戏；只有日志进一步明确出现`script/700010_battle.luabnd.dcx`（或等价的目标覆盖路径）被读取/重定向，才登记`LOAD_INTERCEPTED`。若只有package登记、没有目标资源读取证据，保持`RESOURCE_PREPARED`，不能声称已消费700010脚本。正常进入游戏只可登记加载成功，不能证明脚本函数语义或主动护卫行为。

### D. 恢复

退出游戏后删除或停用独立`load-test`目录即可恢复81号；重新使用81号原有Profile和入口。81号、89号原始文件、游戏原版、存档和全局me3配置均未修改。

本轮状态：**RESOURCE_PREPARED / LOAD_INTERCEPTED=NOT_RUN / RUNTIME_BEHAVIOR=NOT_RUN**。等待L3和用户批准手动启动。

## 重新编译AI资源加载测试准备（2026-10-10）

### A. roundtrip2核验

`roundtrip2\repacked.luabnd.dcx` 解包后确认：

- DCX类型：`DCX_KRAK`
- BND版本：`07D7R6`
- 内部文件数：2
- ID1000：`700010_battle.lua`，重新编译内容，42697字节，SHA256 `AC9BEA0AF6CB667175196207B3D51AAAC2A761B5B7C8CAD94C86AAB4DB6AAB71`
- ID1000000：`700010_battle.luagnl`，1456字节，SHA256 `FBFE4E79C28098FC5D89C7E9307D8F34478000DB130A503B174A3FDAAD9D262E`，与原始副本一致

重新反编译的函数清单与原始反编译文本一致，没有发现函数名、Goal或Act注册数量的不一致。该检查只说明结构和函数清单一致，不证明指令级语义等价。

### B. 独立测试包

目录：`<ERAI_ROOT>\work\erai-ai-source-90\recompiled-load-test`

- `package\script\700010_battle.luabnd.dcx`：SHA256 `4435E446578F32A45832C648E95F3568089B2B4B07CD3BB3C46823A99F462F2E`，6720字节
- `package\regulation.bin`：81号4+2副本，SHA256 `45BE1C51B7018860E83F20B846FF647C32A88539D46791D61AF95A0E89B212B6`
- Profile：`erai-90-recompiled-ai-load-test.me3`
- 校验脚本：`Validate-90-RECOMPILED-AI.ps1`
- 启动入口：`Launch-90-RECOMPILED-AI.cmd`
- 清单：`manifest.json`

离线预检结果：`RECOMPILED_RESOURCE_PREPARED`；Profile为单一package、`start_online=false`、`natives=[]`，无游戏或me3进程运行。原始AI加载测试包、81号、89号和游戏原版均未修改。

### C. 用户人工验收标准

用户批准后双击：

`<ERAI_ROOT>\work\erai-ai-source-90\recompiled-load-test\Launch-90-RECOMPILED-AI.cmd`

先看日志是否确认该Profile和`script/700010_battle.luabnd.dcx`被重定向读取；没有明确资源读取证据时不能登记加载成功。进入游戏后只做基本兼容性检查：四名大盾兵能否正常召唤、移动、发现敌人、接近、攻击，游戏能否正常退出。不得测试护卫逻辑，不得修改参数。

本阶段通过条件是：重新编译资源被实际加载，四名大盾兵基本战斗行为未出现明显异常，游戏正常退出。任何崩溃、召唤异常、AI不动、资源加载错误或无法确认的情况立即停止，并回到90号原始AI加载入口/81号Profile。删除或停用`recompiled-load-test`目录即可恢复，不触碰81号文件。

本阶段状态：**RECOMPILED_RESOURCE_PREPARED / LOAD_INTERCEPTED=NOT_RUN / RUNTIME_BEHAVIOR=NOT_RUN**。这不是主动预防性护卫GAME PASS。

## 技术门槛追加：LuaP 编译与700010资源重包（2026-10-10）

本节只验证资源管线，不制作护卫逻辑、不启动游戏。

### A. 原始LuaP完整头部

原始副本 `700010_battle.lua`（13798字节）和 `010000_logic.lua`（1065字节）的前32字节均为：

`1B 4C 75 61 50 01 04 08 04 06 08 09 09 08 B6 09 93 68 E7 F5 7D 41 ...`

这不仅确认了`LuaP`与Lua 5.0格式，也记录了完整头部中的版本、数值宽度、字节序和时间戳/尺寸相关字段。两者的格式头一致，但不能仅凭头部宣称游戏兼容。

### B. 现有Lua 5.0编译器

DSLuaDecompiler仓库自身包含 `LuaCompiler` 项目和 `LuaNative\lua502.dll`，无需新增工具或系统安装。使用本机官方 .NET SDK 9.0.318构建：

- 项目：`<ERAI_ROOT>\work\erai-ai-source-89\tools\DSLuaDecompiler\DSLuaDecompiler-master\LuaCompiler\LuaCompiler.csproj`
- 构建结果：成功，0 errors（仅结构体未赋值警告）
- 输出：`...\LuaCompiler\bin\Release\net9.0\LuaCompiler.dll`
- Lua 5.0编译器通过现有 `Lua50Compiler.CompileSource` 调用。

独立90号Harness编译了最小示例 `return 1+2`，成功生成117字节LuaP；生成文件头与原始LuaP头完全一致。

### C. 反编译文本重新编译

只读取89号反编译副本，输出写入 `<ERAI_ROOT>\work\erai-ai-source-90`：

- `700010_battle.dec.lua` → `700010_battle.recompiled.lua`，42697字节，SHA256 `AC9BEA0AF6CB667175196207B3D51AAAC2A761B5B7C8CAD94C86AAB4DB6AAB71`，退出码0。
- `010000_logic.dec.lua` → `010000_logic.recompiled.lua`，2617字节，SHA256 `67FF3463494E7A12DBDFB7F1655BC7437277EA859D9FEF60584D72C7620E855C`，退出码0。

两份输出均保留LuaP完整头部。重新编译证明语法和Lua 5.0编译器输入格式可处理这些反编译文本；不证明反编译文本与原始脚本语义逐指令等价。

### D. BND4/DCX KRAK往返

使用已核验的 `Andre.SoulsFormats.dll`，只在 `<ERAI_ROOT>\work\erai-ai-source-90\roundtrip2` 副本上执行：

1. 读取原始 `700010_battle.luabnd.dcx` 副本并解压为BND4 `07D7R6`，2个内部文件。
2. 仅替换内部ID1000的Lua为重新编译副本；ID1000000的 `.luagnl` 保持原字节。
3. 重包为DCX_KRAK：`roundtrip2\repacked.luabnd.dcx`，6720字节。
4. 再解包成功：DCX_KRAK、BND4 `07D7R6`、2个内部文件；ID1000路径和ID1000000路径保持原样，`.luagnl`大小1456字节不变。
5. 再解包的Lua再次被DSLuaDecompiler读取并成功反编译，证明容器结构可被现有工具链往返解析。

这建立了**可审查、可撤销的离线LuaP+BND4+DCX KRAK资源管线**。输出仍是实验副本，未放入游戏目录，未由me3加载。

### E. 门槛裁决

- A：Lua 5.0编译工具与原始LuaP格式：**BUILD/FORMAT PASS**。完整头部一致，但尚未有游戏运行验证。
- B：两个反编译文本能否重新编译：**PASS**，退出码均为0；语义等价仍未证明。
- C：700010资源能否结构有效重包：**PASS**，BND4/DCX_KRAK往返核验通过。
- D：是否具备下一步me3隔离加载验证条件：**YES / PREPARED**。资源管线已具备，实际me3消费700010 Lua仍未验证，必须单独建立隔离Profile并由用户批准后手动启动。

本节没有修改81号、89号、游戏、存档或安全设置，也没有生成护卫逻辑。当前仍为技术管线准备完成，不是智能护卫GAME PASS；下一步若获批准，只能先做一次隔离me3加载验证，再谈行为测试。

## 首代预防性护卫开发门槛（本轮定点核验）

### 本轮已接受的前置事实

根据L3本轮裁决，重新编译700010资源已被me3重定向读取，游戏正常进入，四名大盾兵可正常战斗。登记 `RECOMPILED_AI_BASIC_RUNTIME_PASS`；这是用户实测结果经L3确认，本轮没有再次运行游戏或独立重测。它没有验证新增的两个AI接口，也没有验证成员分流。

本轮只读复核两个已提取脚本及重新编译再反编译文本。81号4+2包SHA256仍为 `45BE1C51B7018860E83F20B846FF647C32A88539D46791D61AF95A0E89B212B6`；重新编译兼容性测试AI容器仍为 `4435E446578F32A45832C648E95F3568089B2B4B07CD3BB3C46823A99F462F2E`。

### 1. 首个阻塞：脚本内单成员身份

`700010_battle.dec.lua:41`实际调用 `GetExcelParam(AI_EXCEL_THINK_PARAM_TYPE__thinkAttr_doAdmirer)`，证明共享Goal能依据Think相关值分支。因此不再把“共享Goal”本身视为成员分工的必然障碍，也不要求必须创建新Goal ID。

但是两个当前版本目标脚本及重新编译再反编译文本均没有 `GetNpcThinkParamID()` 调用。现有资料只有公开参考函数描述，没有该函数对应1.17.1的注册/绑定或本机调用证据。这不是证明函数不存在，而是无法通过当前静态证据把它登记为安全可用。

参数层克隆270001001为270001002并保持所有字段一致，只产生一个不同的ID；在没有已核实的ID读取方式时，Goal无法据此可靠选择护卫分支。`GetExcelParam`虽已有代码依据，但以它作为成员标记须另改Think字段，违反本轮“克隆字段完全一致”的优先隔离条件，并可能触发原有团队分支；本轮没有擅自改用它。

结论：**UNKNOWN，成员分流门槛未通过。** 按本轮禁止向用户交付未经核实调用的条件，在此停止，不构建护卫候选。

### 2. 危险区域条件的修正

当前脚本已调用 `GetDist(TARGET_HOSTPLAYER)` 与 `GetDist(TARGET_ENE_0)`（例如345–354行、385–387行）。因此可以设计“护卫靠近玩家且当前敌人靠近护卫”的保守近邻警戒候选，不需要攻击意图预测或HP下降作为触发。

它是 **EXPERIMENTAL** 几何近邻条件，不是精确敌人与玩家距离，也不保证覆盖所有绕后敌人：只观察该AI当前的TARGET_ENE_0，可能遗漏其它威胁。不能因为缺少攻击意图就否定这种最小方案。`GetDistAtoB`仍缺当前版本调用依据，本轮不加入它。

### 3. 动作构件与职责恢复

Act16（264–270行）接近当前敌人；Act18（278–284行）向当前敌人防御；Act40（345–359行）调整与玩家距离。这些可作为未来局部分支动作构件，但没有现成“站在法师与敌人之间”的语义保证。

若成员标识以后核实，候选可以限制短时/近邻接敌，并在邻域条件不成立时重新选择靠近玩家的动作；其触发、终止当前子Goal和恢复频率仍属于新逻辑，需要代码审查和实际验收。本轮没有编写或部署该分支。

### 本轮交付与唯一后续条件

未生成护卫Lua、参数包或新Profile；未编译、启动游戏、读写游戏内存或改动既有成果。仅更新本报告。

**当前最小阻碍仅先收口到：当前1.17.1中可安全使用的脚本内成员身份读取。** 最短后续路径是L3提供/批准对明确的 `GetNpcThinkParamID` 当前版本Lua绑定或注册证据进行定点核验；若静态证据仍不可得，需要另行裁决是否允许一个仅验证该接口的隔离诊断，而不能直接把未经核实调用混入护卫原型。资源管线和几何近邻方案不再重复验收。

本轮状态：`NO_PROTOTYPE / MEMBER_ID_CALL_CONTRACT_UNCONFIRMED`。主动预防性护卫尚未实现，任务停止，等待L3。
## 成员身份诊断候选（本次L3授权追加）

### 状态

`OFFLINE_DIAGNOSTIC_CANDIDATE_ONLY`。本次没有部署或启动游戏，未宣称成员身份读取或护卫行为通过。

### 实际修改

- `700010_battle.identity-diagnostic.lua`：在 `Goal.Activate` 中以 `pcall(function() return ai() end)` 尝试读取当前AI对象ID；只有返回 `270001002` 时，将已有行动权重改为现有 `Act18`（5秒 `GOAL_COMMON_Guard`）的短暂诊断路径。其它情况继续原有权重。该动作只复用原Goal中的防御构件，没有新增攻击、特效或动画。
- ThinkParam：从 `270001001` 克隆为 `270001002`，所有行为字段逐字段相同，仅ID和名称不同。
- BuddyParam：仅 `24800000.npcThinkParamId` 从 `270001001` 改为 `270001002`；`24800001–24800003` 保持 `270001001`。

### 证据与限制

- 编译使用已验收的Lua 5.0编译器Harness，编译输出 `compiled-700010_battle.lua`，SHA256 `BAD55CC9EF997591D1B036309B219B23F0098BD2ABF5EAA7995873A5FEDBAF51`；诊断源SHA256 `2988A103854085A61BC09F6259413B64E686A761211D530FDFC580DAC13C2DE8`。
- Lua编译成功只证明语法/格式可生成LuaP，不证明 `ai()` 在当前1.17.1绑定中存在。
- `pcall` 可处理Lua层错误并回退原逻辑，但不能保证未注册函数背后的原生异常、引擎崩溃或绑定差异都被捕获；因此本候选仍需用户批准后才可测试。

### 候选文件与哈希

目录：`<ERAI_ROOT>\work\erai-ai-source-90\identity-diagnostic`

- `package\regulation.bin` SHA256 `A9F9C0EE07FA8B4F053088CD915CBDECB75C6FCC9DFA3D9A8AB0015CADF7E9DE`
- `package\script\700010_battle.luabnd.dcx` SHA256 `E0DACAD0B11D43C3DF11609F9133F3D51409D8FF3E6AE1DFA0714488CA7DDEFC`
- 原始AI输入未修改：`<ERAI_ROOT>\work\erai-ai-source-89\extracted\script\700010_battle.luabnd.dcx` SHA256 `A57684D1826E7246139262057E7834D1141E15112A4922144E97C31A02908194`
- 候选Profile：`erai-90-identity-diagnostic.me3`，包含 `start_online = false`、`natives = []`，只引用候选package。
- 预检入口：`Validate-90-Identity-Diagnostic.ps1`；人工入口：`Launch-90-Identity-Diagnostic.cmd`。入口只做离线预检并停在 `GAME_LAUNCH=MANUAL_USER_ONLY`，不会自动启动游戏。
- `candidate-manifest.json` 保存基线包、候选包、脚本与原始 `.luagnl` 哈希。

### 离线结构验收

- 基线 regulation：`45BE1C51B7018860E83F20B846FF647C32A88539D46791D61AF95A0E89B212B6`，未修改。
- NpcThinkParam 行数 `2216 → 2217`；克隆行与270001001的所有字段值无差异；新增ID为270001002。
- BuddyParam 仅24800000的Think引用变化；24800001、24800002、24800003仍引用270001001。
- 候选AI容器可重新读取为BND4 `07D7R6`，内部ID1000为诊断Lua，ID1000000 `.luagnl` 保持原SHA256 `FBFE4E79C28098FC5D89C7E9307D8F34478000DB130A503B174A3FDAAD9D262E`。
- 未修改81号、89号、已通过的90号兼容性测试包、游戏目录、存档或系统设置。

### 仅供后续人工验收的观察标准

若L3另行批准，用户应只加载该候选并召唤四只大盾兵：观察是否恰好一名成员短暂举盾/防御约5秒后恢复正常，另外三名继续原战斗。若四名行为相同、无人触发、超过一名触发、卡死、崩溃或持续覆盖战斗，应立即停止并恢复81号入口。即使恰好一名触发，也只证明身份诊断分支的实验信号，不证明主动预防性护卫。

恢复方式：关闭游戏后改用81号 `<ERAI_ROOT>\work\erai-usable-experimental-81\Launch-ERAI.cmd` 及其原选择配置；候选目录不覆盖任何81号文件。

### 本次结论

候选已完成离线构建和结构核验，但 `ai()` 仍只有公开文档依据，当前1.17.1运行时绑定未验证。因此本次不能登记 `MEMBER_ID_VERIFIED`、`GUARD_PASS` 或主动预防性保护实现；状态保持 `OFFLINE_DIAGNOSTIC_CANDIDATE / RUNTIME_NOT_TESTED`，等待L3批准人工测试。

## L3整改补充：身份调用与诊断动作终止性

前一版候选已废止，不再作为测试输入。整改后的源码为：

- 身份调用改为 `pcall(function() return f2_arg1() end)`；`ai()` 已移除。
- 匹配条件仍严格为返回值 `270001002`。
- 新增诊断专用 `Act24`，只复用已有 `GOAL_COMMON_Guard`，持续5秒。
- `Act24` 首次执行时调用已有且原脚本已使用的 `SetTimer(5, 30)`；`Goal.Activate` 仅在 `IsFinishTimer(5)` 为真时选择诊断动作。这样动作结束后至少30秒不会重复覆盖正常战斗，且不引入未经核实的状态变量或新计时器语义。
- 原有 `Act22` 保持不变；诊断动作注册为 `f2_local1[24]`，避免覆盖现有动作索引。

### 整改后构建结果

- 源码：`<ERAI_ROOT>\work\erai-ai-source-90\identity-diagnostic\700010_battle.identity-diagnostic.lua`
- 源码SHA256：`8156F4C893E2E9461847FCC45D76ACC3D206E2088A71BF93DFEE6392FB3CBEA8`
- 重新编译LuaP SHA256：`F5C3B7631494CAA11ECDC13F8D05EF184EF24CE72A36F0208E89150DAD67BDA1`
- 候选AI容器 SHA256：`D46D53BC0B1FCAF159DDC0A45E5E3BDF1A73ABBD0FBBB29191D2F7B762269DD9`
- 候选regulation SHA256：`A9F9C0EE07FA8B4F053088CD915CBDECB75C6FCC9DFA3D9A8AB0015CADF7E9DE`
- `Validate-90-Identity-Diagnostic.ps1` 离线预检：`IDENTITY_DIAGNOSTIC_PREFLIGHT_PASS`。
- 81号基线哈希、三名未选成员引用、原始 `.luagnl` 哈希均保持不变。

### 风险与状态

`f2_arg1()` 仍只是待验证的Lua绑定调用；`pcall` 只能覆盖Lua层错误，不能保证原生绑定异常不导致崩溃。诊断动作的终止性来自已存在的 `SetTimer`/`IsFinishTimer` 语义，实际成员识别和恰好一名触发仍未运行时验证。

本次状态：`OFFLINE_DIAGNOSTIC_CANDIDATE_REVISED / RUNTIME_NOT_TESTED`。暂不允许人工启动，等待L3重新审查。

## L3第二次整改：精确接口与动作权重修正

最新保存源码已完成强制静态自检：

1. 存在 `return f2_arg1:GetNpcThinkParamID()`。
2. 不存在 `return f2_arg1()` 或 `return ai()`。
3. 存在 `f2_local0[24] = 100`。
4. 存在 `f2_local1[24] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act24)`。
5. 不存在错误的 `f2_local0[22] = 100`。
6. 诊断正权重24具有对应注册函数；其它正权重注册保持原有表。
7. `pcall`失败或返回非270001002时，`f2_diagMember`为假，原战斗权重不被诊断分支覆盖。

### 最新文件哈希

- 源码：`700010_battle.identity-diagnostic.lua` — `031E3A2C064AC228933E1312F69C56897CC563067BCA579CBF17C804C5902CB9`
- 编译LuaP：`compiled-700010_battle.lua` — `CDFA00D0F73FEE9247C92F0849B8C5BA99CEEAE5AA5ECF72CDB5367F64AD0F3C`
- 候选AI容器：`C56FDFF7B7AECD1A9A719FABCEC4C336031C190D3895252BDE42733AC7B60866`
- 候选regulation：`A9F9C0EE07FA8B4F053088CD915CBDECB75C6FCC9DFA3D9A8AB0015CADF7E9DE`

### 计时器与可观察性限制

Act09、Act10和诊断Act24都使用计时器5；原脚本已证明Act09/10会调用`SetTimer(5, 30)`，Goal也已使用`IsFinishTimer(5)`。因此：

- 诊断分支可能被Act09/10预先设置的同一计时器抑制；不能声称首次执行必然发生。
- Act24设置的计时器也会与Act09/10共享，30秒是抑制窗口的上限语义，不能声称它是诊断专属冷却或一定在30秒后恢复。
- Act24和原有Act18都调用同一个`GOAL_COMMON_Guard`（5秒、9910、TARGET_ENE_0）。两者在画面上的举盾动作没有可靠可见差异；本实验最多能通过“是否仅一名成员进入该分支及后续是否恢复”获得弱信号，无法仅凭视觉把Act24与普通Act18严格区分。

因此候选虽满足代码和资源一致性要求，但诊断判别力受共享计时器及共享Guard动作限制。仍不得将其结果解释为智能护卫或稳定成员身份验证。状态保持 `OFFLINE_DIAGNOSTIC_CANDIDATE_REVISED / RUNTIME_NOT_TESTED`，暂不允许启动。

## L3最终一次可观察性改进：ApproachTarget → Guard

以已通过源码检查的 `GetNpcThinkParamID()` 版本为基线，诊断Act24现改为：

```lua
f17_arg0:SetTimer(5, 30)
f17_arg1:AddSubGoal(GOAL_COMMON_ApproachTarget, 2, TARGET_HOSTPLAYER, 4, TARGET_SELF, true, -1)
f17_arg1:AddSubGoal(GOAL_COMMON_Guard, 5, 9910, TARGET_ENE_0, true, 0)
```

这只使用700010中已存在的ApproachTarget、Guard和SetTimer形式。诊断分支仍只在 `GetNpcThinkParamID()` 返回270001002且计时器5已结束时进入；其他三名成员不改Think引用和Goal权重。

### 最新构建

- 源码SHA256：`4D4B133B562AC9A13FEFD41187DF63924C683D69DF28297D2C4488C075E2ABAB`
- 编译LuaP SHA256：`ACD02EDD511B27ECBD6BCA6694F4CFA3AD0AC0663F599E769496D3B86F9C1FEA`
- AI容器SHA256：`6FE323D7F8C8DDAECF76A36988EEF7F102919CDC5433966B72826007F5BBE7D0`
- regulation SHA256：`A9F9C0EE07FA8B4F053088CD915CBDECB75C6FCC9DFA3D9A8AB0015CADF7E9DE`
- `STATIC_SOURCE_CHECK_PASS`
- `IDENTITY_DIAGNOSTIC_PREFLIGHT_PASS`

### 判别力边界

接近玩家后再举盾比单独Guard更容易观察，但计时器5仍与Act09/Act10共享，因此诊断可能被抑制；未观察到动作只能记为`INCONCLUSIVE`，不能证明接口不可用。动作序列终止于Guard子Goal的5秒时长，且计时器会抑制连续立即重触发；不能把它解释为正式护卫或稳定回防。

候选仍未部署、未启动游戏，等待L3批准人工离线测试。

## GetExcelParam成员分流定点评估（只读）

本轮没有编译、重包或启动游戏。

### 已确认的读取属性

当前700010脚本唯一实际调用是：

```lua
local f2_local5 = f2_arg1:GetExcelParam(AI_EXCEL_THINK_PARAM_TYPE__thinkAttr_doAdmirer)
```

该值随后参与`Goal.Activate`的团队角色分支：与`GetTeamOrder(ORDER_TYPE_Role)`组合，决定Act权重。270001001当前ThinkParam关键值为：

- `logicId = 10000`
- `battleGoalID = 700010`
- `backhomeDist = 9999`
- `backhomeBattleDist = 999`
- `thinkAttr_doAdmirer = 0`
- `isBuddyAI = 1`

### 分流判断

- `thinkAttr_doAdmirer`是目前唯一有实际Lua读取证据的ThinkParam属性，但它已有团队角色语义；将其改为成员标记会改变原有AI权重，不能作为无干扰身份标签。
- `logicId`、`battleGoalID`、回靠距离和其它字段虽存在于参数表，但当前没有证据证明可通过已知`GetExcelParam`枚举安全读取，也没有当前脚本调用契约。
- 因此无法在不改变原AI语义的前提下，找到可靠的成员分流条件。

### 结论

`GetExcelParam`路线当前只能提供已被占用的团队角色属性，不能安全支持“恰好一名成员独立分支”。不制作新候选，不修改90号身份诊断包，状态为 `BLOCKED_MEMBER_SPLIT_BY_GETEXCELPARAM`。继续开发需要新的、明确的成员标记读取契约；本轮不建议继续试探字段或改写`doAdmirer`。
