extends Area2D

var ore: String

func set_ore(name: String) -> void:
	ore = name
	match name:
		"iron":
			$Sprite.frame = 2
		"coal":
			$Sprite.frame = 3
