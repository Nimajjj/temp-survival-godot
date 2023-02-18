extends StaticBody2D

onready var sprite = $Sprite
onready var collision_shape_2D = $CollisionShape2D
onready var area_shape = $Area2D/CollisionShape2D

var ItemDrop := preload("res://scenes/Inventory/ItemDrop.tscn")

var object: Dictionary
var mouse_on: bool = false

var breakable_by: Array = ["axe"]

var drop_data: Dictionary = {
	"drop": 			["Wooden Log", "Apple", "Cut Grass", "Tree Branch"],
	"drop_quantity": 	[2, 0, 1, 2],
	"lucky_drop": 		[3, 2, 3, 3],
	"drop_rate": 		[100, 15, 60, 60]
}

var data_deleted: bool = false

func _ready():
	init_tree(object)


func _process(_delta):
	if Input.is_action_just_pressed("lmb") and mouse_on:
		NodesLib.hht.player_action("breaking")
		
		if not data_deleted:
			delete_data()
		
		for drop in range(drop_data["drop"].size()):
			if drop_data["drop_rate"][drop] < randi() % 100:
				continue
			var lucky_drop: int = 0
			if drop_data["lucky_drop"][drop] != 0:
				lucky_drop = randi() % drop_data["lucky_drop"][drop]
			for _nbr in range(drop_data["drop_quantity"][drop] + lucky_drop ):			
				var item_drop = ItemDrop.instance()
				item_drop.init_item_drop(drop_data["drop"][drop])
				get_parent().add_child(item_drop)
				item_drop.position = position
				item_drop.target_pos = position + Vector2( int(rand_range(-24.0, 24.0) ), int(rand_range(-24.0, 24.0) ) )
		
		queue_free()


func delete_data() -> void:
	var chunk_center: Vector2 = NodesLib.world_gen.get_chunk_center_from_world(position)
	var data_to_erase: Array
	for tree in NodesLib.world_gen.chunk_data[chunk_center]["env_list"]["tree"]:
		if position == tree[1]:
			data_to_erase = tree
			break
	NodesLib.world_gen.chunk_data[chunk_center]["env_list"]["tree"].erase(data_to_erase)
	data_deleted = true
			

func init_tree(base_tree: Dictionary) -> void:
	_init_sprite(base_tree["texture_path"], base_tree["texture_pos"])
	_init_collision(base_tree["collision_shape"], base_tree["collision_pos"], base_tree["collision_rotation"])
	_init_area(base_tree["area_shape"], base_tree["area_pos"])


func _init_sprite(tex_path: String, tex_pos: Vector2) -> void:
	sprite.texture = load(tex_path)
	sprite.position = tex_pos


func _init_collision(col_path: String, col_pos: Vector2, col_rotation: int) -> void:
	collision_shape_2D.shape = load(col_path)
	collision_shape_2D.position = col_pos
	collision_shape_2D.rotation_degrees = col_rotation
	
	
func _init_area(area_path: String, area_pos: Vector2) -> void:
	area_shape.shape = load(area_path)
	area_shape.position = area_pos


func _on_Area2D_mouse_entered():
	mouse_on = true


func _on_Area2D_mouse_exited():
	mouse_on = false
