extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Skeleton/AnimationPlayer.get_animation("Skeleton_Attack").set_loop(true)
	$Skeleton/AnimationPlayer.play("Skeleton_Attack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
