extends Node

signal spell_started(spell_id)
signal spell_done(succeded)
signal spell_list_updated(spell_list)

var _spell_call_list = []

func _ready():
	pass


func on_spell_and_parameter_selected(spell_id, node_name, location):
	var new_spell_call = SpellCallDTO.new(
		GameState.player_type,
		spell_id,
		node_name,
		location
	)
	_spell_call_list.append(new_spell_call)
	emit_signal("spell_started", spell_id)
	call_deferred("emit_signal", "spell_done", true)
	on_spell_call_list_updated(_spell_call_list)


func on_spell_call_list_updated(spell_call_list):
	# Create the list maping all SpellCallDTO to SpellDTO
	var spell_list = []
	var available_spells = GameState.get_all_spells()
	for spell_call in spell_call_list:
		var spell_id = (spell_call as SpellCallDTO).spell_id
		for spell in available_spells:
			if (spell as SpellDTO).spell_id == spell_id:
				spell_list.append(spell)
				break
	emit_signal("spell_list_updated", spell_list)


func send_ready_and_spell_call_list():
	ServerConnection.request_start_simulation(_spell_call_list)


func start_simulation(spell_call_list, world: MazeWorld):
	emit_signal("spell_started")
	for spell in spell_call_list:
		var spell_call_dto = (spell as SpellCallDTO)
		var player_id = spell_call_dto.player_type
		var spell_id = spell_call_dto.spell_id
		var node_name = spell_call_dto.target_parameter_node_name
		var location = spell_call_dto.target_parameter_location
		world.auto_cast_spell(player_id, spell_id, node_name, location)
		yield(self, "spell_done")
	emit_signal("spell_done")


func on_undo_pressed():
	_spell_call_list.pop_back()
	on_spell_call_list_updated(_spell_call_list)