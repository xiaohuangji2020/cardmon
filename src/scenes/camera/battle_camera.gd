extends Node3D

# --- 配置参数 ---
# 移动速度
@export var move_speed: float = 10.0
# 鼠标旋转灵敏度
@export var mouse_sensitivity: float = 0.005
# 缩放平滑度 (越小越平滑)
@export var zoom_speed: float = 0.5
# 缩放限制 (最近和最远距离)
@export var min_zoom: float = 2.0
@export var max_zoom: float = 20.0

# --- 内部引用 ---
@onready var pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D

# 目标缩放值 (用于实现平滑缩放)
var _target_zoom: float = 10.0

func _ready() -> void:
	# 初始化目标缩放等于当前距离
	_target_zoom = camera.position.z

func _process(delta: float) -> void:
	_handle_movement(delta)
	_handle_zoom_smooth(delta)

# 处理键盘 WASD 平移
func _handle_movement(delta: float) -> void:
	# 【核心改变】
	# Input.get_vector 会自动帮你处理：
	# 1. 谁减谁 (左是负，右是正)
	# 2. 归一化 (斜着走不会变快)
	# 3. 手柄死区 (如果你以后支持手柄摇杆，这行代码不用动就能直接支持)
	# 参数顺序：负X, 正X, 负Y, 正Y (即：左, 右, 上, 下)
	var input_vector = Input.get_vector("cam_left", "cam_right", "cam_forward", "cam_back")

	# 如果没按键，直接返回，省算力
	if input_vector == Vector2.ZERO:
		return

	# 坐标转换逻辑不变
	var forward = pivot.global_transform.basis.z
	var right = pivot.global_transform.basis.x

	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()

	# 注意：input_vector.y 对应的是 forward/back，input_vector.x 对应 left/right
	# 这里的负号取决于你的 Input Map 谁在前谁在后，如果发现反了就加个负号(给 input_vector.y加）
	var direction = (forward * input_vector.y) + (right * input_vector.x)

	global_position += direction * move_speed * delta

# 处理鼠标输入 (旋转和缩放)
func _unhandled_input(event: InputEvent) -> void:
	# 1. 鼠标旋转
	if event is InputEventMouseMotion:
		# 这里不再检测 "Input.is_mouse_button_pressed"
		# 而是检测我们定义的 Action 是否被按下
		if Input.is_action_pressed("cam_rotate_mode"):
			pivot.rotate_y(-event.relative.x * mouse_sensitivity)
			var current_rot_x = pivot.rotation.x
			current_rot_x -= event.relative.y * mouse_sensitivity
			pivot.rotation.x = clamp(current_rot_x, deg_to_rad(-90), deg_to_rad(-10))

# 实现平滑缩放插值
func _handle_zoom_smooth(delta: float) -> void:
	# 利用 lerp (线性插值) 让相机缓缓移动到目标 Z 位置
	camera.position.z = lerp(camera.position.z, _target_zoom, 5.0 * delta)
