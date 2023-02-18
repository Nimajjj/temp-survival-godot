extends Node2D


var DgPointeur := preload("res://scenes/Debug/DebugPointeur.tscn")

var Ore := preload("res://scenes/Ressources/Ore.tscn")
var BaseRessource := preload("res://scenes/Ressources/BaseRessource.tscn")
var BaseTree := preload("res://scenes/Ressources/BaseTree.tscn")

var _new_Sizes := preload("res://scripts/Libraries/Sizes.gd").new()
var _new_RessLib := preload("res://scripts/Libraries/RessLib.gd").new()
var _new_TreeLib := preload("res://scripts/Libraries/TreeLib.gd").new()

const CHUNK_SIZE: int = 32	# Chunk size: 32*32
const CHUNK_DIST: int = 1
const CHUNK_START_DIST: int = 2

var ground_noise: OpenSimplexNoise
var ore_noise: OpenSimplexNoise
var forest_noise: OpenSimplexNoise
var details_noise: OpenSimplexNoise

var floor_tm: TileMap

var loaded_chunk: Array = []
var unloaded_chunk: Array = []
var chunk_data: Dictionary = {}

var player: KinematicBody2D
var fox: KinematicBody2D


# _ready & _process ----------------------------------

func _ready() -> void:
	NodesLib.world_gen = self
	randomize()
	

func _process(_delta) -> void:
	var chunk_center: Vector2 = get_chunk_center()
	
	var columnStart: int = chunk_center.x - (CHUNK_SIZE * CHUNK_DIST)
	var columnEnd: int = chunk_center.x + (CHUNK_SIZE * (CHUNK_DIST + 1) )
	var rowStart: int = chunk_center.y - (CHUNK_SIZE * CHUNK_DIST)
	var rowEnd: int = chunk_center.y + (CHUNK_SIZE * (CHUNK_DIST + 1) )
	
	for x in range(columnStart, columnEnd, CHUNK_SIZE ):
		for y in range(rowStart, rowEnd, CHUNK_SIZE ):	
			
			var new_chunk_center = Vector2(x, y)
			
			if loaded_chunk.has(new_chunk_center):
				continue
				
			elif unloaded_chunk.has(new_chunk_center):
				load_chunk(new_chunk_center)
				continue
				
			else:
				_create_chunk(new_chunk_center)
				if -1 in chunk_data[new_chunk_center]["count_floor"]:
					_update_chunk_data(new_chunk_center)

	for chunk in loaded_chunk:
		if chunk.x < columnStart - CHUNK_SIZE or chunk.x > columnEnd:
			unload_chunk(chunk)
		elif chunk.y < rowStart - CHUNK_SIZE or chunk.y > rowEnd:
			unload_chunk(chunk)


# main ----------------------------------------------

