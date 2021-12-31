extends Spatial


func play_idle(_dummy = null):
	$AnimationPlayer.play("Idle")
	
	
func play_running():
	$AnimationPlayer.play("Run")
