extends VBoxContainer


signal on_cancelled

var _hash_code : String

## TODO: Move server/client game conection and creation out of the ScreenContainer
func create_new_game():
	var game_code = ""
	if _hash_code:
		game_code = _hash_code
	$GameCode.text = game_code

## TODO: Move server/client game conection and creation out of the ScreenContainer
func destroy_new_game():
	$GameCode.text = ""
	print("TODO: Destroy game server")

func set_hash_code(hash_code : String):
	if hash_code: 
		_hash_code = hash_code


func _on_Cancel_pressed():
	_hash_code = ""
	destroy_new_game()
	emit_signal("on_cancelled")
