# 64A-CODEX-ENTITY-INSPECTOR-SOURCE-AUDIT

审计日期：2026-10-09（Asia/Shanghai）  
任务范围：仅离线源码与归档审计。没有运行归档内 EXE，没有连接游戏进程，没有执行第三方构建脚本，没有修改 ERAI、游戏、DLL/native、regulation.bin、me3/C 环境或安全软件。

## 结论先行

本次审计的总体分类为：**REFERENCE_ONLY**。

- 《法环黑环实体检测sp工具源代码.zip》中的 SP 观察核心具有一定参考价值：它使用 `OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ)`、`ReadProcessMemory` 和 `VirtualQueryEx`，能够做 RTTI/WCM/ChrSet/实体字段/SpEffect 的观察，并提供同一会话的 A/B 快照和 CSV 记录。但它没有当前 Elden Ring 1.17.1 的版本验证，也没有可靠的本地玩家语义闭环；默认还会走全局 WCM/ChrSet 及 heap fallback 路线，和 ERAI 已关闭的旧玩家/全局扫描路线重叠。因此它不能直接作为 64 号压力测试记录器。
- 《黑环法环实体信息检测工具源代码.rar》中的 1.8 源码虽然文件头称“只读”，但实际包含 `WriteProcessMemory`、`VirtualAllocEx(PAGE_EXECUTE_READWRITE)`、`CreateRemoteThread`、`VirtualProtectEx`、IAT `PeekMessage` 改写和游戏函数调用。`g_write_enabled`/ini 默认 0 只是 UI/配置门，不是安全边界。它不适合在 ERAI 或 64 号测试环境直接运行，分类为直接使用 **UNSUITABLE**。
- 两份源码都没有在源码中提供当前本机 Elden Ring 1.17.1 的 EXE hash、build 号校验或经过本机 1.17.1 的运行证据。作者/README 的“法环兼容”不能替代版本证据。
- 当前建议继续使用 63 号设计规定的视频和人工记录。若未来要借鉴第三方工具，只能由 L3 另行批准一个独立、硬只读、固定对象、固定预算的记录器；本报告不授权运行任一第三方程序。

## A. 归档清单、SHA256、差异与来源可信度

本轮首先检查了 `<ERAI_ROOT>_handoff-temp`、用户 Downloads 和 Desktop 中的精确文件名；这些位置没有找到两份源码包。用户消息中给出的两个明确本机附件路径存在，因此仅使用了这两个路径，没有全盘搜索：

| 资料 | 本机路径 | 大小 | SHA256 | 归档内容 |
|---|---|---:|---|---|
| SP 源码 ZIP | `<ERAI_ROOT>\法环黑环sp实时检测工具\法环黑环实体检测sp工具源代码.zip` | 238,083 B | `C5D2A431302F0722DA2F85E2C62B95FA054F0CF7C466977F35A1E5A48394FB3E` | 33 项，解压声明总大小 572,563 B |
| 实体信息源码 RAR | `<ERAI_ROOT>\法环黑环sp实时检测工具\黑环法环实体信息检测工具源代码.rar` | 409,113 B | `FE72A2F003B39F9EBD7FA513129C2DFEB9BD2C1E9CD3DC4DC89BDF90112286D9` | 20 项，解压声明总大小 1,098,463 B |

为区分“源码包”和用户同时提供的程序分发包，后两者只做了文件哈希登记，没有解压、执行或加载：

- `法环黑环实体sp检测工具.rar`：SHA256 `FE829ADF9B241EE8B3BF1CEEBEB4B41E826022813C73C29D7EBE13D7155C7BEA`。
- `黑环法环实体信息检测工具.rar`：SHA256 `C642399349459A42A0B7D488DF96301C1862B22A43B77E75CE3B6BF5F4551B84`。

安全处理方式：只列归档路径和大小；拒绝绝对路径、`..`、ADS、链接、加密条目、大小超限和路径碰撞；只提取 `.c/.h/.md/.txt/.ini/.manifest/.rc/.ps1/.bat/.sh/.yml/Makefile` 文本到 `<ERAI_ROOT>\work\entity-inspector-audit-64A`。未提取 EXE/ELF/图标为可执行对象，未运行任何归档脚本或二进制。确定性清单保存在 `<ERAI_ROOT>\work\entity-inspector-audit-64A\archive-manifest-verified.json`。

源码主体：

- SP：`...\sp_zip\source\nr_speffect_viewer.c`，184,504 B，SHA256 `528FAD94591AE1CE5361369D6E05BEA46C2DE6BE2740A1250220E75C3FBFB9E6`；manifest 版本 1.5.0.0，而源码标题/窗口文本仍出现 1.4，存在版本标记不一致。
- 实体信息：`...\entity_rar\source\nr_speffect_viewer.c`，735,443 B，SHA256 `E4BCB1409A7BC909D914FCFF62FD3009F149B8B4BDABE87F2AE32E950F4DD088`；manifest 为 1.8.0.0。

