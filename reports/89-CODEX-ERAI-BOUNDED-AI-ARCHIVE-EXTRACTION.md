# 89-CODEX-ERAI-BOUNDED-AI-ARCHIVE-EXTRACTION

日期：2026-10-10
当前状态：TARGET_AI_SOURCE_OBTAINED；预防性护卫候选准备：BLOCKED（缺少玩家威胁判断与可控成员职责入口）。历史阶段状态保留于下文。

## 1. 范围与安全边界

本节为早期阶段记录；后续已获授权使用现有 Andre.SoulsFormats 与自行构建的 DSLuaDecompiler，见第11–15节。全程没有启动游戏、探针、Hook、注入、游戏进程内存读写，也没有修改 <GAME_ROOT>\RING\Game、81号实验版、存档或安全设置。

## 2. 官方来源与文件校验

- Nuxe Release：https://github.com/JKAnderson/Nuxe/releases/tag/v1.2.1；发布提交页面显示提交短标识 16d94fc。下载：Nuxe.1.2.1.zip。文件大小 4,730,365；本地 SHA256：023D3C2A349B6667A7267F98EB6B1A6A2B37A0A0B820CF6DFD5CB1375A78267A。
- WitchyBND Release：https://github.com/ividyon/WitchyBND/releases/tag/3.0.1.0；发布提交页面显示提交短标识 3e03b31。下载：WitchyBND-3.0.1.0-win-x64.zip。文件大小 48,308,252；本地 SHA256：A3E6B2A0F7EAC13F5E83B6602A1149322439C0662BAA140ECDD84BE28AF50364。

官方页面没有在本次可读信息中提供独立的发布 SHA256/签名；以上哈希是本地完整性记录，不冒充官方签名。

安全解压前检查了归档条目：两份归档均未发现绝对路径、目录穿越或带驱动器冒号的条目。解压仅写入 `<ERAI_ROOT>\work\erai-ai-source-89\tools`。

## 3. 工具文件

Nuxe：
`<ERAI_ROOT>\work\erai-ai-source-89\tools\Nuxe-1.2.1\Nuxe 1.2.1\Nuxe.exe`

- 文件版本 1.2.1.0，ProductVersion `1.2.1+16d94fcd379f45721047a0c2b7b743e84b4fa08b`
- 大小 6,380,887；SHA256 `9B151FB1BC952B1F40A936548BBC4B4488A3AD5EEA8D3C818554ADA49E29C04E`
- Authenticode 状态为 NotSigned（2）；未把本地签名状态当成官方信任证明。

WitchyBND：
`<ERAI_ROOT>\work\erai-ai-source-89\tools\WitchyBND-3.0.1.0\WitchyBND.exe`

- 文件版本 3.0.1.0，ProductVersion `3.0.1.0+3e03b31249ce7786078d4432ab02a2ed1ca593c2`
- 大小 82,128,653；SHA256 `00AA5B321D5AF0179D3C9154A48D2AB3BB55772EAF624A439CC5F6AD4E21982B`
- Authenticode 状态为 NotSigned。

## 4. Advanced 能力核对

Nuxe v1.2.1 本地 Readme 明确区分 Basic 与 Advanced。官方源码 `Nuxe/Operations/UnpackOperation.cs`（v1.2.1）确认：

- 构造参数包含 `unpackDir`、`unpackFilter`、`unpackOverwrite`；
- `unpackDir` 非空时使用独立输出目录；
- `unpackFilter` 是 Regex，只把匹配的游戏路径加入输出列表；
- 仍会读取配置所列 Binder 的头并审计候选文件；不会因此修改原始 BHD/BDT；
- 只有输出目录等于 GameDir 时才执行 BackupDirs；独立输出不会触发该备份路径。

本地 Nuxe 设置文件也直接显示 `UseUnpackDir/UnpackDir` 与 `UseUnpackFilter/UnpackFilter` 键。它没有提供一条已核实的命令行参数，使本次可以在无界面的情况下安全设置这些值。

## 5. 实际运行结果

- Nuxe：尝试在独立工作目录启动。进程立即退出；无 stdout、stderr，近时段 Application 日志没有 Nuxe/.NET 错误，也没有可操作窗口返回。无法安全确认 Advanced 界面中的游戏类型、独立输出目录和 Regex 过滤器，因此没有执行解包。
- WitchyBND：在独立目录启动并保持可响应，随后停止；未将任何文件交给它处理，未发生游戏目录写入。因 Nuxe 未产生容器副本，WitchyBND 没有可解析输入。
- 没有游戏启动、资源写回或原版档案改动。

## 6. 提取与解析结果

实际提取文件：无。

目标候选容器（logicId=10000、battleGoalID=700010）：未取得。没有建立文件名/数字到这些 ID 的映射，也没有取得当前 1.17.1 可阅读 Lua/Goal 正文。没有运行 DSLuaDecompiler 或其他未授权工具。

因此不能声称发现跟随、追敌或回防实现，也不能把旧版公开脚本当作 1.17.1 证据。

## 7. 基线完整性

