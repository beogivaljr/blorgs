extends VBoxContainer


signal on_cancel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func create_new_game():
	var gameCode = generate_word(
	GlobalConstants.CHARACTERS, 
	GlobalConstants.CONNECTION_CODE_LENGTH)
	$GameCode.text = gameCode

func destroy_new_game():
	$GameCode.text = ""
	print("TODO: Destroy game server")

func generate_word(chars, length):
	var word: String = ""
	var n_char = len(chars)
	for _i in range(length):
		randomize()
		word += chars[randi()% n_char]
	return word

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Cancel_pressed():
	destroy_new_game()
	emit_signal("on_cancel")