两者共享明显的早期观察核心：`WorldChrMan`/RTTI、`PlayerIns`/`EnemyIns`/`SpecialEffect`、WCM/ChrSet 解析、身份字段读取、SpEffect A/B。实体信息版是在此基础上增加 TimeAct 动画、事件 Flag、目标血量/韧性、录屏叠加和写入/远程调用功能，而不是独立验证过的另一套玩家来源。没有仓库签名、固定 release commit 或本机 1.17.1 绑定证明，来源可信度只能记为“用户提供的未签名第三方源码”。

## B. 实际内存读写、扫描和安全边界审计

### B1. SP 源码（相对安全，但不是 ERAI 可直接采用的安全实现）

主要依据（文件均为 `...\sp_zip\source\nr_speffect_viewer.c`）：

- `read_mem`/`read_range`（约 522 行起）最终使用 `ReadProcessMemory`，并检查读取字节数；`VirtualQueryEx` 用于确认可读区域。
- `attach_game`/`OpenProcess`（约 611、659 行）申请 `PROCESS_QUERY_INFORMATION | PROCESS_VM_READ`。在主体源码中未发现 `WriteProcessMemory`、`VirtualProtectEx`、远程线程创建或进程内 hook 的调用。
- `list_regions`（约 876 行）遍历用户地址空间的 committed private/mapped 区域并合并相邻区域；`find_wcm_ref`（约 936 行）在可写模块中寻找 RTTI/WCM 指针。
- `heap_scan`（约 973 行）以最多 64 MiB 读块扫描区域；`gather_heap_players`（约 1590 行）默认每 30 秒运行，配置中 `HeapFallback=1`。默认读取窗口 `WCM_READ_SIZE=0x60000`，实体/集合上限和 256 MiB 累计结构上限存在，但不是“本会话总读取量/总时间”硬上限。
- `worker_main`（约 2213 行）以循环、重试和 `stopRequested` 结束；存在 3 秒/2 秒重试和布局失败暂停，但没有 64 号所需的固定 120 秒/字节预算封装。
- 本地文件写入是 CSV/日志/记录目录（约 2485、2502、2610 行）和 Explorer 打开记录目录；这是工具自己的文件行为，不是游戏内存写入。

安全判断：SP 版本可被描述为“主要只读的观察器”，但不能把 README 的“只读”直接升级为 ERAI 安全组件。它会自动发现 WCM、ChrSet 和 heap，路径宽、默认 fallback 开启、读取范围和停止条件不符合 64 号固定有界要求；未验证的布局常量也会被运行时启发式接受。

### B2. 实体信息版（不可作为只读记录器直接运行）

主要依据（文件为 `...\entity_rar\source\nr_speffect_viewer.c`）：

- `write_handle`（6373-6381 行）用 `OpenProcess(PROCESS_VM_OPERATION | PROCESS_VM_WRITE | PROCESS_VM_READ | PROCESS_CREATE_THREAD | PROCESS_QUERY_INFORMATION | SYNCHRONIZE)`。
- `write_mem`（6384-6389 行）直接调用 `WriteProcessMemory`。
- `remote_call_ex`（6394 行起，6429-6437 行）使用 `VirtualAllocEx(... PAGE_EXECUTE_READWRITE)`、`WriteProcessMemory`、`CreateRemoteThread`，并等待线程；超时时为避免线程仍在运行，远程内存可能保留。
- `mt_install`（7586 行起）向游戏导入表安装 `PeekMessageW/A` 路径；7617、7626 行写远程内存，7622、7627 行调用 `VirtualProtectEx` 修改并恢复页面保护。
- `write_do`（8573-8580 行）在 `g_write_enabled` 为真时分派 Flag、SpEffect 添加/删除、动画、冻结/调试等写操作；配置默认值 0（约 13805 行），但 UI 快捷键和设置可以改变它。默认关闭不是底层拒绝策略。
- 代码还包括参数重定向、强制动画、冻结/无更新、游戏函数调用和远程 stub；README 的 1.7.4/1.7.5 说明明确描述了这些功能。

该版本正常的 CSV/日志/录屏写文件本身不是问题，问题在于它同时包含可达的游戏内存写、远程线程、页面保护和主线程 IAT 改写。即使测试者不点击写入页，也无法从源码审计上把它当作硬隔离的只读工具。此结论不是恶意软件判定，而是“不满足 ERAI 只读实验边界”的工程判定。

## C. 玩家、骨灰、敌人的识别能力

