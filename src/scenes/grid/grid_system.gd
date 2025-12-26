extends Node3D

# 预载高亮色块的小场景
const HIGHLIGHT_CELL = preload("res://src/scenes/grid/highlight_cell.tscn")

@onready var container = $HighlightContainer

# 清空所有高亮
func clear_all():
	for child in container.get_children():
		child.queue_free()

# 核心函数：显示范围
# type: "move" 为蓝色, "attack" 为红色
func display_range(cells: Array[Vector2i], type: String):
	var color = Color(0.2, 0.653, 1.0, 0.5) # 默认蓝色
	if type == "attack":
		color = Color(1.0, 0.2, 0.453, 0.5) # 红色

	for pos in cells:
		var cell = HIGHLIGHT_CELL.instantiate()
		container.add_child(cell)

		# 坐标转换逻辑（2.0是格子大小）
		cell.position = Vector3(pos.x * 2.0, 0.02, pos.y * 2.0)

		# 动态修改颜色
		var mat = cell.get_active_material(0).duplicate()
		mat.albedo_color = color
		cell.set_surface_override_material(0, mat)
