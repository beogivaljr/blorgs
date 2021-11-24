class_name BaseWorld
extends Spatial


onready var world_input_handler = $WorldInputHandler

func _ready():
	world_input_handler.connect("on_dragged", $GameCamera, "pan_camera")
	
