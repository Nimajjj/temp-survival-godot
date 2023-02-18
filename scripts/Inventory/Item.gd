extends Node2D

var item_name: String
var item_quantity: int



func add_item_quantity(amount: int):
	item_quantity += amount
	$Label.text = String(item_quantity)


func decrease_item_quantity(amount: int):
	item_quantity -= amount
	$Label.text = String(item_quantity)
	
	
func set_item(name: String, quantity: int) -> void:
	item_name = name
	item_quantity = quantity
	$TextureRect.texture = load("res://assets/items/" + item_name + ".png")
	
	var stack_size: int = JsonData.item_data[item_name]["StackSize"]
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.text = String(item_quantity)

