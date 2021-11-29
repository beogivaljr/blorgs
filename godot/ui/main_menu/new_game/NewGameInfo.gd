extends VBoxContainer

signal on_cancelled


## TODO: Move server/client game conection and creation out of the ScreenContainer
func set_game_code(match_code: String):
	$GameCode.text = match_code


## TODO: Move server/client game conection and creation out of the ScreenContainer
func destroy_new_game():
	$GameCode.text = ""
	print("TODO: Destroy game server")


func _on_Cancel_pressed():
	destroy_new_game()
	emit_signal("on_cancelled")
