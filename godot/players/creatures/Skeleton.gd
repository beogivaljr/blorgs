extends Spatial


signal spawn_animation_finished


func play_idle(_dummy = null):
	$AnimationPlayer.play("Skeleton_Idle")
	
	
func play_running():
	$AnimationPlayer.play("Skeleton_Running")
	
	
func play_attack():
	$AnimationPlayer.play("Skeleton_Attack")
	
	
func play_death():
	$AnimationPlayer.play("Skeleton_Death")
	
	
func play_spawn():
	$AnimationPlayer.play("Skeleton_Spawn", -1, 2.5)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Skeleton_Spawn":
		play_idle()
		emit_signal("spawn_animation_finished")