| 能力 | 源码依据 | 实际来源/校验 | 可信度与缺口 |
|---|---|---|---|
| `PlayerIns` 类型候选 | 两份主体的 `RTTI_PLAYER`、`find_vftables`、`analyze_wcm` | EXE 中 RTTI/vtable 字符串和 WCM/ChrSet 表结构 | 能说明对象符合某个 `PlayerIns` RTTI 候选；不能说明是当前本地受控玩家。没有 input/owner/host 语义，也没有 1.17.1 验证。 |
| 敌人/NPC 类型候选 | `RTTI_ENEMY`、`fill_identity`/`read_identity` | vtable、实体 ID、角色编号、NPC 参数字段 | 可列候选对象；“EnemyIns”或字段存在不等于当前敌方目标或正在攻击玩家。 |
| 骨灰候选 | WCM/ChrSet 集合、实体 ID、NPC 参数 ID（默认偏移约 `0x60`，另有 `0x64` 等布局候选） | 读取对象字段，`kind=3 other` 等粗分类 | 没有独立的“Spirit Ash”身份证明，也没有证明 `npcParamId` 与当前 1.17.1 骨灰对象一一对应；召唤物、NPC 和其他角色可能共用“other”。 |
| 句柄/角色编号/实体 ID | `read_identity`、实体表和筛选 UI | 直接读对象附近固定/学习偏移 | 可用于记录筛选键；未知偏移可能来自历史版本/启发式；没有当前 EXE hash 绑定。 |
| “当前本地玩家” | `choose_layout` 选择 direct/ChrSet/update=0，SP 中 `gather_heap_players` 还明确记录 local=-1/无法区分 heap copy | 集合交集和 update 标志 | 这是结构候选/启发式，不是可靠 local-player 身份。该工具不能重开 ERAI 方案 1 的 CLOSED 路线。 |

特别注意：`id==1` 并不是这两份源码的独立可信身份判据；如果使用实体编号/参数编号，也只能作为筛选字段，不得升格为本地玩家或敌方目标语义。

## D. 动作、SpEffect、子弹、存活和 A/B 能力

### 已有且有直接源码证据的观察

1. **SpEffect**：SP 版本在角色对象关联的 SpecialEffect 管理对象上读取当前效果 ID，并支持“最近一分钟”和同一会话 A/B 快照；实体信息版保留并扩展该功能。源码中的 `DEFAULT_CHR_SPEFFECT_OFFSET=0x178`、owner 候选偏移列表和 `stable_walk` 只是运行时布局探测，不是当前 1.17.1 已验偏移。
2. **动作/动画**：仅实体信息版增加 TimeAct/动画模块探测、动作时间线和采样（约 2126、2272、3660、3794 行）。这能把对象的动画 ID/时间变化与录像对齐，但不是攻击命中或保护行为语义。
3. **Flag**：实体信息版提供 Flag 查询、变化和 A/B（主体约 300 行起、`PAGE_FLAG_AB`），它可记录状态变化，但没有把 Flag 解释成“玩家受袭”或“骨灰保护”。
4. **目标血量/韧性**：实体信息版的 target 模块读取 HP/韧性和屏幕叠加；这是目标状态观察，不是攻击者-受害者关系证明，也不是玩家安全指标。
5. **A/B 和导出**：两份源码都提供同一会话 A/B 快照、CSV/日志导出；实体版还可录屏/写视频文件。它们适合辅助时间线记录，但不提供跨两次游戏启动的稳定实体身份重识别协议。

### 没有足够证据的能力

- **位置/距离**：主体源码搜索未发现稳定的角色世界坐标读取、距离计算或位置字段语义闭环；UI 的录屏叠加位置不等于游戏实体位置。
- **子弹/发射者/目标**：没有发现可审计的 bullet/projectile 发射者和目标关系读取路径；不能用来证明“谁攻击了玩家”。
- **攻击语义**：动画 ID、SpEffect 或 HP 改变都不能单独证明攻击对象、命中原因或保护动作。
- **存活**：`process_alive` 只判断进程是否仍存在；实体“存活”没有独立可靠的当前版本状态证明。对象读失败也可能是布局、生命周期或扫描失配。
- **玩家受袭**：没有经过验证的伤害事件/攻击者-目标事件链，因此不能区分“骨灰回到附近”与“骨灰因玩家受到威胁而提供保护”。

## E. Elden Ring 1.17.1 兼容性证据

本次源码与归档中没有发现当前 `eldenring.exe` SHA256、PE build 号或 `11711000` 参数版本检查；manifest 的 `supportedOS` 只是 Windows 支持声明。两份主体都采用 RTTI 字符串、模块名、固定/候选偏移和运行时启发式，不能由此得到 1.17.1 兼容结论。

因此：**CURRENT ER 1.17.1 COMPATIBILITY = UNVERIFIED**。作者对“法环/黑夜君临”的描述只能作为语义提示。把这些偏移直接用于 ERAI 运行时会重新引入已经关闭的旧路线风险。

