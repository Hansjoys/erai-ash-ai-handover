# 77-CODEX-ERAI-GAMEDATAMAN-READONLY-PLAYER-PROBE

## 结论

**PREPARED / NOT_RUN**。

固定源码足以建立一个有限的只读指针链设计，并已制作独立工具源码；本轮未启动游戏、未打开游戏进程、未执行快照。由于本机只有 .NET Runtime、没有 .NET SDK，工具尚未编译。因此不能报告 `READONLY_PLAYER_DATA_CANDIDATE_VERIFIED`。

## 1. 固定源码与版本证据

来源提交：

- `https://github.com/vswarte/fromsoftware-rs/commit/29fd1381ce458d5748c1fd2d188a808471f11972`
- 提交消息：`[ER] Update RVAs for 1.17.1`
- `rva.rs` 将英文 ProductVersion `2.7.1.0` 映射为 `Ww2710`。
- `rva_ww.rs` 中 `game_data_man = 0x3d61f98`。

本机目标：

- `<GAME_ROOT>\RING\Game\eldenring.exe`
- ProductVersion/FileVersion：`2.7.1.0`
- SHA256：`1A3547101327F65D0C76DA2F9190AC0AA66871EA42BAE2AECC61E11A8B597891`

版本与 SHA256 已离线核对一致；上游并未提供该 SHA256 的逐字节白名单，仍不能替代运行时验证。

## 2. GameDataMan 指针链

固定源码文件：

- `crates/eldenring/src/cs/game_data_man.rs`
- `crates/eldenring/src/cs/player_game_data.rs`
- `crates/eldenring/src/rva/rva_ww.rs`
- `crates/shared/src/static.rs`

链条语义：

1. 模块基址 `+ 0x3D61F98` 是 `game_data_man` RVA。
2. `GameDataMan::instance_ptr()` 调用 `load_static_indirect`。
3. `load_static_indirect` 将该地址解释为 `Option<NonNull<GameDataMan>>`，即读取一次间接指针；不是把 RVA 本身当对象。
4. `GameDataMan.main_player_game_data` 是结构起始处后的第二个字段，偏移为 `+0x08`，再读取一次玩家数据指针。
5. `PlayerGameData` 源码字段顺序给出：`current_hp` `+0x10`、`current_max_hp` `+0x14`；`is_main_player` 位于 `unk8e8` 后，按 `repr(C)` 顺序为 `+0x8F0`。

上述偏移来自固定提交的 `repr(C)` 字段布局推导，尚未由本机进程实测确认。

## 3. 已制作的独立工具

目录：

`<ERAI_ROOT>\work\erai-readonly-player-probe-77`

文件：

- `Program.cs`
- `erai-readonly-player-probe-77.csproj`
- `README.md`
- 固定提交的四份源码证据文本

工具要求用户显式提供 Elden Ring PID；不会枚举进程或自行启动游戏。其流程为：

- 检查进程名必须是 `eldenring`；
- 检查目标 EXE 路径、ProductVersion、SHA256；
- 以 `PROCESS_VM_READ | PROCESS_QUERY_LIMITED_INFORMATION` 打开句柄；
- 仅调用 `ReadProcessMemory` 和 `VirtualQueryEx`；
- 读取固定链上的两个指针及三个候选字段；
- 只做一次快照和合理性检查；
- 退出并关闭句柄。

未使用 `PROCESS_VM_WRITE`、`PROCESS_VM_OPERATION`、调试权限、注入、Hook、远程线程、游戏函数、堆扫描、角色枚举或写内存调用。

## 4. 构建与运行状态

- 编译：**NOT RUN / BLOCKED**。
- 原因：本机 `dotnet.exe` 仅有 Runtime，`dotnet build` 报告没有安装 .NET SDK。
- 运行游戏：**NO**。
- 运行探针：**NO**。
- 实际读取结果：**无**。
- 人工生命值核对：**未进行**。

## 5. 安全审查

工具源码中没有游戏内存写入路径，也没有修改游戏、参数、存档或系统设置的逻辑。由于没有编译和运行，本轮不能证明 Windows API 调用在当前桌面环境下实际成功，也不能证明固定结构偏移与当前 EXE 运行时完全一致。

## 6. PASS 判据核对

以下均未完成，因此不满足 PASS：

- 目标进程快照成功；
- `main_player_game_data` 非空且可读；
- HP 范围和关系检查；
- `is_main_player` 实际为本地玩家语义；
- 人工生命状态核对；
- 工具正常退出并实测无写入。

最终状态：**INCONCLUSIVE（实现已准备，实测未运行）**。

## 7. 与骨灰护卫目标的差距

本工具最多只能验证一个玩家游戏数据来源候选。它不读取 `SummonBuddyManager.groups`，不识别骨灰成员，不读取 `last_hit_by`，不识别实时威胁，不提供目标/返回/导航控制，也不能实现智能护卫。

## 8. 唯一下一步建议

若 L3 继续推进，先在具备 .NET SDK 的受控 Windows 环境编译该独立工具；随后由用户手动启动已确认离线的 Elden Ring，并只运行一次显式 PID 快照。若编译环境或权限需要提权、修改安全策略、安装驱动或关闭安全软件，应停止，不绕过。