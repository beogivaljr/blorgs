extends BaseWorld
## Script inherited from Base World because it will contain some common 
## behaviour, like the signal "level_finished" for instance.
## This will be very handy because the Level Manager won't have to know
## exactly which level it is managing.

signal spell_done(succeded)

var _active_spell = null


func _ready() -> void:
	emit_signal("spell_done", true)
	$PlayerA.setup($Navigation)
	world_input_handler.connect("on_clicked", self, "_handle_player_click")
	_bind_interactables()
	## Just an example of how to call level finish for the Level Manager to
	## take care of it.
#	emit_signal("level_finished")


func _bind_interactables():
	pass
	## Finad all direct children of interactable class
#	var direct_children = self.get_children()
#	var player_a_movement = $PlayerA/KinematicMovement
#	player_a_movement.connect("on_failed_movement", _hud, "on_spell_done")
#	player_a_movement.connect("on_succeded_movement", _hud, "on_spell_done")
#	for child in direct_children:
#		if child is Gate:
#			player_a_movement.connect("on_reached_gate", child, "toggle_raise_lower")
#			child.connect("on_interaction_done", _hud, "on_spell_done")
#		elif child is Elevator:
#			player_a_movement.connect("on_reached_elevator", child, "transport")
#			child.connect("on_interaction_done", _hud, "on_spell_done")


func set_active_spell(spell_id):
	_active_spell = spell_id


func _handle_player_click(_event, intersection):
	var spell_ids_bucket = GlobalConstants.SpellIds
#	var player_a_movement = $PlayerA/KinematicMovement
#	if not intersection.empty():
#		var node_clicked = intersection.collider
#		match _active_spell:
#			null:
#				return
#			spell_ids_bucket.TOGGLE_GATE:
#				if node_clicked is Gate and not Input.get_action_strength("move"):
#					_hud.on_spell_started()
#					_active_spell = null
#					player_a_movement.move_to_gate(node_clicked)
#			spell_ids_bucket.USE_ELEVATOR:
#				if node_clicked is Elevator and not Input.get_action_strength("move"):
#					_hud.on_spell_started()
#					_active_spell = null
#					player_a_movement.move_to_elevator(node_clicked)
#			spell_ids_bucket.MOVE_TO:
#				if intersection.position:
#					_hud.on_spell_started()
#					_active_spell = null
#					var target_move_global_position = intersection.position
#					player_a_movement.move_to(target_move_global_position)
