extends Camera3D

var rotation_speed := 0.005
var is_dragging := false
var last_mouse_pos := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.pressed
			if event.pressed:
				last_mouse_pos = event.position

	elif event is InputEventMouseMotion and is_dragging:
		var delta_mouse: Vector2 = event.position - last_mouse_pos
		last_mouse_pos = event.position

		# 水平旋转（绕Y轴）
		rotate_y(-delta_mouse.x * rotation_speed)

		# 垂直旋转（绕局部X轴）
		var current_rotation: float = rotation.x
		var new_rotation: float = clamp(current_rotation - delta_mouse.y * rotation_speed, -PI/2 + 0.1, -0.1)
		rotation.x = new_rotation
