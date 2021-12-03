class_name Skeleton2
extends BaseCharacter

signal creature_destroyed

var spawner: CreatureSpawner

func destroy():
	$AnimationPlayer.play("Skeleton_Idle")
	_kinematic_movement.emit_signal("started_movement") # Release buttons
	queue_free()


func disassemble():
	push_error("TODO: play bones disassembling")
