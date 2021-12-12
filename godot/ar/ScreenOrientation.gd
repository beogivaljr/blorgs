extends Node

signal screen_orientation_changed(orientation)

enum {
	LANDSCAPE,
	PORTRAIT
}

var last_size

func _ready():
	last_size = get_viewport().size


func _process(_delta):
	var size = get_viewport().size
	if size.x != last_size.x or size.y != last_size.y:
		var orientation
		if size.x > size.y:
			orientation = LANDSCAPE
		else:
			orientation = PORTRAIT
		emit_signal("screen_orientation_changed", orientation)
	last_size = size
