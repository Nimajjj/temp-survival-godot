extends KinematicBody2D

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var hht_engine = $HhtEngine

export(int) var ACCELERATION = 3000
export(int) var FRICTION = 3000
export(int) var MAX_SPEED = 300

var velocity = Vector2()

var inventory_open: bool = false


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	if not NodesLib.user_interface.inventory_open:
		input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward((input_vector * MAX_SPEED) , ACCELERATION * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)


# INPUTS --------------------------------------------------

func _unhandled_input(event):
	if not NodesLib.user_interface.inventory_open:
		if Input.is_action_pressed("pickup"):
			if $PickupZone.items_in_range.size() > 0:
				for item in $PickupZone.items_in_range:
					item.pick_up_item(self)
					$PickupZone.items_in_range.erase(item)
	
			
	# DEBUG INPUTS ----------------------------------------
	if event.is_action("--"):
		$Camera2D.zoom += Vector2(0.5, 0.5)
	elif event.is_action("++"):
		if $Camera2D.zoom.x > 0.5:
			$Camera2D.zoom -= Vector2(0.5, 0.5)
	elif Input.is_action_just_pressed("f1"):
		PlayerLib.decrease_health(10)
	elif Input.is_action_just_pressed("f2"):
		PlayerLib.decrease_hunger(10)
	elif Input.is_action_just_pressed("f3"):
		PlayerLib.decrease_thirst(10)
		
	elif Input.is_action_just_pressed("f4"):
		PlayerLib.increase_health(10)	
	elif Input.is_action_just_pressed("f5"):
		PlayerLib.increase_hunger(10)
	elif Input.is_action_just_pressed("f6"):
		PlayerLib.increase_thirst(10)
		
#	elif Input.is_action_just_pressed("rmb"):
#		position = get_global_mouse_position()
	elif Input.is_action_just_pressed("ui_accept"):
		var world_gen = get_tree().get_root().get_node("World/WorldGen")
		var chunk_center: Vector2 = world_gen.get_chunk_center()
		
		var data: Array = [
			chunk_center,
		]
		
		for key in world_gen.chunk_data[chunk_center]:
			match key:
				"count_floor":
					data.append("{0}: {1}".format([key, world_gen.chunk_data[chunk_center][key]] ) )
				"env_list":
					for sub_key in world_gen.chunk_data[chunk_center][key]:
						data.append("{0}:  {1}".format([sub_key, len(world_gen.chunk_data[chunk_center][key][sub_key])] ) )
				"biome":
					data.append("biome: {0}".format([world_gen.chunk_data[chunk_center][key]] ) )
		
		var text: String = "		Chunk center: {0}\n\n"
		
		for i in range(len(data)):
			if i != 0:
				text += " {{0}}\n".format([i])
		
		text = text.format(data)
		
		NodesLib.debug_overlay.add_info_label(text)

