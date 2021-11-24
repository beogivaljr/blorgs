extends Label


var function_name
var parameter_name

func _ready():
	update_name($"../..".function_name, $"../..".parameter_name )


func _on_RenameFnButton_button_renamed(new_name):
	update_name(new_name, parameter_name)


func _on_RenamParamButton_button_renamed(new_name):
	update_name(function_name, new_name)


func update_name(function_name, parameter_name):
	var spell_name = {
		function_name = function_name,
		parameter_name = parameter_name,
	}
	
	self.function_name = function_name
	self.parameter_name = parameter_name
	$"../..".spell_name = spell_name
	
	set_text(function_name + "(" + parameter_name + ")")