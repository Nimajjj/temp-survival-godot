extends CanvasLayer

onready var inventory = $Inventory
onready var hht_progress_bar = $HhtProgressBars

var holding_item = null
var inventory_open: bool = false


func _ready():
	NodesLib.hht_progress = hht_progress_bar
	NodesLib.user_interface = self


func _unhandled_input(event):
	if event.is_action_released("open_inventory"):
		inventory.visible = !inventory.visible
		inventory_open = inventory.visible
		inventory.initialize_inventory()
		inventory.del_infobox()
	
	if not inventory_open:
		if event.is_action_pressed("scroll_up"):
			PlayerInventory.active_item_scroll_down()
			
		elif event.is_action_pressed("scroll_down"):
			PlayerInventory.active_item_scroll_up()
		
		elif event.is_action_pressed("rmb"):
			var slot = get_tree().root.get_node("/root/World/UserInterface/Hotbar/HotbarSlots/HotbarSlot" + str(PlayerInventory.active_item_slot + 1))
			if slot.item:
				if JsonData.item_data[slot.item.item_name].has("Effect"):
					NodesLib.consumable_engine.consume_item(slot)
				elif JsonData.item_data[slot.item.item_name]["ItemCategory"] == "Build":
					NodesLib.building_engine.build(slot)