提取尝试前后核对：

- `<GAME_ROOT>\RING\Game\eldenring.exe` SHA256 仍为 `1A3547101327F65D0C76DA2F9190AC0AA66871EA42BAE2AECC61E11A8B597891`。
- 81 号固定包 `<ERAI_ROOT>\work\erai-usable-experimental-81\generated\greatshield-4-lone-wolf-2\package\regulation.bin` SHA256 仍为 `45BE1C51B7018860E83F20B846FF647C32A88539D46791D61AF95A0E89B212B6`。

## 8. 阻塞与下一项最小必要条件

阻塞是：Nuxe 的 Advanced 选择性解包界面在本机当前工具上下文不能安全使用，且本版本没有已核实的无界面命令行入口。继续需要用户在自己的桌面手动打开 Nuxe v1.2.1，在 Advanced 中明确选择 Elden Ring PC、独立输出目录 `<ERAI_ROOT>\work\erai-ai-source-89\extracted` 和经确认的最小 Regex 过滤器，并在执行前把界面显示的预计输出范围/文件清单交回。此步骤需要单独的用户操作；本轮不猜测过滤器、不执行全量解包。

最终分类：**TOOL_OR_DEPENDENCY_BLOCKED**。

不得由本报告推断当前版本不存在 AI 资源或不存在护卫逻辑。

## 9. L3 补充指令：定向容器解析（2026-10-10）

### 输入保护与哈希

原始 Nuxe 输出未修改；解析只使用其副本：
`<ERAI_ROOT>\work\erai-ai-source-89\analysis\inputs`

| 文件 | 大小 | SHA256 | 头部格式 |
|---|---:|---|---|
| `010000_logic.luabnd.dcx` | 976 | `7173E17C6DDB89C1A468FCD200CA287044E346D56F96F14837A10B4FF46B00E1` | `DCX 00 00 01 10 ...` |
| `700010_battle.luabnd.dcx` | 3776 | `A57684D1826E7246139262057E7834D1141E15112A4922144E97C31A02908194` | `DCX 00 00 01 10 ...` |

### WitchyBND 使用核验

WitchyBND README 规定的无上下文菜单工作流是：将文件拖到 `WitchyBND.exe`。本地 `--help` 没有输出，未据此猜测其他参数。按该已记录工作流对两个副本执行等价的文件参数调用，返回进程码 `-1073741502`，即 Windows `0xC0000135 / STATUS_DLL_NOT_FOUND`；日志没有容器解析输出，输入目录没有新增文件。

这不是容器格式或逻辑映射失败的证据，而是 WitchyBND 在当前机器上缺少运行时 DLL。README 明确提示意外问题可能需要 .NET Desktop Runtime 10.0；本任务禁止安装运行库，因此停止。`appsettings.json` 只显示默认配置，未启用文件写回到游戏目录；本次未注册上下文菜单、未调用更新器。

### 解析结论

- 未取得内部文件清单。
- 未取得可读 Lua/Goal 正文。
- 未确认 `logicId=10000` 或 `battleGoalID=700010` 的内部映射。
- 未能分析追敌、跟随、回防或事件响应代码。
- 未运行 DSLuaDecompiler 或其他反编译工具。

### 当前必要条件

需要 L3 另行批准并由用户安装/提供与 WitchyBND 3.0.1.0 兼容的官方 .NET Desktop Runtime（README 指向 10.0），随后才能在同一独立 `analysis` 副本上重试。若不批准运行库安装，本任务无法继续解析。

本补充阶段最终状态保持：**TOOL_OR_DEPENDENCY_BLOCKED**。

## 10. 已有 Andre.SoulsFormats 库替代解析：实际结果（2026-10-10）

此前“未提取”的历史状态已被用户完成的定向 Nuxe 解包取代：两个候选容器已存在，合计 4,752 字节。WitchyBND 权限排查暂停，本阶段未运行 WitchyBND。

### 实际使用环境与接口

- PowerShell 7.6.5。
- 已有库：`<GAME_ROOT>\Smithbox_2_2_6_2026_09_20_b\Andre.SoulsFormats.dll`
- Assembly/FileVersion：1.0.0.0；ProductVersion：`1.0.0+8fb6b4892cad345cde91782973ea8140c009956d`
- SHA256：`854742628B9054E94FCE9790364BE8E13396649E73BDD6C63FB592B44C9257D3`
- 反射确认：`DCX.Decompress(Memory<byte>)`、`MountedSoulsFile<BND3/BND4>.Read(Memory<byte>)`，以及 LUAGNL/LUAINFO 类型存在。接口存在不等于已成功读取目标容器。

### 输入保护

只处理 `analysis\soulsformats-inputs` 中的两份副本。原始提取文件与副本的大小、SHA256重新核对一致：

- 010000_logic.luabnd.dcx：976 B，`7173E17C6DDB89C1A468FCD200CA287044E346D56F96F14837A10B4FF46B00E1`
- 700010_battle.luabnd.dcx：3776 B，`A57684D1826E7246139262057E7834D1141E15112A4922144E97C31A02908194`

