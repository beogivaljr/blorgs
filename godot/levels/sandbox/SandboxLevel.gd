extends BaseLevel


func _ready():
	ServerConnection.send_spawn()
	_setup_hud(GameState.get_spells())


func _setup_hud(spells):
	$HUDSandbox.setup(spells)


func _on_HUDSandbox_player_ready(_spells):
	emit_signal("level_finished")