func _create_chunk(chunk_center: Vector2) -> void:
	var columnStart: int = chunk_center.x - (CHUNK_SIZE / 2)
	var columnEnd: int = chunk_center.x + (CHUNK_SIZE / 2)
	var rowStart: int = chunk_center.y - (CHUNK_SIZE / 2)
	var rowEnd: int = chunk_center.y + (CHUNK_SIZE / 2)
	
	
	for x in range(columnStart,columnEnd):	# generate main terrain
		for y in range(rowStart,rowEnd):
			var a = noise_at(ground_noise, x, y)
				
			if a < ConstLib.WATER_CAP:
				floor_tm.set_cell(x, y, ConstLib.WATER)
			elif between(a, ConstLib.WATER_CAP, ConstLib.SAND_CAP):
				floor_tm.set_cell(x, y, ConstLib.SAND)
			elif between(a, ConstLib.SAND_CAP, ConstLib.DIRT_CAP):
				floor_tm.set_cell(x, y, ConstLib.DIRT)
			elif between(a, ConstLib.DIRT_CAP, ConstLib.ROCK_CAP):
				floor_tm.set_cell(x, y, ConstLib.STONE)
				
	floor_tm.update_bitmask_region(Vector2(columnStart, rowStart), Vector2(columnEnd, rowEnd))
	
	_create_chunk_data(chunk_center)
	
	_create_wall(chunk_center)						
	
	for x in range(columnStart,columnEnd):	# generate trees
		for y in range(rowStart,rowEnd):
			var a = noise_at(forest_noise, x, y)
			var r = a * 300
			if a > ConstLib.FOREST_CAP:
				var placeable: bool = true
				for xx in range(x - 1, x + 1 ):
					for yy in range(y - 1, y + 1 ):
						if not floor_tm.get_cell(xx, yy) == ConstLib.DIRT:
							placeable = false
							break
					if not placeable:
						break
				if not placeable:
					continue
				
				if not "tree" in chunk_data[chunk_center]["env_list"]:
					chunk_data[chunk_center]["env_list"]["tree"] = []
				
				if (randi() % (200000 + int(ConstLib.FOREST_CAP * 10) ) ) < r :
					var i: int = randi() % _new_TreeLib.TREES_DATA.size()
					var tree = BaseTree.instance() 
					tree.position = floor_tm.map_to_world(Vector2(x, y))
					tree.object = _new_TreeLib.TREES_DATA[i]
					NodesLib.ysort.add_child(tree)
					chunk_data[chunk_center]["env_list"]["tree"].append([i, tree.position])
					
	for x in range(columnStart,columnEnd):	# generate flowers
		for y in range(rowStart,rowEnd):
			var a = noise_at(details_noise, x, y)
			if a > ConstLib.FLOWER_CAP and floor_tm.get_cell(x, y) == ConstLib.DIRT:
				if randi() % 20 == 0:
					var new_env = BaseRessource.instance()		
					new_env.object = _new_RessLib.Flower
					new_env.position = floor_tm.map_to_world(Vector2(x, y))
					NodesLib.ysort.add_child(new_env)
					
					if not "Flower" in chunk_data[chunk_center]["env_list"]:
						chunk_data[chunk_center]["env_list"]["Flower"] = []
					chunk_data[chunk_center]["env_list"]["Flower"].append(floor_tm.map_to_world(Vector2(x, y) ) )
				
	var biome: String = _define_biome(chunk_center)

	var max_env: int = 8	# generate ressources
	for x in range(columnStart,columnEnd):
		if max_env <= 0:
			break
		for y in range(rowStart,rowEnd):
			if max_env <= 0:
				break
			
			for object in _new_RessLib.ENVS:
				if object["name"] == "Flower":
					continue
					
				if ( randi() % (10024 * _new_RessLib.ENVS.size() ) ) > object["spawn_rate"]:
					continue
					
				if not biome in object["biome"]:
					continue
				
				var placeable: bool = true
				for xx in range(x - (1 + object["tile_size"]), x + (1 + object["tile_size"]) ):
					for yy in range(y - (1 + object["tile_size"]), y + (1 + object["tile_size"]) ):
						if not floor_tm.get_cell(xx, yy) in object["placeable"]:
							placeable = false
					if not placeable:
							break
				if not placeable:
					continue
				
				var new_env = BaseRessource.instance()		
				new_env.object = object
				new_env.position = floor_tm.map_to_world(Vector2(x, y))
				NodesLib.ysort.add_child(new_env)
				max_env -= 1
				
				if not object["name"] in chunk_data[chunk_center]["env_list"]:
					chunk_data[chunk_center]["env_list"][object["name"]] = []
				chunk_data[chunk_center]["env_list"][object["name"]].append(floor_tm.map_to_world(Vector2(x, y) ) )
				break
					
#	_set_biome_color(chunk_center)


