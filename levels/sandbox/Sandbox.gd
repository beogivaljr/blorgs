extends BaseLevel

## Script inherited from Base Level because it will contain some common 
## behaviour, like the signal "on_level_finished" for instance.
## This will be very handy because the Level Manager won't have to know
## exactly which level it is managing.

## Example use of "on_level_finished" signal
func _ready() -> void:
	$PlayerA.setup($Navigation)
	player_input_handler.connect("on_clicked", self, "_handle_player_click")
	
	## Just an example of how to call level finish for the Level Manager to
	## take care of it.
#	emit_signal("on_level_finished")


func _handle_player_click(_event, intersection):
	if not intersection.empty():
		var node_clicked = intersection.collider
		var player_a_movement = $PlayerA/KinematicMovement
		if node_clicked is Gate and not Input.get_action_strength("move"):
			player_a_movement.connect("on_reached_gate", node_clicked, "toggle_raise_lower", [], CONNECT_ONESHOT)
			if not player_a_movement.is_connected("on_failed_movement", player_a_movement, "disconnect"):
				player_a_movement.connect("on_failed_movement", player_a_movement, "disconnect", ["on_reached_gate", node_clicked, "toggle_raise_lower"], CONNECT_ONESHOT)
			player_a_movement.move_to_gate(node_clicked)
		elif node_clicked is Platform and not Input.get_action_strength("move"):
			player_a_movement.connect("on_reached_platform", node_clicked, "raise_platform", [], CONNECT_ONESHOT)
			if not player_a_movement.is_connected("on_failed_movement", player_a_movement, "disconnect"):
				player_a_movement.connect("on_failed_movement", player_a_movement, "disconnect", ["on_reached_platform", node_clicked, "raise_platform"], CONNECT_ONESHOT)
			player_a_movement.move_to_platform(node_clicked)
		else:
			var target_move_global_position = intersection.position
			player_a_movement.move_to(target_move_global_position)
