extends Control

signal ok_pressed
signal cancel_pressed

var _message: String
var _has_cancel_button: bool
var _ok_button_title: String

func _ready():
	$PanelContainer/VBoxContainer/MessageLabel.text = _message
	$PanelContainer/VBoxContainer/HBoxContainer/CancelButton.visible = _has_cancel_button
	$PanelContainer/VBoxContainer/HBoxContainer/OkButton.text = _ok_button_title


func setup(message: String, has_cancel_button: bool, ok_button_title = "Ok"):
	_ok_button_title = ok_button_title
	_message = message
	_has_cancel_button = has_cancel_button


func _on_CancelButton_pressed():
	emit_signal("cancel_pressed")
	queue_free()


func _on_OkButton_pressed():
	emit_signal("ok_pressed")
	queue_free()
