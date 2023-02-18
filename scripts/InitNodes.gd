extends Node2D

signal nodes_initiated

onready var ysort: YSort = get_parent().get_node("YSort")

var Player := preload("res://scenes/Player.tscn")
var Fox := preload("res://scenes/Fox.tscn")
var FloorTM := preload("res://scenes/TileMaps/FloorTM.tscn")


func _ready() -> void:
	var WorldGen: Node2D = get_parent().get_node("WorldGen")
	connect("nodes_initiated", WorldGen, "_on_Nodes_initiated")
	
	NodesLib.ysort = YSort.new()
	NodesLib.floor_tm = _init_tm()
	NodesLib.player = _init_player()
	NodesLib.fox = _init_fox()
	_init_noises()
	
	emit_signal("nodes_initiated")


func _init_noises() -> void:
	print("\n	-Noises initialisations...")
	
	NodesLib.ground_noise = _create_noise(randi(), 4, 3.0, 0.25, 256.0)
	NodesLib.ore_noise = _create_noise(randi(), 2, 2.0, 0.5, 12.0)
	NodesLib.forest_noise = _create_noise(randi(), 2, 1.0, 0.5, 80.0)
	NodesLib.details_noise = _create_noise(randi(), 2, 0.0, 0.0, 2.0)
	
	print("	-Noises initialized !\n")
	
	
func _init_tm() -> TileMap:
	var floor_tm = FloorTM.instance()
	ysort.add_child(floor_tm)
	return floor_tm
	

func _init_player() -> KinematicBody2D:
	var player = Player.instance()
	player.position = Vector2(128, 128)
	ysort.add_child(player)
	
	return player
	

func _init_fox() -> KinematicBody2D:
	var fox = Fox.instance()
	fox.position = Vector2(128 + 64, 128 + 64)
	ysort.add_child(fox)
	
	return fox


func _create_noise(noise_seed: int, oct: int, lac: float, persi: float, perio: float) -> OpenSimplexNoise:
	var noise = OpenSimplexNoise.new()
	noise.seed = noise_seed
	print("{1}.seed: {0}".format([noise.seed, noise]))
	noise.octaves = oct
	noise.lacunarity = lac
	noise.persistence = persi
	noise.period = perio
	
	return noise
