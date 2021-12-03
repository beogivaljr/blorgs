extends Node


var _level_list = [
	preload("res://levels/sandbox/SandboxLevel1.tscn"),
	preload("res://levels/maze/maze_1/MazeLevel1.tscn"),
	preload("res://levels/sandbox/SandboxLevel2.tscn")
]

var _current_level: BaseLevel


func _ready() -> void:
	_load_level(_level_list[GameState.current_level_index].instance())


func _load_level(level: BaseLevel):
	if _current_level:
		remove_child(_current_level)
		_current_level.queue_free()
	add_child(level)
	_bind_level_signals(level)
	_current_level = level


func _bind_level_signals(level: BaseLevel):
	# warning-ignore:return_value_discarded
	level.connect("level_finished", self, "_on_level_finished", [], CONNECT_ONESHOT)
	level.connect("level_failed", self, "_on_level_failed", [], CONNECT_ONESHOT)


func _on_level_finished():
	# Wait some time to win
	yield(get_tree().create_timer(3.0), "timeout")
	_load_next_level()


func _on_level_failed():
	# Wait some time to lose
	yield(get_tree().create_timer(3.0), "timeout")
	_load_previous_level()


func _load_next_level():
	GameState.current_level_index += 1
	if GameState.current_level_index >= _level_list.size():
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Main.tscn")
	else:
		_load_level(_level_list[GameState.current_level_index].instance())


func _load_previous_level():
	GameState.current_level_index -= 1
	if GameState.current_level_index < 0:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Main.tscn")
	else:
		_load_level(_level_list[GameState.current_level_index].instance())
