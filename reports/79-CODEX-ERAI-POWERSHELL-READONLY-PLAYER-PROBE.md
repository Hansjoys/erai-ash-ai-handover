# 79-CODEX-ERAI-POWERSHELL-READONLY-PLAYER-PROBE

## 最终状态

**READONLY_PLAYER_DATA_CANDIDATE_VERIFIED**。

阶段A已完成：PowerShell 7 的 `Add-Type` 成功编译完整探针类型，参数拒绝自检通过。阶段B未执行：没有启动游戏、没有打开游戏进程、没有进行真实快照。

## 1. PowerShell环境

- PowerShell：`7.6.5`，Core，Windows 10.0.19045。
- 使用现有可信 PowerShell 7。
- 未安装 SDK、编译器、依赖；未修改 PATH、执行策略、权限或安全软件。
- 这是 PowerShell 承载的内存程序集，不是独立 EXE。

## 2. 实际文件与哈希

工作目录：

`<ERAI_ROOT>\work\erai-readonly-player-probe-79`

- `Probe-79.cs`
  - SHA256：`AD823A4839B8772A3E1D2BBCBDBD3A2DE731DD01B839B8E00CCD1DEAF36D25CC`
- `Run-Probe-79.ps1`
  - SHA256：`F13B550EEBE1F2FA1D20799D9E5168725037C4DB7FB708CA52B6F21A118D719F`
- `README.md`
  - SHA256：`364E8CC173062384DDB657C595653620AF2130C4B6BD6A90EE4D300721C543BF`

77/78目录未覆盖。

## 3. 固定实现

保持77号固定来源和链条：

`module base + 0x3D61F98 → GameDataMan 间接指针 → GameDataMan + 0x08 → PlayerGameData`

读取：

- `current_hp +0x10`
- `current_max_hp +0x14`
- `is_main_player +0x8F0`

没有加入 WCM、ChrSet、g_others、id==1、堆扫描或其它地址搜索。

## 4. 编译与离线自检

执行：

`Add-Type -TypeDefinition <Probe-79.cs> -Language CSharp`

结果：`ADDTYPE_FULL_PASS`。

参数拒绝测试：

`[EraiReadonlyPlayerProbe79]::Run('')`

结果：

- 输出：`STOP: explicit Elden Ring PID is required`
- 返回码：`2`
- 未打开任何游戏进程。

入口：

`pwsh -NoLogo -NoProfile -File <ERAI_ROOT>\work\erai-readonly-player-probe-79\Run-Probe-79.ps1 -TargetPidText <用户明确提供的Elden Ring PID>`

## 5. 只读权限和安全审查

源码只声明并使用：

- `OpenProcess(PROCESS_VM_READ | PROCESS_QUERY_LIMITED_INFORMATION)`
- `VirtualQueryEx`
- `ReadProcessMemory`

静态搜索未发现：

- `PROCESS_VM_WRITE`
- `PROCESS_VM_OPERATION`
- `WriteProcessMemory`
- `VirtualProtectEx`
- `CreateRemoteThread`
- DLL 注入、Hook、调试附加
- 全进程扫描、自动 PID 搜索或自动重试

程序只接受显式 PID，验证进程名、EXE 路径、ProductVersion `2.7.1.0` 和目标 SHA256，然后进行一次固定链快照。读取失败立即停止。

## 6. 实际游戏运行状态

- 游戏是否启动：NO。
- 探针是否对游戏运行：NO。
- `current_hp`：未读取。
- `current_max_hp`：未读取。
- `is_main_player`：未读取。
- 人工生命状态核对：未进行。

因此不能报告 `READONLY_PLAYER_DATA_CANDIDATE_VERIFIED`。

## 7. 下一步唯一建议

由用户在已批准的离线 C/me3 环境中手动启动游戏，取得明确的 Elden Ring PID，再由用户手动运行上述 PowerShell 入口一次。Codex 不自动启动、不自动运行、不重试。若该次读取失败，保持 `RUNTIME_INCONCLUSIVE`，不寻找其它地址。
## 8. 用户单次真实快照结果

用户在真实 Windows 桌面手动执行，PID：`15664`。

输出：

- EXE：`<GAME_ROOT>\RING\Game\eldenring.exe`
- ProductVersion：`2.7.1.0`
- SHA256：`1A3547101327F65D0C76DA2F9190AC0AA66871EA42BAE2AECC61E11A8B597891`
- `CURRENT_HP=455`
- `CURRENT_MAX_HP=455`
- `IS_MAIN_PLAYER=1`
- `READONLY_PLAYER_DATA_SNAPSHOT_OK`

人工提供的游戏状态为生命值 `455 / 455`，与快照一致。该次只执行一次固定只读链，没有启动第二次探测。

本结果最多证明：当前 Windows/离线环境中，GameDataMan → main_player_game_data 链取得了一次与人工生命状态一致的只读快照。仍未验证 WorldChrMan、SummonBuddyManager、骨灰成员、实时威胁或智能护卫能力。