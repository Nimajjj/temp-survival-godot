extends Node2D

const SlotClass := preload("res://scripts/Inventory/Slot.gd")
const ItemDrop := preload("res://scenes/Inventory/ItemDrop.tscn")

var item_slot: SlotClass

func init_info_box(slot: SlotClass):
	item_slot = slot
	$TitleLabel.text = item_slot.item.item_name
	
	if JsonData.item_data[item_slot.item.item_name].has("Effect"):
		$UseBt.disabled = false


func _on_CloseInfoBox_pressed():
	get_parent().del_infobox()


func _on_DropBt_pressed():	
	for i in range(item_slot.item.item_quantity):
		var item_drop = ItemDrop.instance()
		var player_pos = NodesLib.player.position
		item_drop.init_item_drop(item_slot.item.item_name)
		NodesLib.ysort.add_child(item_drop)
		item_drop.position = player_pos
		item_drop.target_pos = player_pos + Vector2( int(rand_range(-16.0, 16.0) ), int(rand_range(-16.0, 16.0) ) )
	
	item_slot.remove_item()
	PlayerInventory.remove_item(item_slot)
	
	get_parent().del_infobox()


func _on_UseBt_pressed():	
	NodesLib.consumable_engine.consume_item(item_slot)
	if not item_slot.item:
		get_parent().del_infobox()
