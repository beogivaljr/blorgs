class_name MazeWorld
extends BaseWorld

signal valid_parameter_selected(spell_id, node_name, location)

var _has_started_simulation = false


func _ready():
	_active_player_id = GameState.player_type
	_spawn_and_setup_player()


func auto_cast_spell(player_id, spell_id, node_name, location):
	_active_player_id = player_id
	begin_casting_spell(spell_id)
	var node = get_node(node_name)
	get_active_character()._attempt_to_cast_spell_on_target(node, location)
	_attempt_to_cast_spell_on_target(node, location)


func begin_casting_spell(spell_id):
	.begin_casting_spell(spell_id)
#	get_active_character().begin_casting_spell(spell_id)


func _spawn_and_setup_player():
	var player = preload("res://players/BaseCharacter.tscn").instance()
#	player.connect("spell_started", self, "_on_spell_started")
#	player.connect("spell_done", self, "_on_spell_done")
#	add_child(player)
#	player.global_transform = $PlayerSpawn.global_transform
#	player.setup($Navigation)
#	_players[_active_player_id] = player
#	set_active_character(player)


func _validate_parameters(node, location):
	var spell = _active_spell_id
	if (
		_is_valid_move_to(spell, location)
		or _is_valid_toggle_gate(spell, node)
		or _is_valid_magic_button(spell, node)
		or _is_valid_use_elevator(spell, node)
		or _is_valid_summon_creature(spell, node)
		or _is_valid_destroy_summon(spell)
		):
		emit_signal("valid_parameter_selected", spell, node.name, location)


func _handle_world_click(_event, intersection):
	if not intersection.empty():
		var node = intersection.collider
		var location = intersection.position
		_validate_parameters(node, location)
