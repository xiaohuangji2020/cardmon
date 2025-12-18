extends Sprite3D

@export var move_speed: float = 5.0

func _process(delta: float) -> void:
	var input := Vector3.ZERO
	
	if Input.is_action_pressed("ui_up"):
		input.z -= 1
	if Input.is_action_pressed("ui_down"):
		input.z += 1
	if Input.is_action_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_pressed("ui_right"):
		input.x += 1
	
	if input != Vector3.ZERO:
		input = input.normalized()
		position += input * move_speed * delta
