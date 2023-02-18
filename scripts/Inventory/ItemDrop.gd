extends KinematicBody2D

const MAX_SPEED: int = 2500
const ACCELERATION: int = 5000
const FRICTION: int = 5000

var player: KinematicBody2D = null
var being_picked_up: bool = false

var item_name: String

var velocity = Vector2.ZERO

var target_pos = Vector2.ZERO
var dropped: bool = false

func _physics_process(delta):
	if being_picked_up:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 16:
			PlayerInventory.add_item(item_name, 1)
			queue_free()
			
	elif not being_picked_up and target_pos != Vector2.ZERO and not dropped:
		var direction = global_position.direction_to(target_pos)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		var distance = global_position.distance_to(target_pos)
		if distance < 8:
			dropped = true
	
	if dropped and not being_picked_up:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)
		

func pick_up_item(body) -> void:
	player = body
	being_picked_up = true


func init_item_drop(name: String) -> void:
	item_name = name
	var path: String = "res://assets/items/" + name + ".png"
	$Sprite.texture = load(path)

