extends Node

var func_data = {
	
}

var equipment_data = {

}
func _ready():
	var inv_data_file = File.new()
	inv_data_file.open("res://Ui/Data/inv_data_file.json", File.READ)
	var inv_data_json = JSON.parse(inv_data_file.get_as_text())
	inv_data_file.close()
	func_data = inv_data_json.result
