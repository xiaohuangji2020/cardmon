extends Sprite3D

var speed := 2.0

func _process(delta: float) -> void:
	var input := Vector3.ZERO

	if Input.is_action_pressed("ui_right"):
		input.x += 1
	if Input.is_action_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_pressed("ui_down"):
		input.z += 1
	if Input.is_action_pressed("ui_up"):
		input.z -= 1

	if input != Vector3.ZERO:
		position += input.normalized() * speed * delta
