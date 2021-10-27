extends VBoxContainer

signal play_pressed(code, playerName)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameCodeLineEdit.max_length = GlobalConstants.CONNECTION_CODE_LENGTH


func _on_PlayButton_pressed() -> void:
	var game_code = $GameCodeLineEdit.text
	var player_name = $PlayerName.text
	emit_signal("play_pressed", game_code, player_name)

