extends Object
class_name Bucket, "res://icon.png"

const FILE_PATH = "user://functions.save"
var functions = []


func new_function(name: String):
	functions.append(Function.new(name))


func clear():
	functions.clear()


"""
	USEFUL DOCS:
		https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
		https://docs.godotengine.org/en/stable/classes/class_json.html
"""

func save_to_file():
	var file = File.new()
	file.open(FILE_PATH, File.WRITE)
	
	for function in functions:
		file.store_line(function.to_json())
		
	file.close()


func load_from_file():
	var file = File.new()
	
	if file.file_exists(FILE_PATH):
		file.open(FILE_PATH, File.READ)
		
		while file.get_position() < file.get_len():
			var new_function = Function.new()
			new_function.parse_json(file.get_line())
			functions.append(new_function)
			
		file.close()
	else:
		print_debug("File %s doesn't exist yet" % FILE_PATH)


func dictionary():
	var dict = {
		"functions": []
	}
	for function in functions:
		dict.functions.append(function.dictionary())
	return dict


# Override string conversion to allow directly print of object content.
func _to_string():
	return JSON.print(dictionary(), "\t")
