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


func _on_MainButtons_connect_to_game():
	_set_screen(CONNECT_TO_GAME_INFO)


func _on_MainButtons_new_game():
	## TODO: Move server/client game conection and creation out of the ScreenContainer
	$ScreensContainer/NewGameInfo.create_new_game()
	_set_screen(NEW_GAME_INFO)
	# warning-ignore:return_value_discarded
#	get_tree().change_scene("res://levels/LevelManager.tscn")
	


func _on_NewGameInfo_on_canceled():
	_set_screen(MAIN_BUTTONS)


func _on_ConnectToGameInfo_play_pressed(code, playerName) -> void:
	print("TODO: Connect to game with code: " + code + "\nAnd player name: " + playerName)
	_set_screen(CONNECTING)


func _set_screen(screen):
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


func _on_Connecting_canceled() -> void:
	print("TODO: Cancel game connection")
	_set_screen(MAIN_BUTTONS)
