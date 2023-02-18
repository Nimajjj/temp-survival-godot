extends Node2D

onready var inventory_slots = $GridContainer

const SlotClass := preload("res://scripts/Inventory/Slot.gd")
const InventoryInfoBox := preload("res://scenes/Inventory/InventoryInfoBox.tscn")

#var holding_item = null

var infoboxs_list: Array = []

func _ready() -> void:
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i] ] )
		slots[i].slot_type = SlotClass.SlotType.INVENTORY
		slots[i].slot_index = i
	initialize_inventory()

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
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
				
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			if slot.item:
				del_infobox()
				create_infobox(slot)
				

func create_infobox(slot: SlotClass) -> void:
	var new_infobox = InventoryInfoBox.instance()
	new_infobox.position = Vector2(319, 41)
	add_child(new_infobox)
	new_infobox.init_info_box(slot)
	infoboxs_list.append(new_infobox)
				
				
func del_infobox() -> void:
	if infoboxs_list.size() > 0:
		for i in infoboxs_list:
			infoboxs_list.erase(i)
			if i:
				i.queue_free()
			
				
func _input(_event) -> void:
	if get_parent().holding_item:
		get_parent().holding_item.global_position = get_global_mouse_position()
		
		
func initialize_inventory() -> void:
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
		slots[i].refresh_style()

func left_click_empty_slot(slot: SlotClass) -> void:
	PlayerInventory.add_item_to_empty_slot(get_parent().holding_item, slot)
	slot.put_into_slot(get_parent().holding_item)
	get_parent().holding_item = null


func left_click_different_item(event: InputEvent, slot: SlotClass) -> void:
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(get_parent().holding_item, slot)
	var temp_item = slot.item
	slot.pick_from_slot()
	temp_item.global_position = event.global_position
	slot.put_into_slot(get_parent().holding_item)
	get_parent().holding_item = temp_item


func left_click_same_item(slot: SlotClass) -> void:
	var stack_size: int = JsonData.item_data[slot.item.item_name]["StackSize"]
	var able_to_add: int = stack_size - slot.item.item_quantity
	if able_to_add >= get_parent().holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, get_parent().holding_item.item_quantity)
		slot.item.add_item_quantity(get_parent().holding_item.item_quantity)
		get_parent().holding_item.queue_free()
		get_parent().holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		get_parent().holding_item.decrease_item_quantity(able_to_add)


func left_click_not_holding(slot: SlotClass) -> void:
	PlayerInventory.remove_item(slot)
	get_parent().holding_item = slot.item
	slot.pick_from_slot()
	get_parent().holding_item.global_position = get_global_mouse_position()
