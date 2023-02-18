extends Node2D

const HUNGER_MAX_COUNT: float = 12.0	# 12 -> 20 min for 100 to 0
const THIRST_MAX_COUNT: float = 6.0		# 6 -> 10 min for 100 to 0

var hunger_count: float = HUNGER_MAX_COUNT
var thirst_count: float = THIRST_MAX_COUNT

var starved: bool = false
var dehydrated: bool = false


func _ready() -> void:
	NodesLib.hht = self
	
	NodesLib.debug_overlay.add_stat("hunger_count", self, "hunger_count", false)
	NodesLib.debug_overlay.add_stat("thirst_count", self, "thirst_count", false)
	NodesLib.debug_overlay.add_stat("starved", self, "starved", false)
	NodesLib.debug_overlay.add_stat("dehydrated", self, "dehydrated", false)


func _process(delta):
	_check_hunger_count()
	_check_thirst_count()
		

func player_action(action: String) -> void:
	match action:
		"breaking":
			hunger_count -= 0.5
			thirst_count -= 0.5
		_:
			print("# ERROR - ACTION UNKNOWN: " + str(action) + " #")


func _check_hunger_count() -> void:
	if hunger_count <= .0:
		hunger_count += HUNGER_MAX_COUNT
		PlayerLib.decrease_hunger(1)
	
	if PlayerData.hunger <= 0:
		starved = true
	else:
		starved = false
		
		
func _check_thirst_count() -> void:
	if thirst_count <= .0:
		thirst_count += THIRST_MAX_COUNT
		PlayerLib.decrease_thirst(1)
		
	if PlayerData.thirst <= 0:
		dehydrated = true
	else:
		dehydrated = false
		
		
func _on_HungerTimer_timeout():
	hunger_count -= 1.0
	_check_hunger_count()


func _on_ThirstTimer_timeout():
	thirst_count -= 1.0
	_check_thirst_count()


func _on_HealthTimer_timeout():
	if dehydrated:
		PlayerLib.decrease_health(10)
	if starved:
		PlayerLib.decrease_health(5)
	if PlayerData.hunger >= 95 and PlayerData.thirst > 90 and PlayerData.health < 100:
		PlayerLib.increase_health(1)
