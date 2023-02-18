extends Node2D

#onready var debug_overlay = $DebugOverlay


func _ready() -> void:
	var debug_overlay = NodesLib.debug_overlay
	print("\n	-DebugOverlay initialisations...")
	debug_overlay.add_stat("Player position", self, "get_player_pos", true)
	debug_overlay.add_stat("Cursor position", self, "get_mouse_pos", true)
	debug_overlay.add_stat("Chunk loaded", self, "get_chunk_loaded", true)
	debug_overlay.add_stat("Health", PlayerData, "health", false)
	debug_overlay.add_stat("Hunger", PlayerData, "hunger", false)
	debug_overlay.add_stat("Thirst", PlayerData, "thirst", false)
	print("	-DebugOverlay initialized !\n")


func get_mouse_pos() -> Vector2:
	var x = get_global_mouse_position().x / 32
	var y = get_global_mouse_position().y / 32
	return Vector2(floor(x), floor(y) )
	

func get_player_pos() -> Vector2:
	var x = $YSort/Player.position.x / 32
	var y = $YSort/Player.position.y / 32
	return Vector2(floor(x), floor(y) )


func get_chunk_loaded() -> int:
	return $WorldGen.loaded_chunk.size()
	
	
func drop_item(item):
	pass
