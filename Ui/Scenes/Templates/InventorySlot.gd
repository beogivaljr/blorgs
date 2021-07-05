extends TextureRect

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
	var target_function_slot = str(get_parent().get_name())
	#print(target_function_slot)
	#print(PlayerData.func_data[target_function_slot])

	if PlayerData.func_data[target_function_slot]["Item"] == null:
		return true
	else:
		return false
func drop_data(position, data):
	texture = data["origin_texture"]
	PlayerData.func_data.Inv1 = data
	
	#print(PlayerData.func_data)
