extends Node2D

var world_scene := preload("res://scenes/World.tscn").instance()

func _on_StartButton_pressed():
	get_tree().get_root().add_child(world_scene)
	queue_free()
