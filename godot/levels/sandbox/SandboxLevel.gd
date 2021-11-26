extends BaseLevel


func _ready():
	ServerConnection.send_spawn()
	ServerConnection.connect("player_spells_updated", self, "_setup_hud")
	ServerConnection.request_player_spells()


func _setup_hud(spells):
	$HUDSandbox.setup(spells)


func _on_HUDSandbox_player_ready(_spells):
	emit_signal("level_finished")
