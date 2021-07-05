extends Control

var template_inv_slot = preload("res://Ui/Scenes/Templates/InventorySlot.tscn")

onready var gridcontainer = get_node("Background/VBoxContainer/HBoxContainer/MinionFuncs")
onready var camera: Camera = get_viewport().get_camera()

func _ready():
	for i in PlayerData.func_data.keys():
		var  inv_slot_new = template_inv_slot.instance()
		if PlayerData.func_data[i]["Item"] != null:
			var item_name = GameData.item_data[str(PlayerData.func_data[i]["Item"])]["Name"]
			var icon_texture = load("res://Ui/Assets/item.png")
			inv_slot_new.get_node("Icon").set_texture(icon_texture)
		gridcontainer.add_child(inv_slot_new, true)
		

		inv_slot_new.get_node("Icon").connect("hideGUI", self, "hideUI")

func hideUI():
	owner.get_node("GUI").hide()
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		var space_state = camera.get_world().direct_space_state
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000	
		var intersection = space_state.intersect_ray(from, to)
		if !intersection.empty():
			var target_pont = intersection.position



func _on_CleanFunctions_button_down():
	for i in gridcontainer.get_children():
		i.free()
	for i in PlayerData.func_data.keys():
		var  inv_slot_new = template_inv_slot.instance()
		PlayerData.func_data[i] = {"Item": null} 
		gridcontainer.add_child(inv_slot_new, true)

	
