class_name BaseWorld
extends Spatial

signal spell_started(spell_id)
signal spell_done(succeded)

onready var world_input_handler = $WorldInputHandler


func _ready():
	world_input_handler.connect("on_dragged", $GameCamera, "pan_camera")


func _on_spell_started(spell_id):
	emit_signal("spell_started", spell_id)


func _on_spell_done(spell_id):
	emit_signal("spell_done", spell_id)


func _on_KillYArea_body_entered(body):
	pass
