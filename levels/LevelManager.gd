extends Node


const LEVELS = {
	0: preload("res://levels/sandbox/Sandbox.tscn"),
	1: preload("res://levels/maze/Maze_01.tscn"),
	2: preload("res://levels/maze/Maze_02.tscn"),
	3: preload("res://levels/maze/Maze_03.tscn")
}

var _current_level_index = 0
var _current_maze_index = 0
onready var _current_level = $Sandbox


func _ready() -> void:
	_bind_level_signals(_current_level)


func _bind_level_signals(level: BaseLevel):
	# warning-ignore:return_value_discarded
	level.connect("on_level_finished", self, "_changeLevel")


func _changeLevel():
	var is_last_maze = _current_maze_index >= LEVELS.size() - 1
	var next_level
	if _current_level_index == 0 and not is_last_maze:
		_current_maze_index += 1
		next_level = LEVELS[_current_maze_index].instance()
		_current_level_index = _current_maze_index
	elif _current_level_index and not is_last_maze:
		_current_level_index = 0
		next_level = LEVELS[_current_level_index].instance()
	else:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Main.tscn")
		return
	
	add_child(next_level)
	_bind_level_signals(next_level)
	_current_level.queue_free()
	_current_level = next_level