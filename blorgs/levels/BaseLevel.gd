class_name BaseLevel
extends Spatial

## Emit this signal when the level is done
# warning-ignore:unused_signal
signal on_level_finished

onready var player_input_handler = $PlayerInputHandler

func _ready():
	player_input_handler.connect("on_dragged", $GameCamera, "pan_camera")
	
