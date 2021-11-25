extends BaseLevel


func _ready():
	var spells = GameState.get_spells()
	_setup_hud(spells)
#	ServerConnection.send_spawn(spells)


func _setup_hud(spells):
	$HUDSandbox.setup(spells)


func _on_HUDSandbox_player_ready(_spells):
	emit_signal("level_finished")
