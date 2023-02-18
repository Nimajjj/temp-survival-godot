extends StaticBody2D

func _ready():
	$ClickTaker.set_shape($AreaShape)


func open_bonfire_menu() -> void:
	print("bonefire_menu_open")
