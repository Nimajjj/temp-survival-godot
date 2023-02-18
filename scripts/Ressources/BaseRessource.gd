extends StaticBody2D

onready var sprite = $Sprite
onready var collision_shape_2d = $CollisionShape2D
onready var area_shape = $AreaShape


var DgPointeur := preload("res://scenes/Debug/DebugPointeur.tscn")
var ItemDrop := preload("res://scenes/Inventory/ItemDrop.tscn")

var object: Dictionary
var mouse_on: bool = false

var breakable_by: Array
var data_deleted: bool = false

func _ready():
	init_object()
	$ClickTaker.set_shape(area_shape)


func breaking_ressource() -> void:
	NodesLib.hht.player_action("breaking")
		
	if not data_deleted:
		delete_data()
		
	for drop in range(object["drop"].size()):
		if object["drop_rate"][drop] < randi() % 100:
			continue
		var lucky_drop: int = 0
		if object["lucky_drop"][drop] != 0:
			lucky_drop = randi() % object["lucky_drop"][drop]
		for _nbr in range(object["drop_quantity"][drop] + lucky_drop ):
			var item_drop = ItemDrop.instance()
			item_drop.init_item_drop(object["drop"][drop])
			get_parent().add_child(item_drop)
			item_drop.position = position
			item_drop.target_pos = position + Vector2( int(rand_range(-16.0, 16.0) ), int(rand_range(-16.0, 16.0) ) )
	
	queue_free()


func delete_data() -> void:
	var chunk_center: Vector2 = NodesLib.world_gen.get_chunk_center_from_world(position)
	var data_to_erase: Vector2
	for ressource in NodesLib.world_gen.chunk_data[chunk_center]["env_list"][object["name"]]:
		if position == ressource:
			data_to_erase = ressource
			break
	NodesLib.world_gen.chunk_data[chunk_center]["env_list"][object["name"]].erase(data_to_erase)
	data_deleted = true
			


func init_object() -> void:
	init_sprite(object["textures"][randi() % len(object["textures"] ) ], object["local_position"])
	init_area(object["area"]["tres_path"], object["area"]["local_position"])
	
	breakable_by = object["tools"]
	
	if object["collision"]["active"]:
		init_collision(object["collision"]["tres_path"], object["collision"]["local_position"], object["collision"]["rotation_degrees"])
	else:
		collision_shape_2d.queue_free()


func init_sprite(texture_path: String, sprite_pos: Vector2) -> void:
	sprite.texture = load(texture_path)
	sprite.position = sprite_pos


func init_collision(coll_path: String, coll_pos: Vector2, coll_rotation: int) -> void:
	collision_shape_2d.shape = load(coll_path)
	collision_shape_2d.position = coll_pos
	collision_shape_2d.rotation_degrees = coll_rotation


func init_area(shape_path: String, shape_pos: Vector2):
	area_shape.shape = load(shape_path)
	area_shape.position = shape_pos



