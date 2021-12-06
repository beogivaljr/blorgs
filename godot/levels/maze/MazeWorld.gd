class_name MazeWorld
extends BaseWorld

signal valid_parameter_selected(spell_id, node_name, location)

func _ready():
	_active_player_id = GlobalConstants.CharacterTypes.A
	_spawn_and_setup_player(_active_player_id)
	_active_player_id = GlobalConstants.CharacterTypes.B
	_spawn_and_setup_player(_active_player_id)


func auto_cast_spell(player_id, spell_id, node_name, location):
	_has_started_auto_casting = true
	_active_player_id = player_id
	$GameCamera.target_to_follow = get_active_character()
	begin_casting_spell(spell_id)
	var node: Node = null
	if has_node(node_name):
		node = get_node(node_name)
	get_active_character()._attempt_to_cast_spell_on_target(node, location)
	_attempt_to_cast_spell_on_target(node, location)


func begin_casting_spell(spell_id):
	.begin_casting_spell(spell_id)
	get_active_character().begin_casting_spell(spell_id)
	if (
			spell_id == GlobalConstants.SpellIds.DESTROY_SUMMON
			and not _has_started_auto_casting
	):
		begin_casting_spell(null)
		emit_signal("valid_parameter_selected", spell_id, "no_param", Vector3.ZERO)


func _spawn_and_setup_player(type):
	var player_spawn_node_name = "PlayerSpawn"
	if type == GlobalConstants.CharacterTypes.A:
		player_spawn_node_name += "A"
	elif type == GlobalConstants.CharacterTypes.B:
		player_spawn_node_name += "B"
	else:
		assert(false)
	var player = preload("res://players/BaseCharacter.tscn").instance()
	player.connect("spell_started", self, "_on_spell_started")
	player.connect("spell_done", self, "_on_spell_done")
	add_child(player)
	player.global_transform = get_node(player_spawn_node_name).global_transform
	if type == GameState.character_type:
		$GameCamera.target_to_follow = player
	player.setup($Navigation, type)
	_players[_active_player_id] = player
	set_active_character(player)


func _validate_parameters(node, location):
	if _has_started_auto_casting:
		return
	var spell = _active_spell_id
	if (
		_is_valid_move_to(spell, location)
		or _is_valid_toggle_gate(spell, node)
		or _is_valid_magic_button(spell, node)
		or _is_valid_use_elevator(spell, node)
		or _is_valid_summon_creature(spell, node)
		):
		begin_casting_spell(null)
		emit_signal("valid_parameter_selected", spell, node.name, location)


func _handle_world_click(_event, intersection):
	if not intersection.empty():
		var node = intersection.collider
		var location = intersection.position
		_validate_parameters(node, location)


func _on_KillYArea_body_entered(body: Node):
	body.queue_free()
	emit_signal("spell_done", false)
