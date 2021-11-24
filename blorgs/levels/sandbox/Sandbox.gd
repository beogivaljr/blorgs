extends BaseLevel

## Script inherited from Base Level because it will contain some common 
## behaviour, like the signal "on_level_finished" for instance.
## This will be very handy because the Level Manager won't have to know
## exactly which level it is managing.

var _hud = preload("res://ui/hud/sandbox/HUDSandbox.tscn").instance()
var _active_spell = null


func _ready() -> void:
	$PlayerA.setup($Navigation)
	player_input_handler.connect("on_clicked", self, "_handle_player_click")
	_setup_hud()
	_bind_interactables()
	## Just an example of how to call level finish for the Level Manager to
	## take care of it.
#	emit_signal("on_level_finished")


func _setup_hud():
	_hud.setup(_get_spell_ids_list())
	_hud.connect("spell_selected", self, "_set_active_spell")
	add_child(_hud)


func _bind_interactables():
	## Finad all direct children of interactable class
	var direct_children = self.get_children()
	var player_a_movement = $PlayerA/KinematicMovement
	player_a_movement.connect("on_failed_movement", _hud, "on_spell_done",  [false])
	player_a_movement.connect("on_succeded_movement", _hud, "on_spell_done")
	for child in direct_children:
		if child is Gate:
			player_a_movement.connect("on_reached_gate", child, "toggle_raise_lower")
			child.connect("on_interaction_done", _hud, "on_spell_done")
		elif child is Elevator:
			player_a_movement.connect("on_reached_elevator", child, "transport")
			child.connect("on_interaction_done", _hud, "on_spell_done")


func _get_spell_ids_list():
	var spells_bucket = GlobalConstants.SpellIds
	var spells =  [spells_bucket.MOVE_TO, spells_bucket.USE_ELEVATOR, spells_bucket.TOGGLE_GATE]
	randomize()
	spells.shuffle()
	return spells


func _set_active_spell(spell_id):
	_active_spell = spell_id


func _handle_player_click(_event, intersection):
	var spell_ids_bucket = GlobalConstants.SpellIds
	var player_a_movement = $PlayerA/KinematicMovement
	if not intersection.empty():
		var node_clicked = intersection.collider
		match _active_spell:
			null:
				return
			spell_ids_bucket.TOGGLE_GATE:
				if node_clicked is Gate and not Input.get_action_strength("move"):
					_hud.on_spell_started()
					_active_spell = null
					player_a_movement.move_to_gate(node_clicked)
			spell_ids_bucket.USE_ELEVATOR:
				if node_clicked is Elevator and not Input.get_action_strength("move"):
					_hud.on_spell_started()
					_active_spell = null
					player_a_movement.move_to_elevator(node_clicked)
			spell_ids_bucket.MOVE_TO:
				if intersection.position:
					_hud.on_spell_started()
					_active_spell = null
					var target_move_global_position = intersection.position
					player_a_movement.move_to(target_move_global_position)
