# 80-CODEX-ERAI-SUMMON-BUDDY-IDENTITY-CONTRACT-GATE

## 最终结论

**RUNTIME_ACCESS_NOT_ESTABLISHED**。

固定提交中存在清楚的 `WorldChrMan` / `SummonBuddyManager` / `SummonBuddyGroup` 结构语义，但当前没有符合本任务约束的、已验证的外部只读入口可以取得 `WorldChrMan` 实例并安全遍历当前召唤组。因此不制作、不运行新的骨灰探针。

## 1. 79号证据核对

### PID 2260

79号早期源码的精确条件是：

```csharp
if (!String.Equals(process.ProcessName, "eldenring", StringComparison.OrdinalIgnoreCase))
    return 4;
```

它只接受不带 `.exe` 的一种格式。用户报告的系统信息显示目标是 `eldenring.exe`；79号当时没有保存 C# 实际返回的 `ProcessName` 原始字符串，因此只能确认该严格判断与用户环境的进程名格式不兼容，不能伪造更细的原始日志。

随后修正版改为：

- 先取得 `process.MainModule.FileName`；
- 接受 `eldenring` 或 `eldenring.exe`；
- 仍要求文件名为 `eldenring.exe`；
- 后续仍严格检查完整路径、ProductVersion、SHA256。

### PID 15664

没有独立日志文件；但用户在本对话中提供了真实原始输出，包含：

- EXE：`<GAME_ROOT>\RING\Game\eldenring.exe`
- ProductVersion：`2.7.1.0`
- SHA256：`1A3547101327F65D0C76DA2F9190AC0AA66871EA42BAE2AECC61E11A8B597891`
- `CURRENT_HP=455`
- `CURRENT_MAX_HP=455`
- `IS_MAIN_PLAYER=1`
- `READONLY_PLAYER_DATA_SNAPSHOT_OK`

该结果是用户提供的单次记录，不是 Codex 自动运行日志。

### 79号源码改动

存在实际修改，且保留了备份：

- 修改前 `Probe-79.pre-identity-fix.bak.cs`：`AD823A4839B8772A3E1D2BBCBDBD3A2DE731DD01B839B8E00CCD1DEAF36D25CC`
- 修改后 `Probe-79.cs`：`AFA3E210E8310608FA9F36029C39D598BEC6BC518E74D26712703FE49A88F924`
- 修改前 `Run-Probe-79.pre-targetpid-fix.bak.ps1`：`F13B550EEBE1F2FA1D20799D9E5168725037C4DB7FB708CA52B6F21A118D719F`
- 修改后 `Run-Probe-79.ps1`：`2F80831871073C038BA358A90698F764327A4EB9880BF78DB7F678174CF57C52`

脚本第二次修复是把错误的 `$Pid` 改为用户参数 `$TargetPidText`。79号报告同时保留了早期 `RUNTIME_NOT_TESTED` 段落和后追加的 15664 成功记录；早期段落是历史阶段状态，不能当作最终运行结论。

## 2. 固定源码结构证据

来源：

`https://github.com/vswarte/fromsoftware-rs/commit/29fd1381ce458d5748c1fd2d188a808471f11972`

### WorldChrMan

`WorldChrMan` 使用：

```rust
#[shared::singleton("WorldChrMan")]
```

并声明：

- `main_player: Option<OwnedPtr<PlayerIns>>`
- `summon_buddy_manager: OwnedPtr<SummonBuddyManager>`

这些是源码语义证据，不是固定外部地址。

### SummonBuddyManager

结构包含：

- `chr_set: NonNull<ChrSet<ChrIns>>`
- `groups: DLMap<i32, DLList<SummonBuddyGroup>>`
- `active_summon_goods_id`
- `player_has_alive_summon`
- `warp_manager`

`groups` 的源码注释是按 character event id 映射到其拥有的 summon buddy groups。

### SummonBuddyGroup

每个成员包含：

- `chr_ins: NonNull<ChrIns>`
- `buddy_param_id: i32`
- `buddy_stone_param_id: i32`
- `warp_requested`
- `disappear_requested`
- `disable_pc_target_share`
- `follow_type`

这足以支持“若能取得合法 group，就可用 BuddyParam ID 区分大盾兵/孤狼成员”的结构性推论，但没有证明外部只读访问已经建立。

## 3. WorldChrMan 获取路径

公开源码提供两种不同性质的路径：

1. `WorldChrMan::instance()` / `FromSingleton`：依赖 DLRF 反射元数据和 `address_of::<T>()`。固定提交的 `static.rs` 明确要求主模块是 From Software 游戏且反射数据已初始化，通常还要等待游戏内部 `wait_for_system_init`。
2. `GameDataMan` 的固定 `game_data_man` RVA 间接指针：这是79号已验证过一次的窄链，但它只提供 GameDataMan，不提供 WorldChrMan。

本任务不允许调用游戏内部函数、Hook、反射扫描或新增地址搜索。固定 `rva_ww.rs` 中没有可直接用于 `WorldChrMan` 的同等固定外部全局槽。因此无法把 `WorldChrMan::instance()` 变成合规的外部只读指针入口。

结论：WorldChrMan 结构存在，但当前合规 runtime access = **未建立**。

## 4. 骨灰身份与数量

结构层面，`SummonBuddyGroup.buddy_param_id` 和 `buddy_stone_param_id` 是最直接的成员身份字段；`groups` 的键提供 event-id 分组语义。

但是要取得当前五只/两只/三只成员，仍必须：

- 取得 WorldChrMan 或 SummonBuddyManager 实例；
- 读取并解释 `DLMap` / `DLList` 容器；
- 验证当前容器生命周期、指针可读性和目标成员。

这会进入反射访问、容器遍历或未经本机验证的结构布局。当前不能确认：

- 大盾兵与孤狼在本机运行时的 `buddy_param_id` 成员集合；
- 当前召唤数量是否能只凭 groups 读取得到；
- 不同会话/遣返后的 group 生命周期变化。

## 5. 成员级行为控制

源码可见状态字段和参数关联，但没有在限定范围内发现经当前版本证明的安全 API，用于对指定成员设置目标、终止追击、跟随、返回或导航。

`warp_requested`、`disappear_requested`、`follow_type` 等字段不能被解释为安全写入接口；本任务也禁止写入。

成员级目标/跟随/返回/导航控制：**UNAVAILABLE**。

## 6. 当前版本兼容程度

- ProductVersion 2.7.1.0 → Ww2710：有固定上游 RVA 提交。
- 本机 EXE SHA256：已核对，但上游没有该 SHA256 的逐字节白名单。
- WorldChrMan/SummonBuddy 结构：SOURCE-SUPPORTED。
- WorldChrMan runtime 入口：未由本机验证。
- SummonBuddy groups 容器布局和成员生命周期：未由本机验证。
- 外部只读成员识别：未建立。

## 7. 是否批准下一次真实技术实验

不批准直接进行骨灰成员探针。当前若要继续，唯一合理动作是由 L3 另行批准一个极小的、只读的 **WorldChrMan 访问可行性审计**，先解决反射 singleton 入口是否能在不调用游戏函数、不注入、不扫描的条件下获得；若不能，应立即关闭该路线。

## 8. 安全状态

本轮：

- 未启动游戏；
- 未启动79号探针；
- 未读取游戏进程；
- 未修改游戏、参数、存档或 ERAI 源码；
- 未恢复 WCM、ChrSet、heap 或旧扫描路线。

**最终裁决：RUNTIME_ACCESS_NOT_ESTABLISHED**。