func _create_chunk_data(chunk_center: Vector2) -> void:
	loaded_chunk.append(chunk_center)
	chunk_data[chunk_center] = {"count_floor": {}, "env_list": {}, "biome": ""}
	
	for x in range(chunk_center.x - CHUNK_SIZE/2, chunk_center.x + CHUNK_SIZE/2):
		for y in range(chunk_center.y - CHUNK_SIZE/2, chunk_center.y + CHUNK_SIZE/2):
			var _tile: int = floor_tm.get_cell(x, y)
			if not _tile in chunk_data[chunk_center]["count_floor"]:
				chunk_data[chunk_center]["count_floor"][_tile] = 1
			else:
				chunk_data[chunk_center]["count_floor"][_tile] += 1
				
				
func _set_biome_color(chunk_center: Vector2) -> void:
	match chunk_data[chunk_center]["biome"]:
		"Mountain":
			ConstLib.debug_overlay.add_chunk_rect(chunk_center, ConstLib.MOUNTAIN_COLOR)
		"Forest":
			ConstLib.debug_overlay.add_chunk_rect(chunk_center, ConstLib.FOREST_COLOR)
		"River":
			ConstLib.debug_overlay.add_chunk_rect(chunk_center, ConstLib.RIVER_COLOR)
		"Plain":
			ConstLib.debug_overlay.add_chunk_rect(chunk_center, ConstLib.PLAIN_COLOR)
		"Flowered Mountain":
			ConstLib.debug_overlay.add_chunk_rect(chunk_center, ConstLib.FLOWERED_MOUNTAIN_COLOR)
		"Flowered Forest":
			ConstLib.debug_overlay.add_chunk_rect(chunk_center, ConstLib.FLOWERED_FOREST_COLOR)
		"Flowered River":
			ConstLib.debug_overlay.add_chunk_rect(chunk_center, ConstLib.FLOWERED_RIVER_COLOR)
		"Flowered Plain":
			ConstLib.debug_overlay.add_chunk_rect(chunk_center, ConstLib.FLOWERED_PLAIN_COLOR)


func _define_biome(chunk_center: Vector2) -> String:
	# Define biome's prefix
	var prefix: String = ""
#	if has_env(chunk_center, "flower") >= 15:
#		prefix = "Flowered "
	
	# Define biome
	if has_env(chunk_center, "tree") > 25:
		chunk_data[chunk_center]["biome"] = prefix + "Forest"
		return chunk_data[chunk_center]["biome"]
	
	elif has_tile(chunk_center, ConstLib.WATER) > 75:
		chunk_data[chunk_center]["biome"] = prefix + "River"
		return chunk_data[chunk_center]["biome"]
			
	elif has_tile(chunk_center, ConstLib.STONE) > 75:
		chunk_data[chunk_center]["biome"] = prefix + "Mountain"
		return chunk_data[chunk_center]["biome"]
	
	chunk_data[chunk_center]["biome"] = prefix + "Plain"	# Default biome
	return chunk_data[chunk_center]["biome"]
	

func _update_chunk_data(chunk: Vector2) -> void:
	var data: Dictionary = {}
	for x in range(chunk.x - CHUNK_SIZE/2, chunk.x + CHUNK_SIZE/2):
		for y in range(chunk.x - CHUNK_SIZE/2, chunk.x + CHUNK_SIZE/2):
			var _tile: int = floor_tm.get_cell(x, y)
			if not _tile in data:
				data[_tile] = 1
			else:
				data[_tile] += 1
	chunk_data[chunk]["count_floor"] = data


# load - unload chunk ----------------------------

