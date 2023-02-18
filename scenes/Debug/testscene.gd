extends Node2D

var BaseRessource := preload("res://scenes/Ressources/BaseRessource.tscn")

var _new_RessLib := preload("res://scripts/Libraries/RessLib.gd").new()

func _ready() -> void:
	randomize()
	for i in range(5):
		create_res(_new_RessLib.Rock, Vector2(16 * i + 64, 16))
	
	for i in range(5):
		create_res(_new_RessLib.Bush, Vector2(16 * i + 64, 64))
		
	for i in range(5):
		create_res(_new_RessLib.BigRock, Vector2(32 * i + 64, 128))
	
func create_res(object: Dictionary, pos: Vector2) -> void:
	var new_ress = BaseRessource.instance()
	$YSort.add_child(new_ress)
	new_ress.init_object(object)
	new_ress.position = pos
	
