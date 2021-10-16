extends VBoxContainer


signal on_cancel

var characters = 'ABCDEFGHIJKLMNOPQRSTUVXYZ0123456789'

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func create_new_game():
	var gameCode = generate_word(characters, 6)
	$GameCode.text = gameCode

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
	emit_signal("on_cancel")
