extends Node2D

onready var hotbar = $HotbarSlots
onready var slots = hotbar.get_children()

const SlotClass := preload("res://scripts/Inventory/Slot.gd")


func _ready() -> void:
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i] ] )
		PlayerInventory.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].slot_type = SlotClass.SlotType.HOTBAR
		slots[i].slot_index = i
	initialize_hotbar()


func initialize_hotbar() -> void:
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])
		slots[i].refresh_style()

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if NodesLib.user_interface.inventory_open:
				if get_parent().holding_item != null:
					if !slot.item:	# place holding item into slot
						left_click_empty_slot(slot)
					else:
						if get_parent().holding_item.item_name != slot.item.item_name:	# swap item with item in slot
							left_click_different_item(event, slot)
						else:	# same item -> try to merge
							left_click_same_item(slot)
				elif slot.item:	# pick item
					left_click_not_holding(slot)
			else:
				PlayerInventory.set_active_item(slot.slot_index)
			
				
func left_click_empty_slot(slot: SlotClass) -> void:
	PlayerInventory.add_item_to_empty_slot(get_parent().holding_item, slot, true)
	slot.put_into_slot(get_parent().holding_item)
	get_parent().holding_item = null


func left_click_different_item(event: InputEvent, slot: SlotClass) -> void:
	PlayerInventory.remove_item(slot, true)
	PlayerInventory.add_item_to_empty_slot(get_parent().holding_item, slot, true)
	var temp_item = slot.item
	slot.pick_from_slot()
	temp_item.global_position = event.global_position
	slot.put_into_slot(get_parent().holding_item)
	get_parent().holding_item = temp_item


func left_click_same_item(slot: SlotClass) -> void:
	var stack_size: int = JsonData.item_data[slot.item.item_name]["StackSize"]
	var able_to_add: int = stack_size - slot.item.item_quantity
	if able_to_add >= get_parent().holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, get_parent().holding_item.item_quantity, true)
		slot.item.add_item_quantity(get_parent().holding_item.item_quantity)
		get_parent().holding_item.queue_free()
		get_parent().holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add, true)
		slot.item.add_item_quantity(able_to_add)
		get_parent().holding_item.decrease_item_quantity(able_to_add)


func left_click_not_holding(slot: SlotClass) -> void:
	PlayerInventory.remove_item(slot, true)
	get_parent().holding_item = slot.item
	slot.pick_from_slot()
	get_parent().holding_item.global_position = get_global_mouse_position()
