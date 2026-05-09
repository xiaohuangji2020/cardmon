# 架构详解

## 全局自动加载（`core/`）
- `Enums.gd` — 所有共享枚举（`UnitType`、`BattleState`、`ActionState`）以及网格/CTB 常量（`GRID_COLS=20`、`GRID_ROWS=20`、`CELL_SIZE=32`、`MAX_AP=100`）。全局以 `Enums.*` 引用。
- `GameManager.gd` — 目前是空壳，未来的全局状态放这里。

## 战斗流程（`battle/`）
`BattleManager.gd` 掌控整个战斗循环，是 `Battle.tscn` 的根节点脚本，负责协调所有子系统：

1. **生成单位** — `_spawn_units()` 加载 `UnitData` `.tres` 资源，实例化 `Unit.tscn`，并将单位注册到 `GridManager`、`CTBSystem` 和 `CTBBar`。
2. **CTB 推进** — `CTBSystem._process()` 每帧为各单位累加 AP。某单位 AP 达到 100 时发出 `unit_ready` 信号，`CTBSystem` 自身暂停，`BattleManager._on_unit_ready()` 响应。
3. **玩家回合** — `BattleManager` 显示 `ActionMenu`。玩家选择移动 / 技能 / 等待，驱动 `ActionState` 状态机。格子点击通过 `GridManager` 的 `cell_clicked` 信号路由。
4. **敌方回合** — `UnitAI.run()`（`RefCounted` 类上的静态方法）通过 `await` 延迟执行，便于玩家观察，结束后调用 `_end_turn()`。
5. **结束回合** — `_end_turn()` 从当前单位 AP 中扣除 `MAX_AP`，清除高亮和状态，调用 `CTBSystem.resume()` 重启计时。

## 网格（`grid/`）
`GridManager.gd` 维护一个 20×20 的二维数组（`_grid`），将 `Vector2i` 坐标映射到 `Unit` 引用（或 `null`）。核心方法：
- `get_move_range(origin, move_range)` — BFS，跳过已有单位的格子
- `get_attack_range(origin, attack_range)` — 曼哈顿距离，含有单位的格子也包括在内
- `highlight_cells()` / `clear_highlights()` — 修改 `ColorRect` 节点颜色
- `_input()` — 将鼠标点击转换为 `cell_clicked(grid_pos)` 信号

网格坐标约定：`_grid[row][col]`，即 `_grid[y][x]`。

## 单位（`units/`）
- `Unit.gd`（`class_name Unit`）— 运行时状态：`current_hp`、`current_ap`、`grid_pos`、`has_acted`。视觉表现由代码动态创建的 `ColorRect` + `Label` 节点充当（美术资源到位前的占位符）。
- `UnitData.gd`（`class_name UnitData`，继承 `Resource`）— 静态数据：属性、颜色、技能列表。实例位于 `units/data/tres/`。
- `UnitAI.gd`（`class_name UnitAI`，继承 `RefCounted`）— 无状态静态 AI。`run()` 找到最近的我方单位，移动靠近后若在攻击范围内则发动攻击。

## 技能（`skills/`）
- `SkillData.gd`（`class_name SkillData`，继承 `Resource`）— 字段：`skill_name`、`damage`、`atk_range`、`ap_cost`。实例位于 `skills/tres/`。
- 伤害公式：`actual_damage = max(skill.damage + unit.attack - target.defense, 1)`
- 目前只使用单位技能列表中的第一个技能（`BattleManager` 和 `UnitAI` 中硬编码了 `skills[0]`）。

## UI（`ui/`）
- `ActionMenu.gd` — 悬浮在当前行动单位旁，发出 `move_pressed`、`skill_pressed`、`wait_pressed` 信号。
- `CTBBar.gd` — 每个单位对应一组标签+进度条，每帧从 `unit.current_ap` 更新显示。