func load_chunk(chunk_center: Vector2) -> void:
	loaded_chunk.append(chunk_center)
	unloaded_chunk.erase(chunk_center)
	
	var columnStart: int = chunk_center.x - (CHUNK_SIZE / 2)
	var columnEnd: int = chunk_center.x + (CHUNK_SIZE / 2)
	var rowStart: int = chunk_center.y - (CHUNK_SIZE / 2)
	var rowEnd: int = chunk_center.y + (CHUNK_SIZE / 2)
	
	for x in range(columnStart,columnEnd):	# generate main terrain
		for y in range(rowStart,rowEnd):
			var a = noise_at(ground_noise, x, y)
				
			if a < ConstLib.WATER_CAP:
				floor_tm.set_cell(x, y, ConstLib.WATER)
			elif between(a, ConstLib.WATER_CAP, ConstLib.SAND_CAP):
				floor_tm.set_cell(x, y, ConstLib.SAND)
			elif between(a, ConstLib.SAND_CAP, ConstLib.DIRT_CAP):
				floor_tm.set_cell(x, y, ConstLib.DIRT)
			elif between(a, ConstLib.DIRT_CAP, ConstLib.ROCK_CAP):
				floor_tm.set_cell(x, y, ConstLib.STONE)
	floor_tm.update_bitmask_region(Vector2(columnStart, rowStart), Vector2(columnEnd, rowEnd))
	
	for env_type in chunk_data[chunk_center]["env_list"]:
		if env_type == "tree":
			for tree in chunk_data[chunk_center]["env_list"]["tree"]:
				var load_tree = BaseTree.instance() 
				load_tree.position = tree[1]
				load_tree.object = _new_TreeLib.TREES_DATA[tree[0]]
				NodesLib.ysort.add_child(load_tree)
			continue
			
		for env_pos in chunk_data[chunk_center]["env_list"][env_type]:
			var object = null
			for ENV in _new_RessLib.ENVS:
				if ENV["name"] == env_type:
					object = ENV
					break
				
			var new_env = BaseRessource.instance()		
			new_env.object = object
			new_env.position = env_pos
			NodesLib.ysort.add_child(new_env)
		

func unload_chunk(chunk_center: Vector2) -> void:
	unloaded_chunk.append(chunk_center)
	loaded_chunk.erase(chunk_center)
	
	var columnStart: int = chunk_center.x - (CHUNK_SIZE / 2)
	var columnEnd: int = chunk_center.x + (CHUNK_SIZE / 2)
	var rowStart: int = chunk_center.y - (CHUNK_SIZE / 2)
	var rowEnd: int = chunk_center.y + (CHUNK_SIZE / 2)
	
	var vec_range: Array = []
	
	for x in range(columnStart,columnEnd):	# unload terrain
		for y in range(rowStart,rowEnd): 
			vec_range.append(Vector2(x*32, y*32))
			floor_tm.set_cell(x, y, -1)
	
	for tree in get_tree().get_nodes_in_group("base_tree"):	# unload trees
		if tree.position in vec_range:
			tree.queue_free()
			continue
	
	for ress in get_tree().get_nodes_in_group("base_ress"):	# unload ress
		if ress.position in vec_range:
			ress.queue_free()
			continue


# utility ----------------------------------------

func between(x: float, low: float, high: float) -> bool:
	if x >= low and x < high:
		return true
	return false


func get_chunk_center() -> Vector2:
	var playerPos = floor_tm.world_to_map(player.position)
	var x_center: int = ( floor(playerPos.x / CHUNK_SIZE) ) * CHUNK_SIZE + (CHUNK_SIZE / 2)
	var y_center: int = ( floor(playerPos.y / CHUNK_SIZE) ) * CHUNK_SIZE + (CHUNK_SIZE / 2)
	var chunk_center = Vector2(x_center, y_center)
	
	return chunk_center

func get_chunk_center_from_world(pos: Vector2) -> Vector2:
	var tm_pos = floor_tm.world_to_map(pos)
	var x_center: int = ( floor(tm_pos.x / CHUNK_SIZE) ) * CHUNK_SIZE + (CHUNK_SIZE / 2)
	var y_center: int = ( floor(tm_pos.y / CHUNK_SIZE) ) * CHUNK_SIZE + (CHUNK_SIZE / 2)
	var chunk_center = Vector2(x_center, y_center)
	
	return chunk_center

