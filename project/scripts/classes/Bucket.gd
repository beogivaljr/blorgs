extends Object
class_name Bucket, "res://icon.png"

"""
Bucket is the root object in hierarchy while dealing
with custom functions — that high-level ones created
by Player during Sandbox mode.

	Bucket
		⮡⮡↳ Function[]
			↳ Step[]
				↳ Method ie. base function
				↳ Parameter
"""

const FILE_PATH = "user://functions.save"
var functions:= []


"""
Creates a new function with specified name
and append it to custom functions list.
"""
func new_function(name: String) -> Function:
	var function = Function.new(name)
	functions.append(function)
	return function


""" - - - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - SAVE & LOAD - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - - - """

"""
	USEFUL DOCS:
		https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
		https://docs.godotengine.org/en/stable/classes/class_json.html
"""

func save_file() -> bool:
	var file = File.new()
	var error = file.open(FILE_PATH, File.WRITE)
	if error == OK:
		for function in functions:
			file.store_line(function.to_json())
		file.close()
		return true
	else:
		push_error(error)
		return false


func load_file(reload_all:= true) -> bool:
	var file = File.new()
	
	if not file.file_exists(FILE_PATH):
		print_debug("File at %s doesn't exist yet" % FILE_PATH)
		return false
	
	if reload_all: _clear()
	
	var error = file.open(FILE_PATH, File.READ)
	if error == OK:
		while file.get_position() < file.get_len():
			var function = Function.new()
			function.parse_json(file.get_line())
			functions.append(function)
			
		file.close()
		return true
	else:
		push_error(error)
		return false


func delete_file() -> bool:
	var dir = Directory.new()
	var error = dir.remove(FILE_PATH)
	var success = error == OK
	
	if not success:
		push_error(error)
	return success


""" - - - - - - - - - - - - - - - - - - - - - - """
""" - - - - - - - - - HELPERS - - - - - - - - - """
""" - - - - - - - - - - - - - - - - - - - - - - """

"""
Useful for JSON conversions.
"""
func dictionary() -> Dictionary:
	var dict = {
		"functions": []
	}
	for function in functions:
		dict.functions.append(function.dictionary())
	return dict


"""
Override string conversion to allow directly
print of object content as JSON.
"""
func _to_string() -> String:
	return JSON.print(dictionary(), "\t")


"""
Clear current buffer.
"""
func _clear() -> void:
	functions.clear()
