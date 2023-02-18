extends Area2D


export(String) var func_name
export(NodePath) var node_called_path
export(int, "BUTTON_LEFT", "BUTTON_RIGHT") var mouse_button 

var node_called = null
var call_function: FuncRef

var mouse_in: bool = false


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == (mouse_button + 1) and event.pressed and mouse_in:
			node_called = get_node(node_called_path)
			call_function = funcref(node_called, func_name)
			call_function.call_func()


func set_shape(copy_shape: CollisionShape2D) -> void:
	var new_shape = copy_shape.duplicate()
	add_child(new_shape)
	

func _on_ClickTaker_mouse_entered():
	mouse_in = true


func _on_ClickTaker_mouse_exited():
	mouse_in = false
