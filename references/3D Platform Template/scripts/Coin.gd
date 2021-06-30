extends Area

signal cn_collected

func _ready():
	pass

func _physics_process(delta):
	rotate_y(deg2rad(3))



func _on_Coin_body_entered(body):
	if body.name=="KineBall":
		set_collision_mask_bit(0,false)
		emit_signal("cn_collected")
		$coinanim.play("coinanim")
		$coinkiller.start()
		
	

func _on_coinkiller_timeout():
	queue_free()
