class_name Platform
extends KinematicBody

var lever_target_a_position = Vector3.ZERO

func raise_platform():
	$AnimationPlayer.play("Raise")
	$AnimationPlayer.connect("animation_finished", $AnimationPlayer, "play_backwards", ["Raise"])