func has_tile(chunk: Vector2, tile: int) -> int:
	if tile in chunk_data[chunk]["count_floor"]:
		return chunk_data[chunk]["count_floor"][tile]
	return 0

func has_env(chunk: Vector2, env: String) -> int:
	if env in chunk_data[chunk]["env_list"]:
		return chunk_data[chunk]["env_list"][env].size()
	return 0
	
	
func noise_at(noise: OpenSimplexNoise, x: int, y: int, absolute: bool = false) -> int:
	var a = noise.get_noise_2d(x,y) * 100
	if absolute:
		a = abs(a)
	return a


func chunk_biome(chunk_center: Vector2) -> String:
	return chunk_data[chunk_center]["biome"]


func _create_wall(chunk_center: Vector2) -> void:
	var start: Vector2 = Vector2(chunk_center.x - (CHUNK_SIZE / 2), chunk_center.y - (CHUNK_SIZE / 2))
	var end: Vector2 = Vector2(chunk_center.x + (CHUNK_SIZE / 2), chunk_center.y + (CHUNK_SIZE / 2))
	
	if not has_tile(chunk_center, ConstLib.STONE):
		return
	
	for x in range(end.x, start.x - 1, -1):
		for y in range(end.y , start.y - 1, -1):
			if floor_tm.get_cell(x, y) != ConstLib.STONE:
				continue
			
			var tile_coord: Vector2 = floor_tm.get_cell_autotile_coord(x, y)
			if not tile_coord in ConstLib.VALID_WALL_TILE:
				continue
				
			var tile: String
				
			match tile_coord:
				Vector2(0, 2), Vector2(1, 0), Vector2(5, 2):	# left
					tile = "left"

				Vector2(2, 2), Vector2(2, 0), Vector2(6, 2), Vector2(2, 4), Vector2(3, 4):	# mid
					tile = "mid"

				Vector2(1, 2), Vector2(7, 2), Vector2(3, 0):	# right
					tile = "right"

				Vector2(0, 0), Vector2(4, 2):	# alone
					tile = "alone"
				
				_:
					continue

			if floor_tm.get_cell(x, y+2) != ConstLib.STONE:
				floor_tm.set_cell(x, y+2, -1)
				floor_tm.set_cell(x, y+1, ConstLib.WALL[0][tile])
				continue
			floor_tm.set_cell(x, y+1, ConstLib.WALL[1][tile])


func _generate_spawn() -> void:
	var chunk_center: Vector2 = get_chunk_center()
	
	var columnStart: int = chunk_center.x - (CHUNK_SIZE * CHUNK_START_DIST)
	var columnEnd: int = chunk_center.x + (CHUNK_SIZE * (CHUNK_START_DIST + 1) )
	var rowStart: int = chunk_center.y - (CHUNK_SIZE * CHUNK_START_DIST)
	var rowEnd: int = chunk_center.y + (CHUNK_SIZE * (CHUNK_START_DIST + 1) )
	
	for x in range(columnStart, columnEnd, CHUNK_SIZE ):
		for y in range(rowStart, rowEnd, CHUNK_SIZE ):		
			var new_chunk_center = Vector2(x, y)
			_create_chunk(new_chunk_center)
			_create_wall(new_chunk_center)	
			if -1 in chunk_data[new_chunk_center]["count_floor"]:
				_update_chunk_data(new_chunk_center)
			unload_chunk(new_chunk_center)	
		
				
# _init ------------------------------------------

func _on_Nodes_initiated() -> void:
	floor_tm = NodesLib.floor_tm
	
	player = NodesLib.player
	fox = NodesLib.fox
	
	ground_noise = NodesLib.ground_noise
	ore_noise = NodesLib.ore_noise
	forest_noise = NodesLib.forest_noise
	details_noise = NodesLib.details_noise
	
	_generate_spawn()



