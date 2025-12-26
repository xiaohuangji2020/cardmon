# GameConfig.gd
extends Node

# 像物理常数一样定义你的配置
var grid_size: float = 2.0:
	set(value):
		grid_size = value
		# 自动将值同步给所有的 Shader 全局变量
		RenderingServer.global_shader_parameter_set("grid_size", value)

func _ready():
	# 游戏启动时初始化一次 Shader 全局变量
	RenderingServer.global_shader_parameter_set("grid_size", grid_size)
