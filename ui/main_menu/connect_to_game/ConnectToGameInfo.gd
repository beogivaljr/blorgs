extends VBoxContainer

signal play(code, playerName)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameCodeLineEdit.max_length = GlobalConstants.CONNECTION_CODE_LENGTH


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_PlayButton_pressed() -> void:
	var gameCode = $GameCodeLineEdit.text
	var playerName = $PlayerName.text
	emit_signal("play", gameCode, playerName)