验证记录：`analysis\soulsformats-input-verification.json`。

### 读取结果与准确阻碍

两个副本均未成功解压。实际库调用进入 `DCX.DecompressDCXKRAK`，在 `Oodle.GetOodleCompressor` 抛出 `SoulsFormats.Oodle+NoOodleFoundException`，消息为找不到支持的 oo2core 版本。未进入 BND 解析，也未导出内部文件。

Smithbox 本机已存在 oo2core_6/9_win64.dll。独立 analysis 中曾复制这些已有依赖及库副本；没有安装或下载依赖。改变当前进程的 DLL 查找目录并未解决。最后只在本地 PowerShell 进程用完整路径加载原有 oo2core_9 DLL成功，但 Andre 库的 Oodle 检测仍抛相同异常。没有对检测标志进行修改，没有替换解压算法，没有注入游戏。

已有依赖 CommunityToolkit.HighPerformance、DotNext、DotNext.Unsafe、DotNext.IO 在最后一次核验从原有 Smithbox 目录加载；不修改系统搜索路径或安全设置。

### 能证明与不能证明的内容

- 已确认：两个提取副本为 DCX/KRAK压缩资源；原始输入未变。
- 内部文件名、文件ID、大小：UNAVAILABLE（压缩层尚未解开）。
- BND3/BND4实际格式：未确认，不能由 luabnd 外部名称判断。
- Lua正文/字节码：未确认，不宣称已获得源码或字节码。
- logicId=10000、battleGoalID=700010内部语义映射：未确认。
- 跟随、追敌、回防代码：未取得。
- DSLuaDecompiler：当前还不能判断是否必要；先解除当前已有库的Oodle接入阻碍，之后才能判断内部脚本是否为字节码。未下载或运行反编译器。

### 停止与下一步

当前仍为 TOOL_OR_DEPENDENCY_BLOCKED（已有资源副本已取得，解析受阻）。下一项最小必要动作是由L3裁决是否允许定点核验现有库的Oodle检测/加载契约或改由用户使用已可启动的WitchyBND解析同一副本。本轮不继续调整检测机制、不开发替代解析器、不进行权限/安全软件排查。

游戏未启动；未修改游戏、81号、存档、原始提取结果或系统权限。没有智能护卫功能PASS。

校正历史第9节错误码解释：`-1073741502` 实际对应 `0xC0000142 / STATUS_DLL_INIT_FAILED`，不是原文写的 `0xC0000135 / STATUS_DLL_NOT_FOUND`。该旧进程码本身不能证明缺失.NET运行库；当前用户已安装.NET10且WitchyBND可启动。保留历史原文并以此补充纠正，不继续旧诊断。

## 11. Oodle 最小核验及 Andre.SoulsFormats 解析结果（2026-10-10）

### Oodle 检测条件

通过反射核对 `SoulsFormats.Oodle.CanUseOodle6/8/9` 的实际 IL：每个方法使用 `.NET Environment.GetCurrentDirectory()`，拼接 `\oo2core_6_win64.dll`、`\oo2core_8_win64.dll` 或 `\oo2core_9_win64.dll`，再调用 `File.Exists`。此前失败的可证实原因是 PowerShell `Set-Location` 只改变 PowerShell provider 的位置，没有改变 .NET `Environment.CurrentDirectory`；库因此在 `<ERAI_ROOT>\oo2core_*.dll` 检查并返回 false。不是缺少新依赖的证明。

本次没有改变系统目录或安全设置。仅在当前 PowerShell 进程内将 `Environment.CurrentDirectory` 设为独立分析目录，并使用已有的 `oo2core_6_win64.dll` / `oo2core_9_win64.dll` 副本。该状态随进程结束消失。

### 容器解析

使用已有 `Andre.SoulsFormats.dll`（SHA256 `854742628B9054E94FCE9790364BE8E13396649E73BDD6C63FB592B44C9257D3`）的 `DCX.Decompress(Memory<byte>)` 和 `BND4.Read(Memory<byte>)`，成功处理两个副本。

`010000_logic.luabnd.dcx`：BND4，version `07D7R6`，3 个内部文件：

- ID 1000，`.../010000_logic/010000_logic.lua`，1065 B，SHA256 `7B31DA0A727A5FBE4C755F89F936AE81F9E63D85A8C691B69BE2A94627C94F34`
- ID 1000000，`.../010000_logic/010000_logic.luagnl`，112 B，SHA256 `FE80BFC0B4E53A53D1107BDE50B8C1901C710571034996F54378033056245BC1`
- ID 1000001，`.../010000_logic/010000_logic.luainfo`，128 B，SHA256 `C60B9BF0F8D8D80DE3E8617B3FD5BEE8028DF0A8CD90B72C0F8E855B5F9FFA28`

`700010_battle.luabnd.dcx`：BND4，version `07D7R6`，2 个内部文件：

