extends BaseWorld
## Script inherited from Base World because it will contain some common
## This will be very handy because the Level Manager won't have to know
## exactly which level it is managing.


func _ready() -> void:
	_spawn_and_setup_player()
	_world_input_handler.connect("on_clicked", self, "_handle_world_click")
	_bind_interactables()


func _spawn_and_setup_player():
	var player = preload("res://players/BaseCharacter.tscn").instance()
	player.connect("spell_started", self, "_on_spell_started")
	player.connect("spell_done", self, "_on_spell_done")
	add_child(player, true)
	player.global_transform = $PlayerSpawn.global_transform
	player.setup($Navigation)
	_players[player.name] = player
	_active_character = player


func set_active_spell_id(spell_id):
	.set_active_spell_id(spell_id)
	_active_character.set_active_spell_id(spell_id)


func _bind_interactables():
	for child in get_children():
		if child is Gate:
			child.connect("gate_lowered", self, "_on_gate_lowered")
			child.connect("gate_raised", self, "_on_gate_raised")
		elif child is Elevator:
			child.connect("transported_up", self, "_on_transported_up")
			child.connect("transported_down", self, "_on_transported_down")
		elif child is MagicButton:
			for bridge_platform in get_tree().get_nodes_in_group(child.name):
				child.connect("button_activated", bridge_platform, "activate")
				child.connect("button_deactivated", bridge_platform, "deactivate")
				bridge_platform.connect("platform_activated", self, "_on_button_activated")
				bridge_platform.connect("platform_deactivated", self, "_on_button_deactivated")


# Gate
func _on_gate_lowered(gate_name):
	# TODO: Activate respective navmesh
	emit_signal("spell_done", true)


func _on_gate_raised(gate_name):
	# TODO: Deactivate respective navmesh
	emit_signal("spell_done", true)


#Elevator
func _on_transported_up(elevator_name):
	emit_signal("spell_done", true)


func _on_transported_down(elevator_name):
	emit_signal("spell_done", true)


# MagicButtons
func _on_button_activated(button_name):
	# TODO: Activate respective navmesh
	emit_signal("spell_done", true)


func _on_button_deactivated(button_name):
	# TODO: Deactivate respective navmesh
	pass


func _handle_world_click(_event, intersection):
	if not intersection.empty():
		var node = intersection.collider
		var location = intersection.position
		_active_character.attempt_to_cast_spell_on(node, location)
		.attempt_to_cast_spell_on(node, location)


func _on_KillYArea_body_entered(body: Node):
	if body is Creature:
		_spawn_and_setup_creature(_active_creature_spawner_per_creature[body.name])
	elif body is BaseCharacter:
		_spawn_and_setup_player()
	body.queue_free()
	emit_signal("spell_done", false)
