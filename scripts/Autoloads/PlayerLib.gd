extends Node

var health_bar: TextureProgress
var hunger_bar: TextureProgress
var thirst_bar : TextureProgress


func decrease_health(amount: int) -> void:
	PlayerData.health -= amount
	if PlayerData.health < 0:
		PlayerData.health = 0
	health_bar.value = PlayerData.health

func increase_health(amount: int) -> void:
	PlayerData.health += amount
	if PlayerData.health > 100:
		PlayerData.health = 100
	health_bar.value = PlayerData.health


func decrease_hunger(amount: int) -> void:
	PlayerData.hunger -= amount
	if PlayerData.hunger < 0:
		PlayerData.hunger = 0
	hunger_bar.value = PlayerData.hunger

func increase_hunger(amount: int) -> void:
	PlayerData.hunger += amount
	if PlayerData.hunger > 100:
		PlayerData.hunger = 100
	hunger_bar.value = PlayerData.hunger
	
	
func decrease_thirst(amount: int) -> void:
	PlayerData.thirst -= amount
	if PlayerData.thirst < 0:
		PlayerData.thirst = 0
	thirst_bar.value = PlayerData.thirst

func increase_thirst(amount: int) -> void:
	PlayerData.thirst += amount
	if PlayerData.thirst > 100:
		PlayerData.thirst = 100
	thirst_bar.value = PlayerData.thirst
