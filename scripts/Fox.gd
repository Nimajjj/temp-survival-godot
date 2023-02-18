extends KinematicBody2D

onready var animation_player = $AnimationPlayer
onready var player = NodesLib.player

const MAX_DIST: int = 128

enum States {
	IDLE,
	RUN
}

var state: int = States.IDLE

export(int) var ACCELERATION = 3000
export(int) var FRICTION = 2000
export(int) var MAX_SPEED = 300

var velocity = Vector2()

# Common func -----------------------------

func _ready() -> void:
	change_state(States.IDLE)


func _physics_process(delta) -> void:
	check_off_set()
	match state:
		States.IDLE:
			idle_state(delta)
			
		States.RUN:
			run_state(delta)
	
	velocity = move_and_slide(velocity)


# States func -----------------------------

func idle_state(delta) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func run_state(delta) -> void:	
	var input_vector = Vector2.ZERO
	
	if player.position.x > position.x + 5:
		input_vector.x += 1
		$IdleSprite.flip_h = false
		$RunSprite.flip_h = false
	elif player.position.x < position.x - 5:
		input_vector.x -= 1
		$IdleSprite.flip_h = true
		$RunSprite.flip_h = true
		
	if player.position.y > position.y + 5:
		input_vector.y += 1
	elif player.position.y < position.y - 5:
		input_vector.y -= 1
	
	input_vector = input_vector.normalized()
	velocity = velocity.move_toward((input_vector * MAX_SPEED) , ACCELERATION * delta)


# Utility ----------------------------------

func check_off_set() -> void:
	var off_set: int = abs(player.position.x - position.x) + abs(player.position.y - position.y)
	
	if off_set < MAX_DIST / 2:
		change_state(States.IDLE)
	
	elif off_set > MAX_DIST:
		change_state(States.RUN)
		
		
func change_state(new_state: int) -> void:
	match new_state:
		States.IDLE:
			animation_player.play("Idle")
			state = States.IDLE
			
		States.RUN:
			animation_player.play("Run")
			state = States.RUN
