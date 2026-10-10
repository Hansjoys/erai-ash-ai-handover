# 86-CODEX-ERAI-EMEVD-LUA-GUARD-COMMAND-BRIDGE

范围：只读公开文档与源码；未启动游戏、未加载 DLL、未修改81号或游戏文件。

## 结论

**PARTIAL_SCRIPT_BRIDGE**

发现了事件命令到 Lua 事件请求的部分桥接，也发现了事件点/AI Goal 的脚本语义，但没有找到一组可固定到当前 1.17.1、能让指定实体返回移动中玩家附近并恢复接敌的完整 EMEVD→Lua→Goal 实例。

## 检查的两组案例

### 组1：Elden Ring EMEDF 与通用 Lua 事件请求

Elden Ring EMEDF 在 2004 指令中列出：

- `RequestCharacterAICommand` 2004[17]：`entityId, commandId, slotNumber`；文档列出其被 `common`、`common_func` 及多个地图事件使用。
- `SetEventPoint` 2004[18]：`entityId, relativeEntityId, reactionDistance`；文档列出其被 `common_func` 和多个地图事件使用。
- `ClearCharactersAITarget` 2004[16]：按实体清除 AI 目标。
- `RequestCharacterAIReplan` 2004[20]：按实体请求重新规划。

这些条目证明命令签名和当前 Elden Ring 事件表中的使用位置，但页面没有给出命令值对应的回防语义，也没有给出“玩家实体作为 relativeEntityId 后移动到玩家”的完整案例。

Lua Common Function Repository 明确说明：`RequestCharacterAICommand(EntityID, SendValue, SlotNumber)` 的值可由 AI `GetEventRequest(EventSlot)` 读取；它还给出 `SetEventMoveTarget(RegionEntityID)` + `GOAL_COMMON_ApproachTarget(..., POINT_EVENT, ...)` 的区域点移动示例，以及 `TARGET_LOCALPLAYER` 和 `GOAL_COMMON_ApproachTarget` 的通用目标示例。该页面自述内容是跨游戏兼容的知识仓库，不能作为当前1.17.1原生脚本实例或命令值验证。

### 组2：公开 `010000_logic.dec.lua` 与同一脚本接口

`zoloypzuo/EldenRingAI/010000_logic.dec.lua` 仅展示：读取 `arg0:GetEventRequest()`，请求值100/110时加入 `GOAL_COMMON_ApproachTarget`，请求80时加入等待 Goal。该脚本没有把请求映射为 `TARGET_LOCALPLAYER`，也没有调用 `SetEventMoveTarget`、`ClearCharactersAITarget` 或 `RequestCharacterAIReplan`。其 `POINT_INITIAL` 用法只能说明固定初始点/脚本点路径，不能证明移动玩家跟随。

因此没有得到“命令值→当前NpcThink逻辑→动态玩家目标”的闭环。

## 对目标问题的回答

1. **是否能指定实体发送请求？**
   - 事件文档层面：SOURCE-SUPPORTED。命令以 `entityId` 为目标。
   - 对81号原生骨灰：未建立实体 ID 来源；85号已经说明自生成实体的 ID 机制不能直接覆盖81号原生成员。

2. **是否能让目标移动到玩家附近？**
   - 仅有理论拼接：`SetEventPoint` 的相对实体参数、Lua 的事件点移动和 `TARGET_LOCALPLAYER` 目标均存在文档语义。
   - 没有当前版本的实际配对调用和对应 Goal 响应，故不能确认动态玩家跟随。

3. **是否能恢复原本接敌？**
   - `ClearCharactersAITarget` 和 `RequestCharacterAIReplan` 的指令签名存在。
   - 没有证据证明在该回防 Goal 完成后能恢复骨灰原有接敌目标，也没有对应脚本状态机案例。

4. **是否只是固定出生点？**
   - `POINT_INITIAL` 明确只能支持返回初始/固定点语义，不能当作玩家跟随。

5. **当前1.17.1适配程度**
   - EMEDF 页面是 Elden Ring 指令定义和地图使用清单，属于版本资料，但未提供本机1.17.1事件二进制或运行时验证。
   - Lua仓库和通用文档没有当前1.17.1完整脚本版本证明。

## 缺口与风险

- 需要可分配给81号原生骨灰的稳定事件实体 ID；
- 需要当前1.17.1真实 EMEVD 调用样本和命令值；
- 需要确认目标 AI 逻辑读取的槽位及响应 Goal；
- 需要证明 `SetEventPoint` 的 relativeEntityId 是动态玩家位置，而不是一次性点或区域引用；
- 需要回防结束后的目标清理与接敌恢复；
- 事件脚本改动会影响公共事件资源，存在与81号参数包及其他 Mod 的合并风险。

## 是否值得申请受控原生实验

当前不值得直接申请游戏实验。若 L3 继续批准，最小实验应先针对一个**自生成**友方 NPC，使用独立事件资源验证：唯一实体 ID → `SetEventPoint`/AI 请求 → Lua Goal 移动 → 清除目标并恢复接敌。该实验仍需要事件资源修改、运行时 DLL/Hook 或等价加载权限，并不能验证81号原生骨灰。

引用：
- https://soulsmods.github.io/emedf/er-emedf.html
- https://soulsmodding.com/doku.php?id=common-refmat:lua_ai_common_function_repository
- https://github.com/zoloypzuo/EldenRingAI/blob/master/010000_logic.dec.lua

停止条件已满足：未扩展第三条路线，未运行任何游戏或原生模块。