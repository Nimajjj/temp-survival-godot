extends Node

signal active_item_updated

const SlotClass := preload("res://scripts/Inventory/Slot.gd")
const ItemClass := preload("res://scripts/Inventory/Item.gd")
const NUM_INVENTORY_SLOTS: int = 24
const NUM_HOTBAR_SLOTS: int = 9

var inventory: Dictionary = {# slot_index: [item_name, item_quantity]
	0: ["Apple", 1],
}

var hotbar: Dictionary = {
	0: ["Makeshift Axe", 1],
	3: ["Bonfire", 1],
	4: ["Bonfire", 1],
}

var active_item_slot: int = 0


func add_item(item_name: String, item_quantity: int) -> void:
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size: int = JsonData.item_data[item_name]["StackSize"]
			var able_to_add: int = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				item_quantity -= able_to_add
	
	for i in range(NUM_INVENTORY_SLOTS):
		if not inventory.has(i):
			inventory[i] = [item_name, item_quantity]
			update_slot_visual(i, inventory[i][0], inventory[i][1])
			return

func update_slot_visual(slot_index: int, item_name: String, new_quantity: int) -> void:
	var slot = get_tree().root.get_node("/root/World/UserInterface/Inventory/GridContainer/Slot" + str(slot_index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)


func add_item_to_empty_slot(item: ItemClass, slot: SlotClass, is_hotbar: bool = false) -> void:
	if is_hotbar:
		hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
	else:
		inventory[slot.slot_index] = [item.item_name, item.item_quantity]


func remove_item(slot: SlotClass, is_hotbar: bool = false) -> void:
	if is_hotbar:
		var __ = hotbar.erase(slot.slot_index)
	else:
		var __ = inventory.erase(slot.slot_index)


func add_item_quantity(slot: SlotClass, quantity_to_add: int, is_hotbar: bool = false) -> void:
	if is_hotbar:
		hotbar[slot.slot_index][1] += quantity_to_add
	else:
		inventory[slot.slot_index][1] += quantity_to_add


func active_item_scroll_up() -> void:
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	emit_signal("active_item_updated")
	
func active_item_scroll_down() -> void:
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated")
	
func set_active_item(slot_index: int) -> void:
	active_item_slot = slot_index
	emit_signal("active_item_updated")
	
	
	
	
	
