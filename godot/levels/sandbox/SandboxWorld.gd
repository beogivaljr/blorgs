extends BaseWorld
## Script inherited from Base World because it will contain some common
## This will be very handy because the Level Manager won't have to know
## exactly which level it is managing.

var _spell_consumed = true

func _ready() -> void:
	_active_player_id = GameState.character_type
	_spawn_and_setup_player()


func _spawn_and_setup_player():
	var player = preload("res://players/BaseCharacter.tscn").instance()
	player.connect("spell_started", self, "_on_spell_started")
	player.connect("spell_done", self, "_on_spell_done")
	add_child(player)
	player.global_transform = $PlayerSpawn.global_transform
	player.setup($Navigation, GameState.character_type)
	$GameCamera.target_to_follow = player
	_players[_active_player_id] = player
	set_active_character(player)


func begin_casting_spell(spell_id):
	_spell_consumed = false
	.begin_casting_spell(spell_id)
	get_active_character().begin_casting_spell(spell_id)


func _on_spell_started(spell_id):
	._on_spell_started(spell_id)
	_spell_consumed = true


func _handle_world_click(_event, intersection):
	if not intersection.empty() and not _spell_consumed:
		var node = intersection.collider
		var location = intersection.position
		get_active_character()._attempt_to_cast_spell_on_target(node, location)
		._attempt_to_cast_spell_on_target(node, location)


func _on_KillYArea_body_entered(body: Node):
	if body is Creature:
		if body == get_active_character():
			_spawn_and_setup_creature(body.spawner)
	elif body is BaseCharacter:
		_spawn_and_setup_player()
	body.queue_free()
	emit_signal("spell_done", false)
