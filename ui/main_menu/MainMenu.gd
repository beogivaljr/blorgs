extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MainButtons__connect_to_game():
	print("TODO: Connect to a game")


func _on_MainButtons__new_game():
	$MainButtons.visible = false
	$NewGameInfo.create_new_game()
	$NewGameInfo.visible = true


func _on_NewGameInfo_on_cancel():
	$MainButtons.visible = true
	$NewGameInfo.visible = false
