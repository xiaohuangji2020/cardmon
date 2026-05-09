extends Control

var _bars: Dictionary = {}   # unit -> ProgressBar，动态追踪

func add_unit(unit: Unit) -> void:
	var hbox := HBoxContainer.new()
	
	var label := Label.new()
	label.text = unit.data.unit_name
	label.custom_minimum_size.x = 40
	label.add_theme_font_size_override("font_size", 6)
	hbox.add_child(label)
	
	var bar := ProgressBar.new()
	bar.min_value = 0
	bar.max_value = Enums.MAX_AP
	bar.value = 0
	bar.custom_minimum_size = Vector2(60, 8)
	bar.show_percentage = false
	hbox.add_child(bar)
	
	$VBoxContainer.add_child(hbox)
	_bars[unit] = bar

func remove_unit(unit: Unit) -> void:
	if _bars.has(unit):
		_bars[unit].get_parent().queue_free()
		_bars.erase(unit)

func _process(_delta: float) -> void:
	for unit in _bars:
		if is_instance_valid(unit) and is_instance_valid(_bars[unit]):
			_bars[unit].value = unit.current_ap
