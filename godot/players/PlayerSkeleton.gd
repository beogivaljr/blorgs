extends Spatial


func play_idle():
	$AnimationPlayer.play("Idle")
	
	
func play_running():
	$AnimationPlayer.play("Run")
