extends Node


var item_data: Dictionary

var cdb_data: Dictionary = {}

func _ready():
#	item_data = load_data("res://data/ItemData.json")
	item_data = load_cdb_data()


func load_data(file_path: String):
	var json_data
	var file_data = File.new()
	
	file_data.open(file_path, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	
	return json_data.result

func load_cdb_data() -> Dictionary:
	var data_cdb
	var file_data = File.new()
	
	file_data.open("res://data/new.cdb", File.READ)
	data_cdb = parse_json(file_data.get_as_text())
	file_data.close()
	
	for sheet in data_cdb["sheets"]:
		if sheet["name"] == "ItemData":
			var sorted_dict: Dictionary = {}
			for entry in sheet["lines"]:
				var new_entry = entry.duplicate()
				
				new_entry["StackSize"] = int(new_entry["StackSize"])
				
				new_entry.erase("ItemName")
				
				if entry["ItemCategory"] == 0:
					new_entry["ItemCategory"] = "Ressource" 
				elif entry["ItemCategory"] == 1:
					new_entry["ItemCategory"] = "Tool"
				elif entry["ItemCategory"] == 3:
					new_entry["ItemCategory"] = "Consumable"
				elif entry["ItemCategory"] == 4:
					new_entry["ItemCategory"] = "Build"
						
				sorted_dict[ entry["ItemName"] ] = new_entry
				
				
			return sorted_dict
	return {}
				
				
				
				
				
