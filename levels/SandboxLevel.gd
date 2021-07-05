extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	$Skeleton/AnimationPlayer.get_animation("Skeleton_Attack").set_loop(true)
#	$Skeleton/AnimationPlayer.play("Skeleton_Attack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HUD1_on_move_selected():
	$GroundHighlight.visible = true
	$Skeleton.move_spell_selected = true


func _on_Skeleton_on_character_moving():
	$GroundHighlight.visible = false
