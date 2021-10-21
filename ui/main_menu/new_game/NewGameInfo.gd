extends VBoxContainer


signal on_canceled


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


## TODO: Move server/client game conection and creation out of the ScreenContainer
func create_new_game():
	var game_code = _generate_word(
	GlobalConstants.CHARACTERS, 
	GlobalConstants.CONNECTION_CODE_LENGTH)
	$GameCode.text = game_code

## TODO: Move server/client game conection and creation out of the ScreenContainer
func destroy_new_game():
	$GameCode.text = ""
	print("TODO: Destroy game server")

## TODO: Move server/client game conection and creation out of the ScreenContainer
func _generate_word(chars, length):
	var word: String = ""
	var n_char = len(chars)
	for _i in range(length):
		randomize()
		word += chars[randi()% n_char]
	return word


func _on_Cancel_pressed():
	destroy_new_game()
	emit_signal("on_canceled")
