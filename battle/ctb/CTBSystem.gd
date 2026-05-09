class_name CTBSystem
extends Node

signal unit_ready(unit: Unit)   # 某单位 AP 满了，轮到它行动

var _units: Array[Unit] = []
var _running: bool = false

func register_units(units: Array[Unit]) -> void:
	_units = units.duplicate()  # 复制数组，避免引用问题

func start() -> void:
	_running = true

func stop() -> void:
	_running = false

func resume() -> void:
	_running = true

func remove_unit(unit: Unit) -> void:
	_units.erase(unit)

func _process(delta: float) -> void:
	if not _running:
		return
	
	for unit in _units:
		if not unit.is_alive():
			continue
		if unit.is_ap_full():
			continue
		unit.regen_ap(delta)
		
		if unit.is_ap_full():
			_running = false       # 暂停，等待该单位行动完毕
			emit_signal("unit_ready", unit)
			return                 # 每帧只触发一个单位，防止同帧多个单位同时满
