# 88-CODEX-ERAI-LOCAL-AI-ARCHIVE-EXTRACTION

范围：只读盘点；未解包、未运行第三方程序、未修改游戏目录或81号资产。

## 1. 原始档案

当前游戏目录存在原始 BHD/BDT 档案：

- `Data0.bhd` / `Data0.bdt`
- `Data1.bhd` / `Data1.bdt`
- `Data2.bhd` / `Data2.bdt`
- `Data3.bhd` / `Data3.bdt`
- `DLC.bhd` / `DLC.bdt`

其中 BDT 为多 GB 级档案。只完成文件存在性和大小盘点，没有进行全档案扫描或解包。当前 Elden Ring EXE 仍为既有本机版本记录；本轮未改动。

## 2. 工具检查

本机找到的是 Smithbox 的工具帮助链接和 Elden Ring 参数定义，不是可执行的 Nuxe、WitchyBND、UXM Selective Unpack 或 DSLuaDecompiler 工具：

- `<GAME_ROOT>\Smithbox_2_2_6_2026_09_20_b\Assets\Help\Links\Tool_WitchyBnd.json`
- `...\Tool_DSLuaDecompiler.json`
- `...\Tool_UxmSelective.json`

这些文件只记录官方/公开项目链接和说明。没有找到可在当前环境直接运行的对应工具，也没有下载或安装任何新工具。可用磁盘空间约276 GB，但不据此进行大规模解包。

## 3. 有限提取结果

未执行提取。原因是：原始档案存在，但缺少已安装且可信的 BHD/BDT 选择性提取工具及 Lua/HavokScript 解析器。按照任务限制，不能自行下载、安装或运行外部工具，也不能完整解包游戏档案。

因此：

- `logicId=10000` 对应脚本：未取得；
- `battleGoalID=700010` 对应脚本：未取得；
- 当前1.17.1脚本版本归属：无法核验；
- 接敌、追击、跟随、回防逻辑：无法从本机正文分析。

## 4. 结论

**EXTRACTION_TOOL_REQUIRED**

已经确认候选 AI 资源应位于原始 BHD/BDT 档案中，但当前缺少完成选择性提取和 Lua/HavokScript 解析所需的工具。没有把文件名或数字映射猜测成脚本证据。

下一步若继续，必须由 L3 另行批准取得并核验固定版本的 WitchyBND/等效 BHD-BDT 提取工具与 DSLuaDecompiler，并限定输出到 `<ERAI_ROOT>\work\erai-ai-source-88`；本轮未执行该动作。

没有足够证据支持下一步 AI 原型设计。未修改原版档案、81号成果、存档或系统设置。