## F. 对 ERAI 玩家保护系统的实际价值

### 能提供的有限价值

- 作为源码参考：学习如何把 RTTI/vtable、实体筛选、SpEffect/动画/Flag 和视频/CSV 时间线放在一个观察界面中。
- 在未来获得 L3 明确授权并完成当前 1.17.1 结构验证后，可能用于**原始事件记录**：对象候选、SpEffect 变化、动画 ID、HP/韧性变化和时间戳。
- 对 64 号实验，理论上可把“骨灰回靠、动画变化、效果变化、玩家录像”做时间对齐；但该价值不等于已能判断保护成功。

### 不能提供的结论

该工具不能单独证明：

- 某个对象就是当前本地玩家；
- 某个对象就是目标敌人或五只大盾兵中的某一只；
- 骨灰保持附近是因为保护玩家；
- 玩家受到威胁时骨灰拦截、分担或创造输出窗口；
- AI 版本相对 CONTROL 的保护效果改善；
- 任何字段与 1.17.1 当前运行时语义完全一致。

所以它不能把 62/63 中“回靠倾向”升级成“玩家保护”。

## G. 能否安全辅助 64 号压力测试

**直接运行：NO。**

- 实体信息 RAR：不安全，存在可达写内存/远程线程/IAT hook，不能进 64 号环境。
- SP ZIP：源码主体更接近只读，但默认 WCM/ChrSet/heap 自动发现范围过大、停止预算不符合 64 号设计，玩家身份未闭环，1.17.1 未验证；不能未经 L3 重做安全裁决后直接运行。

64 号应继续沿用原设计的两个参数包（`AI_SUMMON_BASELINE` 999 与 `AI_RETURN_GUARD_VARIANT` 10）、同场景控制变量、录像和人工记录。第三方源码若要参与，至少需要另行批准：禁用所有写功能、移除/硬拒绝写句柄和远程调用、固定对象来源、固定读取窗口/总时长/总字节数，并在 1.17.1 上先做离线/合成回归和一次性安全检查。此次任务没有执行这些修改，也没有授权运行。

## H. 最小集成方案，或不集成理由

### 当前决定：不集成、不运行

保留两份源码作为 `REFERENCE_ONLY`：不复制到 ERAI plugin，不加入 me3/C 环境，不构建、不部署。理由是身份语义和版本证据不足，且实体版有硬写入风险。

### 仅供未来 L3 评审的最小概念方案（本轮未实现）

如果 L3 将来决定做辅助记录器，范围应限定为：

1. 使用经 1.17.1 重新验证的、明确批准的实体 provider；禁止 WCM/heap 自动全局扫描和 `id==1` 晋级。
2. 只记录已批准的少量对象（玩家候选、1～5 个骨灰候选、最多 1～3 个测试敌人），每对象固定小窗口；采样频率和总读取量预先写死，超预算立即停止。
3. 输出 source、candidate base、字段 offset、原始值、时间戳和可信度；不命名未知字段为 X/Y/Z，不写“保护成功”。
4. 运行前必须通过静态检查，确保不存在 `WriteProcessMemory`、`VirtualProtectEx`、`CreateRemoteThread`、游戏函数调用和 hook；任何失败都回到人工录像。
5. A/B 只能做同一会话内原始证据对齐；两次重启间的实体重识别必须有额外证据，否则保持 `INCONCLUSIVE`。

这个概念方案不是本轮的实现授权，也不能替代 63 号视频/人工验收。

## I. 最终分类

**REFERENCE_ONLY**（总体）。

细分：

- SP 源码：`REFERENCE_ONLY`，未来最多作为设计参考，未达到 `SAFE_CANDIDATE_FOR_LATER_VALIDATION`。
- 实体信息 RAR 源码：对 ERAI 64 号直接运行 `UNSUITABLE`，因为含真实写入、远程线程和页面保护修改路径。
- 两者都不是 `SAFE_CANDIDATE_FOR_LATER_VALIDATION`；不存在本轮可批准的运行时新玩家来源。

## J. 下一步唯一建议与所需 L3 授权

**唯一建议动作：保持 64 号现有视频/人工记录方案，不集成、不运行这两份第三方工具；若仍需要机器辅助记录，先由 L3 单独批准一个“1.17.1 版本验证 + 硬只读 + 固定对象/预算”的新审计任务。**

在该授权前，不得启动第三方 EXE、不得连接游戏、不得把本报告中的候选偏移或 WCM/ChrSet/heap 路线重新启用。原玩家来源方案 1/2、6.2′、WCM、ChrSet、ChrArray、HUD、输入控制器路线继续保持 CLOSED / STOP。

本轮没有修改 ERAI 源码、Git 仓库、游戏文件、部署目录、DLL/native、regulation.bin、me3/C 环境或安全设置；没有启动游戏或第三方程序。
