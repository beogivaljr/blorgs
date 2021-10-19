extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal new_game
signal connect_to_game


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGame_pressed():
	emit_signal("new_game")


func _on_ConnectToGame_pressed():
	emit_signal("connect_to_game")
