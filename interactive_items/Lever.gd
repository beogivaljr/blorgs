extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rotDirection = 1.0


# Called when the node enters the scene tree for the first time.
#func _ready():
#	$Pivot.rotate_x(PI / 4.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rotSpeed = PI / 8.0 * rotDirection
	
	if $Pivot.rotation.x >= PI / 4.0:
		rotDirection = -1.0
	elif $Pivot.rotation.x <= -PI / 4.0:
		rotDirection = 1.0
	
	$Pivot.rotate_x(rotSpeed * delta)
