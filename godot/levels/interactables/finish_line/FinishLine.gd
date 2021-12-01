class_name FinishLine
extends Spatial

signal player_entered_finish_line
signal player_exited_finish_line

export(GameState.CharacterTypes) var character_type


func _ready():
	match character_type:
		GameState.CharacterTypes.A:
			$OmniLightA.visible = true
			$OmniLightB.visible = false
		GameState.CharacterTypes.B:
			$OmniLightA.visible = false
			$OmniLightB.visible = true


func _on_Area_body_entered(body):
	if _body_is_right_player(body):
		$AnimationPlayer.play("OpenClose")
		emit_signal("player_entered_finish_line")


func _on_Area_body_exited(body):
	if _on_Area_body_exited(body):
		$AnimationPlayer.play_backwards("OpenClose")
		emit_signal("player_exited_finish_line")


func _body_is_right_player(body: Node):
	return body is BaseCharacter and body.character_type == character_type