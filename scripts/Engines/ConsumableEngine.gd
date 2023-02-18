extends Node2D

const SlotClass := preload("res://scripts/Inventory/Slot.gd")


func _ready():
	NodesLib.consumable_engine = self


func consume_item(slot: SlotClass) -> void:
	var item_effects: Dictionary = JsonData.item_data[slot.item.item_name]["Effect"][0]
	
	for effect in item_effects:
		match effect:
			"Hunger":
				PlayerLib.increase_hunger(item_effects[effect])
				
			"Thirst":
				PlayerLib.increase_thirst(item_effects[effect])
				
			_:
				print("# ERROR: UNKNOWN EFFECT: " + str(effect) + " #")
	
	if slot.item.item_quantity > 1:
		slot.item.decrease_item_quantity(1)
	else:
		slot.remove_item()
		PlayerInventory.remove_item(slot)
