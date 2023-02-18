extends Area2D

var build_size: int = 1
var actual_collision: Array = []
var buildable: bool = true

func _process(delta):
	position = get_global_mouse_position() 
	if actual_collision.size() > 0:
		modulate = Color8(155, 0, 0, 200)
		buildable = false
	else:
		modulate = Color8(0, 155, 0, 200)
		buildable = true


func _on_BuildSchem_body_entered(body):
	actual_collision.append(body)


func _on_BuildSchem_body_exited(body):
	actual_collision.erase(body)
