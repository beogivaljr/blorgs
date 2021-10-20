extends Node

onready var currentLevel = $Sandbox
var currentLevelIndex = 0
var currentMazaIndex = 0


const levels = {
	0: preload("res://levels/sandbox/Sandbox.tscn"),
	1: preload("res://levels/maze/Maze_01.tscn"),
	2: preload("res://levels/maze/Maze_02.tscn"),
	3: preload("res://levels/maze/Maze_03.tscn")
}


func _ready() -> void:
	currentLevel.connect("on_nextLevel", self, "_changeLevel")


func _changeLevel():
	var nextLevel
	var notLastMaze = currentMazaIndex < levels.size() - 1
	if currentLevelIndex == 0 and notLastMaze:
		currentMazaIndex += 1
		nextLevel = levels[currentMazaIndex].instance()
		currentLevelIndex = currentMazaIndex
	elif currentLevelIndex and notLastMaze:
		currentLevelIndex = 0
		nextLevel = levels[currentLevelIndex].instance()
	else:
		get_tree().change_scene("res://Main.tscn")
		return
	
	add_child(nextLevel)
	nextLevel.connect("on_nextLevel", self, "_changeLevel")
	currentLevel.queue_free()
	currentLevel = nextLevel
