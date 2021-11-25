extends BaseLevel


func _ready():
	_setup_hud()


func _setup_hud():
	$HUDSandbox.setup(_get_spell_ids_list())


func _get_spell_ids_list():
	var spells_bucket = GlobalConstants.SpellIds
	var spells =  [spells_bucket.MOVE_TO, spells_bucket.USE_ELEVATOR, spells_bucket.TOGGLE_GATE]
	randomize()
	spells.shuffle()
	return spells


func _on_HUDSandbox_player_ready(_spells):
	emit_signal("level_finished")