- ID 1000，`.../700010_battle/700010_battle.lua`，13798 B，SHA256 `5CAC69E99F74D53D0A85882EFD2F7F4CD54E08B96CEB248656F15ED84BA8B297`
- ID 1000000，`.../700010_battle/700010_battle.luagnl`，1456 B，SHA256 `FBFE4E79C28098FC5D89C7E9307D8F34478000DB130A503B174A3FDAAD9D262E`

所有导出文件只写入 `<ERAI_ROOT>\work\erai-ai-source-89\analysis\decoded`；清单在 `analysis\decoded-manifest.json`。

### 映射和可读性

- `010000_logic.luainfo` 经现有库解析为 `ID=10000, Name=common10000_Logic`，并列出 `common10000_Interupt`。这为 `logicId=10000` 提供了内部资源元数据映射证据。
- `010000_logic.luagnl` 列出 `common10000_Logic` 与 `common10000_Interupt`。
- `700010_battle.luagnl` 列出 `BuddyStandardShield700010_Act05`、Act06、Act07、Act09、Act10、Act11、Act12、Act15、Act16、Act17、Act18、Act19、Act20、Act21、Act22、Act23、Act40、Act50、ActAfter_AdjustSpace、`GetWellSpace_Odds`。这些名称与 700010 资源内部目标命名一致，但不足以单独证明每个 Goal 的完整运行时语义。
- 两个 `.lua` 导出内容的头部为 `1B 4C 75 61 50`（LuaP 字节码）；不是可读 Lua 源码。没有运行 DSLuaDecompiler，也没有修改字节码。
- 因没有 `700010` 的 `.luainfo` 条目，battleGoalID 到具体 Goal 元数据仍只有容器路径和 `.luagnl` 名称证据；不能把文件名 alone 升格为全部行为契约。

### 行为结论

当前取得了 1.17.1 本机档案副本中的真实逻辑/战斗容器、内部文件 ID、逻辑 ID 元数据和 Goal 名称索引，但没有可阅读的函数正文。因此无法可靠断言追敌范围、玩家跟随、回防条件或事件请求响应；是否需要反编译工具仅能确定为“若要阅读 LuaP 正文，则需要另行批准的 DSLuaDecompiler 或等效工具”。

游戏、81号、原始 Nuxe 提取文件、存档和系统设置均未修改；没有运行游戏或 WitchyBND。

最终状态更新为：**TARGET_AI_ARCHIVES_EXTRACTED**。目标容器及元数据已取得，但尚未获得可阅读源码或完整 Goal 映射。

## 12. DSLuaDecompiler 字节码反编译核验（2026-10-10）

### 来源与支持范围

