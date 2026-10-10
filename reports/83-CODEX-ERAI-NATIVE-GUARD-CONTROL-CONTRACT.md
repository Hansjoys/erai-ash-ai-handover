# 83-CODEX-ERAI-NATIVE-GUARD-CONTROL-CONTRACT

## 最终结论

**NO_VERIFIED_CONTROL_CONTRACT**。

本轮只检查两条已有证据路线，没有启动游戏、构建/注入 DLL、调用 Hook/游戏函数或写入内存。

## 路线1：fromsoftware-rs 结构与成员字段

来源：

`fromsoftware-rs` 提交 `29fd1381ce458d5748c1fd2d188a808471f11972`，Elden Ring WW `2.7.1.0 → Ww2710`。

关键证据：

- `crates/eldenring/src/cs/world_chr_man.rs:15`：`WorldChrMan` 使用 `#[shared::singleton("WorldChrMan")]`。
- `world_chr_man.rs:59`：`main_player`。
- `world_chr_man.rs:70`：`summon_buddy_manager`。
- `world_chr_man.rs:461`：`SummonBuddyManager`。
- `world_chr_man.rs:485`：`groups: DLMap<i32, DLList<SummonBuddyGroup>>`。
- `world_chr_man.rs:568-598`：`SummonBuddyGroup.chr_ins`、`buddy_param_id`、`buddy_stone_param_id`、`warp_requested`、`disappear_requested`、`disable_pc_target_share`、`follow_type`。

### A：指定成员识别

结构语义层面：**SOURCE-SUPPORTED**。

如果已经取得合法 `groups`，`buddy_param_id` 可用于区分大盾兵/孤狼，`chr_ins` 可关联成员对象，groups 键具有 character event id 语义。

但当前访问入口仍不可用：

- `WorldChrMan` 实例来自 shared singleton/reflection 机制；
- `static.rs` 要求 DLRF 反射数据已初始化，通常依赖游戏内部初始化过程；
- 当前固定 Ww2710 RVA 表没有已验证的外部 `WorldChrMan` 全局槽；
- `groups` 的 `DLMap/DLList` 运行时布局、生命周期和成员指针尚未在本机验证。

因此 A 的完整答案是：**结构有依据，可靠运行时成员识别入口未建立**。

### B：成员返回/跟随/停止追敌控制

**UNAVAILABLE**。

在限定源码中只看到状态/参数字段，没有看到经当前版本验证的成员级控制函数或安全命令契约。特别是：

- `warp_requested` 不是已验证的外部写接口；
- `follow_type` 是字段，不是已验证的运行时任务切换 API；
- `disable_pc_target_share` 只能说明参数/状态语义，不能指定某成员回防；
- `chr_ins` 中的公开标志和 setter 不能推导目标选择、导航或终止追击控制。

把字段写入或调用内部函数都需要未授权的 native 运行时能力，当前不能执行。

## 路线2：NpcThinkParam / logicId / battleGoalID 原生脚本路线

已有参数证据：

- 目标 Think 行 `logicId=10000`、`battleGoalID=700010`；
- 五条大盾兵 Buddy 关联新 Think 行已在50/62资产中核验；
- 67号审计确认这些数字映射到实际脚本/Goal 正文、调用者、召唤者上下文和成员控制接口的证据不存在。

因此：

- 参数选择器含义：**VERIFIED（参数字节）**；
- 当前1.17.1脚本正文、入口参数、玩家上下文、威胁状态：**UNAVAILABLE**；
- 通过修改同类 Think 字段获得指定成员回防：**HYPOTHESIS**，没有新的控制契约；
- 通过脚本字段直接控制某一成员：**UNAVAILABLE**。

这条路线可以解释已有“主动接敌/有限回靠倾向”，但不能提供 A+B 所需的成员级命令。

## 当前版本适用程度

- Ww2710 RVA 映射：有固定提交证据。
- 结构定义：SOURCE-SUPPORTED。
- 本机 `WorldChrMan` 运行时入口：未验证。
- 当前召唤成员识别：未验证。
- 指定成员返回/跟随/停止追敌 API：未找到。
- 影响范围隔离：无法证明；任何内部控制调用可能影响其他角色或全局 AI。

## 后续实验所需新增权限

只有在 L3 另行批准后，才可能进入最小实验。至少需要：

1. 允许加载一个独立、可卸载的 native 模块；
2. 固定当前1.17.1的成员身份入口和控制函数来源；
3. 明确是否允许调用游戏内部函数或安装受控 Hook；
4. 明确只作用于指定 BuddyParam 成员的边界、日志和回滚；
5. 允许一次性离线游戏验证，失败立即恢复81号 Profile/参数包。

当前没有足够证据选择具体函数地址，不能编写碰运气的实验 DLL。

## 81号隔离与恢复

81号实验版保持不变。未来实验必须放入独立目录和独立 Profile，不覆盖81号包、原版 regulation、存档或启动器；失败时停止新入口，直接回到81号 `Launch-ERAI.cmd`。

## 是否值得消耗下一轮额度

当前不值得直接进入运行时实验。只有 L3 先批准上述 native 权限和具体控制接口证据补充，才值得下一轮；否则应保持81号非护卫实验版。

**最终裁决：NO_VERIFIED_CONTROL_CONTRACT**。