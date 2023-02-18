extends Node2D

onready var ysort = $YSort
var BaseRessource := preload("res://scenes/Ressources/BaseRessource.tscn")

var _new_RessLib := preload("res://scripts/Libraries/RessLib.gd").new()

func _ready() -> void:
	var new_ress = BaseRessource.instance()
	ysort.add_child(new_ress)
	new_ress.init_object(_new_RessLib.Rock)
	new_ress.position = Vector2(16, 16)
	
