extends Node2D

func _ready():
	PlayerLib.health_bar = $HealthProgress
	PlayerLib.hunger_bar = $HungerProgress
	PlayerLib.thirst_bar = $ThirstProgress
	
