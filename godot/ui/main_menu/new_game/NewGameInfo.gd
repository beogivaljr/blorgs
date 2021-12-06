extends VBoxContainer

signal on_cancelled

var tried_to_auto_copy = false

## TODO: Move server/client game conection and creation out of the ScreenContainer
func set_game_code(match_code: String):
	tried_to_auto_copy = false
	$GameCode.text = match_code


## TODO: Move server/client game conection and creation out of the ScreenContainer
func destroy_new_game():
	$GameCode.text = ""
	print("TODO: Destroy game server")


func _on_Cancel_pressed():
	destroy_new_game()
	emit_signal("on_cancelled")


func _on_GameCode_gui_input(event):
	if (event is InputEventScreenTouch or event is InputEventMouseButton) and event.pressed:
		var code = $GameCode.text
		if not tried_to_auto_copy:
			tried_to_auto_copy = true
			OS.clipboard = code
			$GameCode.text = "Copiado!"
			yield(get_tree().create_timer(2.0), "timeout")
			$GameCode.text = code
