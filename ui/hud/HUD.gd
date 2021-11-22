extends Control


signal function_selected(function_id)

signal function_started
signal function_done


func _ready():
	connect("function_started", self, "_on_function_started")
	connect("function_done", self, "_on_function_done")


func _on_function_started():
	$SpellPanel/SpellsList._on_function_started()


func _on_function_done():
	$SpellPanel/SpellsList._on_function_done()


func _on_spell_selected(new_spell):
	emit_signal("function_selected", 0)
