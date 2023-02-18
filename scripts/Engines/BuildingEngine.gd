extends Node2D

var BuildSchem := preload("res://scenes/Build/BuildSchem.tscn")
const SlotClass := preload("res://scripts/Inventory/Slot.gd")


var item_name: String
var buildable: bool = true
var active_schem: Area2D

func _ready():
	NodesLib.building_engine = self
	PlayerInventory.connect("active_item_updated", self, "_new_item_in_hand")


func build(slot: SlotClass) -> void:
	if active_schem.buildable:
		var BuildingScene = load("res://scenes/Build/" + item_name + ".tscn")
		var new_building = BuildingScene.instance()
		NodesLib.ysort.add_child(new_building)
		new_building.position = active_schem.position - new_building.get_node("Sprite").position
		
		
		if slot.item.item_quantity > 1:
			slot.item.decrease_item_quantity(1)
		else:
			slot.remove_item()
			PlayerInventory.remove_item(slot)
			delete_scheme()


func display_schem() -> void:
	active_schem = BuildSchem.instance()
	add_child(active_schem)
	active_schem.get_node("Sprite").texture = load("res://assets/build/" + item_name + ".png")


func delete_scheme() -> void:
	if active_schem:
		active_schem.queue_free()
	active_schem = null
	item_name = ""


func _new_item_in_hand() -> void:
	if active_schem:
		delete_scheme()
	var slot = get_tree().root.get_node("/root/World/UserInterface/Hotbar/HotbarSlots/HotbarSlot" + str(PlayerInventory.active_item_slot + 1))
	if slot.item:
		if JsonData.item_data[slot.item.item_name]["ItemCategory"] == "Build":
			item_name = slot.item.item_name
			display_schem()
		else:
			delete_scheme()
	elif active_schem:
		delete_scheme()
		
