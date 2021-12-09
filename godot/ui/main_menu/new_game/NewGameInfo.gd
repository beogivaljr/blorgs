extends VBoxContainer

signal canceled

var tried_to_auto_copy = false


func set_game_code(match_code: String):
	tried_to_auto_copy = false
	$GameCode.text = match_code


func destroy_new_game():
	$GameCode.text = ""


func _on_Cancel_pressed():
	destroy_new_game()
	emit_signal("canceled")


func _on_GameCode_gui_input(event):
	if (event is InputEventScreenTouch or event is InputEventMouseButton) and event.pressed:
		var code = $GameCode.text
		if not tried_to_auto_copy:
			tried_to_auto_copy = true
			OS.clipboard = code
			$GameCode.text = "Copiado!"
			yield(get_tree().create_timer(2.0), "timeout")
			$GameCode.text = code
