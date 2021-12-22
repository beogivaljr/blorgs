extends Node

signal touch_began(event)
signal touch_ended(event)
signal clicked(event, intersection)
signal dragged(event)

var _is_dragging = false
var _ar_mode_on = false


func _ready():
	ScreenOrientation.connect("screen_orientation_changed", self, "_on_screen_orientation_changed")


func _unhandled_input(event):
	if (
		event is InputEventScreenTouch and event.is_pressed()
		or event.is_action_pressed("click")
		):
			emit_signal("touch_began", event)
			_is_dragging = false
	elif (
		event is InputEventScreenTouch
		or event.is_action_released("click")
	):
		emit_signal("touch_ended", event)
		if not _is_dragging:
			var parent = (get_parent() as Spatial)
			var space_state = parent.get_world().direct_space_state
			var target_input_position = event.position
			
			# Very nasty fix for AR ray cast
			if _ar_mode_on:
				var ar_offset = Vector2(180, 330)
				target_input_position = (event.position - ar_offset) * 2.0
			
			var camera = get_viewport().get_camera()
			var ray_start = camera.project_ray_origin(target_input_position)
			var ray_end = ray_start + camera.project_ray_normal(target_input_position) * 200
			var intersection = space_state.intersect_ray(ray_start, ray_end)
			emit_signal("clicked", event, intersection)
	elif event is InputEventScreenDrag:
		_is_dragging = true
		emit_signal("dragged", event)


func _on_screen_orientation_changed(new_orientation):
	match new_orientation:
		ScreenOrientation.LANDSCAPE:
			_ar_mode_on = false
		ScreenOrientation.PORTRAIT:
			_ar_mode_on = true
