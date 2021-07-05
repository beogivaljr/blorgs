extends TextureRect
signal hideGUI

func get_drag_data(position):
	var minion_slot = get_parent().get_name()
	if PlayerData.func_data[minion_slot]["Item"] != null:
		var data = {}
		data["origin_texture"] = texture
		data["origin_function"] = get_parent().get_name()
		data["origin_node"] = self
		
		var drag_texture = TextureRect.new()
		drag_texture.expand = true
		drag_texture.texture = texture
		drag_texture.rect_size = Vector2(100, 100)
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.rect_position = -0.5 * drag_texture.rect_size
		set_drag_preview(control)
		
		return data
	
func can_drop_data(position, data):
	if data.origin_function == "Jump" or data.origin_function == "Move":
		return true

func drop_data(position, data):
	texture = data["origin_texture"]
	var target_function_slot = str(get_parent().get_name())
	
	if data.origin_function == "Jump" or data.origin_function == "Move":
		PlayerData.func_data[target_function_slot]["Item"] = data["origin_function"]
		PlayerData.func_data[target_function_slot]["Params"] = data["origin_params"]
		print(PlayerData.func_data)
	#emit_signal("hideGUI")


	
