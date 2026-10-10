# 78-CODEX-ERAI-READONLY-PLAYER-PROBE-BUILD-AND-VALIDATION

## 最终状态

**BLOCKED_COMPILER**。

77号固定 GameDataMan 只读链保持不变。本轮只检查现有可信编译能力并尝试使用 PowerShell Add-Type，没有安装 SDK、没有修改执行策略、没有提权、没有启动游戏或探针。

## 1. 编译器检查

- dotnet.exe：存在，但只有 Runtime；dotnet --list-sdks 为空。
- csc.exe、csi.exe、msbuild.exe、xbuild.exe、mcs.exe：均未找到。
- PowerShell Add-Type：可编译内存中的简单类型（检查结果 ADDTYPE_PASS）。
- Add-Type -OutputType ConsoleApplication：当前环境明确返回“不支持 ConsoleApplication/WindowsApplication”。
- 使用 Add-Type -Path Program.cs -OutputAssembly ... -OutputType ConsoleApplication 编译77工具失败，因此没有可交付 EXE。

结论：现有 Add-Type 只能证明有限的代码编译能力，不能生成本任务要求的独立 Windows EXE；不把 DLL 或内存程序集冒充探针可执行文件。

## 2. 工作目录与源码

已建立独立目录：

<ERAI_ROOT>\work\erai-readonly-player-probe-78

文件：

- Program.cs（由77号源码复制，未改变固定入口）
- README.md

Program.cs SHA256：$hash

77号原件未覆盖。未生成二进制。

## 3. 固定实现与安全检查

固定链仍为：

module base + 0x3D61F98 → GameDataMan 间接指针 → GameDataMan + 0x08 → PlayerGameData

读取字段仍为：

- current_hp +0x10
- current_max_hp +0x14
- is_main_player +0x8F0

源码静态审计结果：

- 使用 OpenProcess(PROCESS_VM_READ | PROCESS_QUERY_LIMITED_INFORMATION)。
- 使用有限的 VirtualQueryEx 与 ReadProcessMemory。
- 未发现 PROCESS_VM_WRITE、PROCESS_VM_OPERATION、WriteProcessMemory、VirtualProtectEx、CreateRemoteThread、注入、Hook、游戏函数调用或全进程扫描。
- 仅接受显式 PID；不会枚举进程或自动启动游戏。
- EXE ProductVersion 与 SHA256 检查、固定读取链、字段合理性检查均在源码中保留。

## 4. 运行与验收

- 游戏启动：NO。
- 探针启动：NO。
- 实际进程读取：NO。
- 真实 HP / max HP / is_main_player：无结果。
- 用户人工生命状态核对：未进行。
- BUILD_PASS：未达到。
- RUNTIME_NOT_TESTED：是，但因编译阻塞而未生成可运行程序。

## 5. 止损

未下载或安装 .NET SDK、未修改 PATH/执行策略、未请求管理员权限、未改变游戏/参数/存档/安全设置，也未创建替代扫描器。没有尝试其它地址、WCM、ChrSet、角色枚举或扫描回退。

## 6. 下一项最小有效动作

需要 L3 批准在受控 Windows 环境安装或提供官方 .NET SDK（或提供现有可信的 C# EXE 编译器）。在此之前保持 BLOCKED_COMPILER，不进行运行时验证。