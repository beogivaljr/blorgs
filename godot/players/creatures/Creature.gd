class_name Creature
extends BaseCharacter


signal spawn_animation_finished


var spawner: CreatureSpawner


func destroy():
	_kinematic_movement.emit_signal("started_movement") # Release buttons
	queue_free()


func disassemble():
	$Skeleton.play_death()


func _ready():
	$Skeleton.play_spawn()
	_kinematic_movement.connect("started_movement", $Skeleton, "play_running")
	_kinematic_movement.connect("succeded_movement", $Skeleton, "play_idle")
	_kinematic_movement.connect("failed_movement", $Skeleton, "play_idle")


func _on_Skeleton_spawn_animation_finished():
	emit_signal("spawn_animation_finished")
