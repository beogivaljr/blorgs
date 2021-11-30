extends Node


var _levels = {
	GameState.LevelIds.SANDBOX: preload("res://levels/sandbox/SandboxLevel.tscn"),
	GameState.LevelIds.MAZE1: preload("res://levels/maze/maze_1/Maze1Level.tscn"),
	GameState.LevelIds.MAZE2: preload("res://levels/sandbox/SandboxLevel.tscn"),
	GameState.LevelIds.MAZE3: preload("res://levels/sandbox/SandboxLevel.tscn"),
	GameState.LevelIds.MAZE4: preload("res://levels/sandbox/SandboxLevel.tscn"),
}

var _current_level: BaseLevel


func _ready() -> void:
	_set_new_level(_levels[GameState.current_level_id].instance())


func _set_new_level(level: BaseLevel):
	if _current_level:
		_current_level.queue_free()
	if level:
		_bind_level_signals(level)
		add_child(level)
	_current_level = level


func _bind_level_signals(level: BaseLevel):
	# warning-ignore:return_value_discarded
	level.connect("level_finished", self, "_on_level_finished")


func _on_level_finished():
	_changeLevel()


func _changeLevel():
	match GameState.current_level_id:
		GameState.LevelIds.SANDBOX:
			GameState.current_maze_index += 1
			GameState.current_level_id = GameState.current_maze_index
		GameState.LevelIds.MAZE4:# Last maze
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Main.tscn")
			return
		_:
			GameState.current_level_id = GameState.LevelIds.SANDBOX
	
	_set_new_level(_levels[GameState.current_level_id].instance())
