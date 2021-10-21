extends Control


enum {
	MAIN_BUTTONS,
	NEW_GAME_INFO,
	CONNECT_TO_GAME_INFO,
	CONNECTING
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MainButtons_connect_to_game():
	setScreen(CONNECT_TO_GAME_INFO)


func _on_MainButtons_new_game():
#	$ScreensContainer/NewGameInfo.create_new_game()
#	setScreen(NEW_GAME_INFO)
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://levels/LevelManager.tscn")
	


func _on_NewGameInfo_on_cancel():
	setScreen(MAIN_BUTTONS)


func _on_ConnectToGameInfo_play(code, playerName) -> void:
	print("TODO: Connect to game with code: " + code + "\nAnd player name: " + playerName)
	setScreen(CONNECTING)


func setScreen(screen):
	match screen:
		MAIN_BUTTONS:
			$ScreensContainer/MainButtons.visible = true
			$ScreensContainer/NewGameInfo.visible = false
			$ScreensContainer/ConnectToGameInfo.visible = false
			$ScreensContainer/Connecting.visible = false
		NEW_GAME_INFO:
			$ScreensContainer/MainButtons.visible = false
			$ScreensContainer/NewGameInfo.visible = true
			$ScreensContainer/ConnectToGameInfo.visible = false
			$ScreensContainer/Connecting.visible = false
		CONNECT_TO_GAME_INFO:
			$ScreensContainer/MainButtons.visible = false
			$ScreensContainer/NewGameInfo.visible = false
			$ScreensContainer/ConnectToGameInfo.visible = true
			$ScreensContainer/Connecting.visible = false
		CONNECTING:
			$ScreensContainer/MainButtons.visible = false
			$ScreensContainer/NewGameInfo.visible = false
			$ScreensContainer/ConnectToGameInfo.visible = false
			$ScreensContainer/Connecting.visible = true


func _on_Connecting_cancel() -> void:
	print("TODO: Cancel game connection")
	setScreen(MAIN_BUTTONS)
