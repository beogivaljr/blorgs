extends BaseLevel


func _ready() -> void:
	yield(get_tree().create_timer(3.0), "timeout")
	emit_signal("on_level_finished")
