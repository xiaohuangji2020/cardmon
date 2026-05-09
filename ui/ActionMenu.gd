extends Control

signal move_pressed
signal skill_pressed
signal wait_pressed

func _ready() -> void:
	$PanelContainer/VBoxContainer/BtnMove.pressed.connect(
		func(): emit_signal("move_pressed"))
	$PanelContainer/VBoxContainer/BtnSkill.pressed.connect(
		func(): emit_signal("skill_pressed"))
	$PanelContainer/VBoxContainer/BtnWait.pressed.connect(
		func(): emit_signal("wait_pressed"))
	visible = false   # 默认隐藏

# 在指定像素位置显示菜单
func show_at(pixel_pos: Vector2) -> void:
	position = pixel_pos + Vector2(4, -20)
	visible = true

func hide_menu() -> void:
	visible = false
