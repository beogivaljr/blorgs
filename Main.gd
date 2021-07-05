extends Node

func _input(event):
	if event.is_action_pressed("GUI"):
		get_node("GUI").show()
	if event.is_action_pressed("ui_cancel"):
		get_node("GUI").hide()


		
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Fechar_button_down():
	get_node("GUI").hide()

func _on_GenerateMinion_button_down():
	print (PlayerData.func_data)
	# laço juntar funcoes
	for function in PlayerData.func_data:
		if PlayerData.func_data[function].Item == "Jump":
			owner.get_node("GameManager").__TEST_move_relative()
		if PlayerData.func_data[function].Item == "Move":
			owner.get_node("GameManager").__TEST_move_forward()


	get_node("GUI").hide()
	pass # Replace with function body.


		
