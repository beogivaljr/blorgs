extends Control

signal on_move_selected
signal on_hold_selected
signal on_jump_selected

# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuButton.get_popup().add_item("blorgs()") # Hold
	$MenuButton.get_popup().add_item("foo(baz)") # Move
	$MenuButton.get_popup().add_item("shureuns(bar)") # Jump
	
	$MenuButton.get_popup().connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(id):
	match id:
		0:
			emit_signal("on_hold_selected")
		1:
			emit_signal("on_move_selected")
		2:
			emit_signal("on_jump_selected")
