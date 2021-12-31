class_name Player
extends BaseCharacter


func setup(navigation: Navigation, type):
	.setup(navigation, type)
	var player_skeleton
	match(type):
		GameState._CHARACTER_TYPES.A:
			player_skeleton = preload("res://players/PlayerSkeletonA.tscn").instance()
			add_child(player_skeleton)
		GameState._CHARACTER_TYPES.B:
			player_skeleton = preload("res://players/PlayerSkeletonB.tscn").instance()
			add_child(player_skeleton)
	_kinematic_movement.connect("started_movement", player_skeleton, "play_running")
	_kinematic_movement.connect("succeded_movement", player_skeleton, "play_idle")
	_kinematic_movement.connect("failed_movement", player_skeleton, "play_idle")
	_kinematic_movement.connect("reached_target", player_skeleton, "play_idle")
