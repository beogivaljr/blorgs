extends Control

var template_inv_slot = preload("res://Ui/Scenes/Templates/InventorySlot.tscn")

onready var gridcontainer = get_node("Background/VBoxContainer/HBoxContainer/MinionFuncs")

func _ready():
	for i in PlayerData.func_data.keys():
		var  inv_slot_new = template_inv_slot.instance()
		if PlayerData.func_data[i]["Item"] != null:
			var item_name = GameData.item_data[str(PlayerData.func_data[i]["Item"])]["Name"]
			var icon_texture = load("res://Ui/Assets/item.png")
			print(icon_texture)
			inv_slot_new.get_node("Icon").set_texture(icon_texture)
		gridcontainer.add_child(inv_slot_new, true)
