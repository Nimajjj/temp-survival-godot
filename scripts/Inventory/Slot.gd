extends Panel

var DefaultTex := preload("res://assets/inventory/default_itemslot.png")
var EmptyTex := preload("res://assets/inventory/empty_itemslot.png")
var SelectedTex := preload("res://assets/inventory/selected_itemslot.png")

var ItemClass := preload("res://scenes/Inventory/Item.tscn")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null

var item = null
var slot_index: int
var slot_type: int

enum SlotType {
	HOTBAR,
	INVENTORY
}

func _ready() -> void:
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	default_style.texture = DefaultTex
	empty_style.texture = EmptyTex
	selected_style.texture = SelectedTex

	refresh_style()


func refresh_style() -> void:
	if slot_type == SlotType.HOTBAR and slot_index == PlayerInventory.active_item_slot:
		set('custom_styles/panel', selected_style)
	elif item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)

func remove_item() -> void:
	remove_child(item)
	item = null
	refresh_style()
		
func pick_from_slot() -> void:
	remove_child(item)
	var InventoryNode = find_parent("UserInterface")
	InventoryNode.add_child(item)
	item = null
	refresh_style()

func put_into_slot(new_item) -> void:
	item = new_item
	item.position = Vector2.ZERO
	var InventoryNode = find_parent("UserInterface")
	InventoryNode.remove_child(item)
	add_child(item)
	refresh_style()
	
	
func initialize_item(item_name: String, item_quantity: int) -> void:
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	refresh_style()
