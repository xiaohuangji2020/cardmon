# 关键约定

## 坐标系
格子坐标为 `Vector2i(col, row)`（x=列，y=行）。世界像素中心 = `grid_pos * CELL_SIZE + CELL_SIZE/2`。

内部数组索引为 `_grid[row][col]`，即 `_grid[y][x]`。

## AP 经济
单位行动结束后不将 AP 归零，而是减去 `MAX_AP (100)`，溢出部分保留。速度快的单位因此长期保持先手优势。

## `has_acted` 标志
每回合开始时重置为 `false`，使用技能后设为 `true`，防止同一回合内二次施法。

## 场景节点名称
`BattleManager` 通过 `@onready` 路径引用子节点：

```
$Grid → GridManager
$CTBSystem → CTBSystem
$UI/CTBBar → CTBBar
$UI/ActionMenu → ActionMenu
$UI/ResultLabel → Label
```

这些名称必须与 `Battle.tscn` 中的节点名完全一致，否则运行时报错。

## 代码风格

始终使用 Godot 4.x 最新语法，避免沿用 Godot 3 的写法（如 `connect()` 的旧签名、`yield`、`setget` 等）。

信号连接统一使用以下形式，不使用字符串方式的 `connect("signal_name", ...)`：

```gdscript
# 正确
node.signal_name.connect(callback)

# 错误
node.connect("signal_name", self, "callback")
```

## 资源文件
单位和技能数据是 Godot `.tres` 文件，请通过 Godot 编辑器的 Inspector 修改，不要手动编辑其文本格式。
