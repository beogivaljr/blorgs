extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal _new_game
signal _connect_to_game


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGame_pressed():
	emit_signal("_new_game")


func _on_ConnectToGame_pressed():
	emit_signal("_connect_to_game")
