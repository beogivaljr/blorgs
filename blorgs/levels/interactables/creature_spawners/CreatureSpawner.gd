class_name CreatureSpawner
extends StaticBody

signal received_spawn_command(creature_spawner)

func _ready():
	emit_signal("received_spawn_command", self)
	