官方仓库：[https://github.com/katalash/DSLuaDecompiler](https://github.com/katalash/DSLuaDecompiler)

本次获取源码为 GitHub `master` 快照，`git ls-remote` 固定提交：`c27340ab1b898a584748dc7e43a516cc1f1684f6`。源码 ZIP 本地 SHA256：`288C3B9CA27A31D18E295FA99E05D0E5B9DA60207321FD34482F3417DBB36300`。

README 明确说明目标包括 FromSoft AI Lua，主要目标为 Lua 5.0；源码 `DSLuaDecompiler/Program.cs` 根据 `LuaFile.LuaVersion.Lua50` 选择 `Lua50Decompiler`。因此格式上与本次导出的 LuaP 头和当前 AI Lua 候选相符，但这不是当前 Elden Ring 1.17.1 运行时验证。

仓库没有官方稳定 Release，README 明确写着目前没有官方发布版本。项目目标框架为 `net9.0`，主项目依赖 `System.CommandLine` NuGet 包。

### 构建结果

本机 `dotnet --info` 显示只有 .NET Runtime 6/8/10，没有任何 .NET SDK；没有 `csc.dll` 或可用独立 C# 编译器。尝试获取官方 .NET SDK 9.0.306 便携 ZIP 时传输未完成，未使用该不完整文件，已删除；没有安装 SDK、修改 PATH、权限或安全设置。

因此 DSLuaDecompiler 未编译、未执行，两个 Lua 副本未反编译。没有伪造源码或行为结论。

### 现有脚本能确认的范围

仍可确认此前提取的元数据：`logicId=10000` 对应 `common10000_Logic`；`700010_battle` 的 `.luagnl` 列出 `BuddyStandardShield700010_Act05` 至多个 Act、`ActAfter_AdjustSpace` 与 `GetWellSpace_Odds`。但 `.lua` 是 LuaP 字节码，当前没有可读函数正文。

所以问题 A-F 当前均为 **UNKNOWN**：目标选择、追敌中断、返回玩家、移动玩家位置重读、可复用事件/Goal 控制入口，以及一人回防/其他成员作战所需的最小条件，均不能从未反编译字节码可靠推出。

### 结论与最小必要条件

本阶段状态：**TOOL_OR_DEPENDENCY_BLOCKED**（源码证据已确认，反编译执行受可信构建环境缺失阻塞）。

下一步唯一必要条件：提供一个可验证的 .NET 9 SDK/已构建的 DSLuaDecompiler 官方来源执行环境，并在 L3 明确批准后，仅对 `analysis\decoded` 的两个副本运行；如果得到源码，再分析上述函数。不能把当前容器元数据或函数名称宣布为护卫行为实现。

本轮未启动游戏、未执行 Lua 字节码、未修改游戏、81号资产、存档或系统设置。

## 13. DSLuaDecompiler 构建解除尝试（2026-10-10）

按L3批准，本次只尝试一次官方便携 SDK 路线。

- 官方来源：Microsoft .NET 9 SDK 9.0.306 Windows x64 ZIP。
- 下载文件：`tools\dotnet-sdk-9.0.306-win-x64.zip`
- SHA256：`E84351161FAEC83B2427A9320811680356F7D673E69F1BFDC5C26A14A73EFDDC`
- 部署目录：`tools\dotnet-sdk-9.0.306`，未写入系统目录、PATH 或执行策略。
- SDK 探测显示 `9.0.306`，运行时随包为 9.0.10。

便携 `dotnet.exe --info` 能列出 SDK，但初始化 CoreCLR 失败：
`Failed to load ... coreclr.dll, HRESULT: 0x8007045A`，随后 `0x80008088 Failed to create CoreCLR`。设置 `DOTNET_ROOT` 后再次执行 `--version` 和 `restore`，相同失败。未开始 NuGet restore，未构建 DSLuaDecompiler；没有继续尝试其他运行时、权限或系统设置。

因此本轮没有产生反编译输出。之前两个 Lua 字节码副本和89号提取证据保持不变。下一步最小动作是由用户提供一个能正常运行 .NET 9 SDK 的受信桌面构建环境，或提供由官方源码构建的 DSLuaDecompiler 二进制；在此之前不能分析目标 AI 函数正文。

阶段状态保持：**TOOL_OR_DEPENDENCY_BLOCKED**。

## 14. DSLuaDecompiler 构建与两个 Lua 副本反编译（2026-10-10，SDK 9.0.318）

### 构建核验

用户安装的官方 .NET SDK 已可由当前执行环境直接运行：

- `<PROGRAM_FILES>\dotnet\dotnet.exe --version`：`9.0.318`
- 固定源码提交：`c27340ab1b898a584748dc7e43a516cc1f1684f6`
- 源码 ZIP SHA256：`288C3B9CA27A31D18E295FA99E05D0E5B9DA60207321FD34482F3417DBB36300`
- 项目目标框架：`net9.0`
- 依赖还原：使用 89 号独立 `NuGet89.Config` 和独立包缓存完成，未修改系统 PATH、执行策略或全局安装。
- Release 构建：成功，0 errors（存在 8 个 nullable/unused warning）。
- 构建 DLL：`<ERAI_ROOT>\work\erai-ai-source-89\tools\DSLuaDecompiler\DSLuaDecompiler-master\DSLuaDecompiler\bin\Release\net9.0\DSLuaDecompiler.dll`
- DLL SHA256：`86B91B198BD7435E728C820496679FBC333D2E58CED6C2ED0BF0F8A84E6C2B98`

`--help` 已成功运行并确认命令格式为 `DSLuaDecompiler <file> [-o|--output]`；没有执行游戏 Lua。

### 反编译结果

只对 `analysis\decoded` 的两个副本执行，输入未被修改：

- `analysis\decompiled\010000_logic.dec.lua`，SHA256 `EE2764073991D38E604FD263CF10DC7A31FA2CD92B0FDFF0A2974B4BDAAB8377`，可阅读文本，反编译退出码 0。
- `analysis\decompiled\700010_battle.dec.lua`，SHA256 `6A11EC3EAD6DF7E40A88911F2E398E45CF8DEEB85E0BAC96DDB839B7D13DC53E`，可阅读文本，反编译退出码 0。

反编译是字节码到近似 Lua 的静态还原；局部变量名和格式不应视为原作者源码，运行时语义仍需游戏内验证。

### 逻辑脚本证据

`010000_logic.dec.lua` 的 `common10000_Logic`（文件前部）调用 `GetEventRequest()`。请求值 100 和 110 均添加 `GOAL_COMMON_ApproachTarget`，目标是 `POINT_INITIAL`；请求值 80 仅处理 `IsNpcPlayer()` 的等待动画。`common10000_Interupt` 直接返回 `false`。因此该逻辑提供固定初始点的事件接近，不提供已证实的移动玩家目标或回防状态机。

### 大盾兵 Goal 证据

`700010_battle.dec.lua` 的 `Goal.Activate`（约第 66–109 行）在未有特殊效果 10350 时以 100% 权重选择 Act19；其他分支按 `GetDist(TARGET_ENE_0)` 和队伍/特殊效果状态分配攻击、接近和其它 Act。Act05/06/07（约第 113–168 行）使用 `Approach_Act_Flex` 后以 `TARGET_ENE_0` 攻击，证明主动接敌路径。

Act40（约第 345–359 行）是当前脚本中最直接的玩家距离行为：读取 `GetDist(TARGET_HOSTPLAYER)`，距离不超过 2.5 时 `GOAL_COMMON_LeaveTarget`，2.5–5 时以 `GOAL_COMMON_ApproachTarget` 接近 `TARGET_HOSTPLAYER`，更远时同一目标以较长期限接近。该代码是“向当前 Host Player 目标靠近”的静态证据，但不能证明它会被选中、能中断所有战斗状态或由外部安全地指定给某一名成员。

`Goal.Interrupt`（约第 384–440 行）在 `INTERUPT_ActivateSpecialEffect` 下，若特殊效果 83 或 90 被触发且玩家距离不超过 5，会清除子目标，先向 `TARGET_HOSTPLAYER` 接近，再对 `TARGET_ENE_0` 执行攻击。这里存在动态玩家目标读取和响应路径，但触发条件来自特殊效果，当前静态证据没有证明 ERAI 可以安全地为指定成员设置该效果。

### 对护卫目标的判断

- 已证实（SOURCE/ARCHIVE-SUPPORTED）：当前本机提取的 1.17.1 AI 容器可还原出 `common10000_Logic` 与 `BuddyStandardShield700010`；大盾兵脚本读取玩家距离，并包含 `TARGET_HOSTPLAYER` 的 Approach/Leave 子目标；攻击 Act 使用 `TARGET_ENE_0`。
- 尚未证实（RUNTIME-UNVERIFIED）：Act40 的实际选择频率、特殊效果 83/90 的来源、事件请求如何在当前召唤成员上触发、以及该路径是否能让一名成员回防而其他成员继续作战。
- 未发现（本轮未研究范围）：成员级外部身份绑定、成员级安全命令注入、可撤销的运行时目标重定向接口。

最小技术方案只能是后续受控实验候选：在不改变 81 号基线的隔离副本中，验证是否有已存在的事件/特殊效果路径能触发 Act40 或对应 Interrupt，并同时确认成员选择性。该方案需要另行批准运行时事件/原生控制实验；本轮没有制作参数包、DLL 或事件。

### 状态与边界

本轮 DSLuaDecompiler 构建成功，两个目标 Lua 均反编译成功；游戏、存档、81 号资产、原始档案和安全设置均未修改，游戏未启动，反编译输出未执行。

最终状态更新为：**TARGET_AI_SOURCE_OBTAINED**（已取得当前本机 1.17.1 容器、可阅读反编译文本及内部 ID/名称映射；这不是智能护卫功能通过）。下一步唯一动作是由 L3 决定是否批准一次隔离、只验证事件/特殊效果触发与成员选择性的运行时实验；在该批准前不继续实现或部署护卫控制。

## 15. 主动预防性保护最小可行性核验（2026-10-10）

目标是敌人袭击玩家之前的主动警戒/拦截，不是事后回靠。本轮仅复核既有两个反编译文本、81号selection与既有87号参数核验；未重复提取、反编译或研究工具，未生成实验包。

### A. 敌人感知与目标判断

**SOURCE-SUPPORTED**：`010000_logic.dec.lua:5` 调用 `IsSearchTarget(TARGET_ENE_0)`，但返回值在本函数未参与后续条件；第17行交给 `COMMON_EasySetup3`。敌人感知、候选排序和 `TARGET_ENE_0` 的赋值过程并未在这两个目标文件中展开，不能声称已取得完整感知机制。

**SOURCE-SUPPORTED**：`700010_battle.dec.lua:39` 读取当前AI对象到 `TARGET_ENE_0` 的距离；第46–65行结合特殊效果、Think的doAdmirer和团队Role分支；第68–89行按敌距选择动作权重。它们是当前战斗目标的行动选择，不是玩家附近所有潜在威胁的排序。`TARGET_ENE_0` 不等于已确认正在攻击玩家的敌人。

### B. 玩家受击前威胁识别

**SOURCE-SUPPORTED**：Act16（264–270行）、Act19（286–296行）能先接近敌人，且这些动作正文不以玩家HP下降为必要条件。普通主动接敌可以先于玩家受击发生。

**UNKNOWN**：两个文件没有展示敌人到玩家的距离、敌人攻击目标、接近玩家的方向/速度、绕过前线的判断或多敌人威胁筛选。骨灰到敌人的距离与骨灰到玩家的距离不能唯一确定敌人是否正在接近玩家。不能据此构造有证据的预防性威胁条件。79号HP快照也不能补足袭击前信息。

### C. 提前接近与拦截行为

**SOURCE-SUPPORTED**：Act16以 `GOAL_COMMON_ApproachTarget` 接近 `TARGET_ENE_0`，Act19接近后攻击；Act18（278–284行）对 `TARGET_ENE_0` 添加 `GOAL_COMMON_Guard`。这些是已有接近/攻击/自身防御路径。

**EXPERIMENTAL**：它们可能成为未来护卫执行动作的组成部分，但没有证据表明能站到敌人与玩家之间、阻挡箭矢/法术或选择绕后威胁；不能称为可靠拦截契约。

**SOURCE-SUPPORTED，重要补充**：Act40（345–359行）读取 `GetDist(TARGET_HOSTPLAYER)`并调整与玩家的距离；它没有威胁筛选或拦截站位计算。更关键的是，当前 `Goal.Activate` 的动作注册列表（94–107行）与权重选择（42–89行）均没有Act40；本文件也没有其它Act40调用。不能把“函数定义存在”当作“当前战斗中可触发”。第14节对Act40的候选表述应受此限制。

**SOURCE-SUPPORTED**：Interrupt（384–440行）观察特殊效果83/90后清除子Goal、接近玩家、再攻击当前敌人；仅当玩家距不超过5时走该分支。**UNKNOWN**：效果的真实语义、时机与可安全触发方法。不得把编号解释为提前威胁信号，也未施加任何效果。

### D. 指定一名保护者

**SOURCE-SUPPORTED**：81号当前选择为4大盾兵+2孤狼，4+2包SHA256本轮核验仍为 `45BE1C51B7018860E83F20B846FF647C32A88539D46791D61AF95A0E89B212B6`。87号已有实际参数核验记录：Buddy `24800000–24800003`均引用Think `270001001`，逻辑10000、Goal700010。这提供不同参数成员行，但当前四名大盾兵共用相同AI配置。

**UNKNOWN**：源码中未取得Buddy行身份在Lua中的可靠读取/绑定方式，未取得稳定分配一名保护者的Role接口，也未取得可安全驱动单成员的事件/Goal命令。团队Role分支的存在不证明可指定某个Buddy成员永久承担玩家保护。单独改一行Think/Goal引用只是未来隔离设想，本轮没有经验证的独立护卫脚本或加载/恢复契约，不能直接实施。

### E. 其他成员独立战斗

**SOURCE-SUPPORTED**：Goal通过当前AI对象和其子Goal执行动作，而81号当前成员共用相同逻辑。**UNKNOWN**：能否可靠把修改限定于一个原生召唤成员，其他三名保持原AI且不因共享目标、队伍Role或公共脚本而改变。当前代码没有持续保护职责、追敌约束及职责恢复状态机；无保证其他三名继续独立接敌的证据。

### F. 到最小可测原型的必要缺口

目前只有动作构件，尚缺两项必要契约：

1. 玩家受击之前可用的威胁信息：至少能够把一个可达敌人判定为正在接近玩家的候选威胁，而非仅当前骨灰战斗目标。
2. 可靠的单成员职责入口：将一名原生大盾兵与可选择的护卫Goal绑定，并能限定其追敌范围、触发接近/拦截及恢复普通行为，不影响另外三名。

此外还需确认目标脚本的隔离覆盖、编译/重包、原生Goal参数语义及可撤销部署方式。普通跟随、Act40定义或受击后特殊效果均不能替代上述两项。

### 本轮裁决与止损

**不制作实验候选**：成员级控制和提前威胁信息均未建立；不具备用户可测的最小预防性护卫原型。本轮不申请直接运行时写入、DLL或特殊效果试验，因为这些权限本身不能补齐技术契约。

下一步唯一建议：由L3裁决是否批准一轮定点静态契约核验，必须以明确的新源码依据同时补足“玩家附近威胁目标”和“单成员护卫Goal选择/隔离”，不得重复距离调参或恢复旧扫描。若没有这样的新依据，保持81号可用基线并暂停原型制作。

所有行为结论仅为源码支持或未知，未登记预防性保护GAME PASS。81号保持原样；游戏未启动，未执行Lua、Hook、注入或内存访问；本轮产品文件修改为0，仅更新本报告。89号到此停止，等待L3。

## 16. 单成员护卫职责隔离验证（2026-10-10）

本轮仅核对81号参数链、74号既有生成器和87号当前版本证据；未启动游戏、未生成新包、未修改81号。

### A. 四名成员能否分别引用独立 ThinkParam

**SOURCE-SUPPORTED：可以在参数结构层分别引用。** 81号4+2包中，BuddyParam `24800000`、`24800001`、`24800002`、`24800003` 是四条独立行；87号已核验它们均引用 `NpcThinkParam=270001001`。74号生成器的实际写入逻辑对 BuddyParam 行按ID删除尾部成员，说明该参数表和引用字段可被独立编辑。若只修改其中一条行的 `npcThinkParamId`，其余三条的引用字节可以保持不变。

这只证明“引用字段可分流”，不证明游戏运行时会按该行把成员身份稳定绑定到玩家看到的某一名大盾兵。

### B. 独立 ThinkParam 能否可靠指向独立 AI Goal

**PARTIAL / NOT ESTABLISHED。** 87号核验的 `270001001` 是 `logicId=10000`、`battleGoalID=700010`。89号提取并反编译的唯一对应战斗容器是 `700010_battle`，其内部 Goal 名称为 `BuddyStandardShield700010_*`。因此复制出另一个 Think 行、但仍填 `battleGoalID=700010`，只能复用同一个 Goal 脚本，不能产生独立 AI 行为。

要形成真正独立分支，至少还需要一个已存在且已核实可加载的不同 battleGoal 资源/ID，或一套可确认与当前版本参数加载器匹配的新 Goal 资源。当前89号资产没有这样的第二个大盾兵 Goal；不能凭借新数字或同一脚本文件名猜测映射。`logicId` 同理：独立值必须有对应逻辑资源和版本映射，当前没有。

### C. 是否能保证只影响一名成员

**UNKNOWN / 不能保证。** 参数层面可以只改 `24800000` 的引用，但四名成员共享同一 `logicId`/`battleGoalID` 时，行为仍由同一个 AI 脚本和运行时目标系统决定。现有证据没有成员级运行时身份、成员顺序稳定性、唯一 Role 分配或可撤销的控制入口。即便加载了另一个 Think 行，也没有证据证明它只影响一个可识别的实体而不被公共队伍/目标逻辑覆盖。

### D. 是否能安全制作最小隔离包

**NO。** 当前只能安全制作“不同 Think 引用但仍指向同一 Goal”的参数变体；它不能回答单成员独立 AI 的问题，属于没有区分力的实验，因此本轮不制作。81号4+2参数包保持原样。

### E. 具体阻碍与停止结论

缺口是一个当前版本、可追溯且可加载的独立 Goal/logic 资源，以及将该分支稳定绑定到一名原生大盾兵的成员级身份/加载证据。缺少这两项时，修改一条 `npcThinkParamId` 只会得到同一 AI 的别名，不能证明成员职责隔离，也不能支持主动预防性保护。

本轮结论：**不制作实验候选，停止在参数分流层继续投入。** 只有出现上述独立 Goal 资源和成员绑定的新证据，才值得另行提交受控评估；不恢复旧扫描、不进行运行时写入、不启动游戏。

## 17. 单成员 ThinkParam 差异化离线候选（2026-10-10）

本节依据L3本轮纠正：共享 `battleGoalID=700010` 不自动证明不同 Think 行没有表现差异；因此采用已有62号实际单变量证据支持的字段进行一次隔离候选制作。仍未启动游戏。

### 选择的字段与证据

字段：`NpcThinkParam.backhomeBattleDist`。

- 81号基线行 `270001001`：`backhomeBattleDist=999`，`logicId=10000`，`battleGoalID=700010`。
- 62号已有单变量游戏记录：把该字段改为10后仍保留主动接敌，并出现部分成员回靠倾向；该证据支持它可能产生可观察差异，但不证明成员级分工。
- 89号反编译的 `700010_battle` 仍使用同一 Goal；本字段属于引擎 Think 参数回靠行为，不能由Lua函数名单独推导更多语义。

### 已生成的独立候选

工作目录：`<ERAI_ROOT>\work\erai-ai-source-89\analysis\single-member-candidate`

- 参数包：`package\regulation.bin`
- 参数包 SHA256：`5BF4C5BBB2399E11BC13382FFF46D0E90E8B80223ABB73B7B3D1CBF3081490C3`
- Profile：`erai-single-think-guard-candidate.me3`
- 清单：`candidate-manifest.json`
- 构建脚本与离线核验脚本：`build-single-think-candidate.ps1`、`validate-single-think-candidate.ps1`

输入是81号4+2包的只读副本。新Think ID `270001002` 在输入表中为空位；克隆 `270001001` 后仅把 `backhomeBattleDist` 从999改为10，保留 `logicId=10000` 和 `battleGoalID=700010`，再将唯一一条 BuddyParam `24800000` 的 `npcThinkParamId` 从270001001改为270001002。`24800001`、`24800002`、`24800003`仍引用270001001。

离线逐表核验结果：解密版本与81号相同；只有 `BuddyParam.param` 和 `NpcThinkParam.param` 两个BND条目变化；Think行数2216→2217；原始Think行仍为999，新行10/logic10000/Goal700010；四条Buddy引用为 `270001002,270001001,270001001,270001001`。其它194个BND条目字节未变。81号原包、游戏原版和存档未修改。

### 手动测试候选（未执行）

必须由用户另行批准并手动启动，使用四只大盾兵模式、同一存档、同一地点和同一敌人。只加载上述独立Profile。观察敌人仍存活且队伍分散时，是否出现**恰好一名**大盾兵更早回靠/减少追敌，同时另外三名继续保持基线接敌。视觉编号不要求固定，但同一会话中应能确认只有一名成员呈现差异；不能用参数表、传送、战斗结束回归或全队同时回靠作为通过。

通过条件：候选组保留主动接敌；一名且仅一名成员在压力期间出现可重复的回靠倾向；其余三名仍继续接敌。失败条件：零名、两名以上、全队消极、主动接敌消失，或无法把观察归因于该唯一字段。测试前后可直接删除独立 `single-member-candidate` 目录并恢复81号Profile；不覆盖81号文件。

### 当前结论

**已找到合格的低风险差异化参数并生成可撤销离线候选，但尚未获得游戏行为证据。** 这只验证“单条Buddy引用可指向不同Think行”的实现基础，不验证成员身份稳定性、主动预防性保护或智能护卫。等待L3/用户批准后才可手动实测；本轮不自动部署、不启动游戏。
