class_name Creature
extends BaseCharacter

signal creature_destroyed


func destroy():
	push_error("TODO: play bones disassembling")
	push_error("TODO: play bones vanishing")
	queue_free()


func disassemble():
	push_error("TODO: play bones disassembling")
