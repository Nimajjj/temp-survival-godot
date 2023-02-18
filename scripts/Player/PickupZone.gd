extends Area2D

var items_in_range: Dictionary = {}


func _on_PickupZone_body_entered(body):
	items_in_range[body] = body


func _on_PickupZone_body_exited(body):
	if items_in_range.has(body):
		var __ = items_in_range.erase(body)

