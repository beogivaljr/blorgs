class_name Creature
extends BaseCharacter

var spawner: CreatureSpawner


func destroy():
	push_error("TODO: play bones disassembling")
	push_error("TODO: play bones vanishing")
	_kinematic_movement.emit_signal("started_movement") # Release buttons
	queue_free()


func disassemble():
	push_error("TODO: play bones disassembling")
