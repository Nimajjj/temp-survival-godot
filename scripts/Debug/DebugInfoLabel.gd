extends TextEdit

var default_text: String = "		# ERROR 001 # -> Text not init...\n\n"
var font_size: int = 16

var mouse_in: bool = false
var follow_mouse: bool = false


func _ready() -> void:
	default_text += "{0}: {1}\nPosition: {2}".format([get_name(), get_path(), rect_position])
	set_text(default_text)


func _process(_delta):
	if Input.is_action_just_pressed("lmb") and mouse_in:
		follow_mouse = true
	if Input.is_action_just_released("lmb"):
		follow_mouse = false
		
	if follow_mouse:
		rect_position = get_global_mouse_position()


func set_text(new_text: String) -> void:
	text = new_text
	_init_size()


func _init_size() -> void:
	var x_length: int
	
	for i in range(get_line_count()):
		if x_length < len(get_line(i)):
			x_length = len(get_line(i))
			
	rect_size.x = x_length * (font_size / 2) #- font_size * 2
	rect_size.y = (get_line_count() + 1) * font_size #- font_size / 2


# Signals -------------------------------------

func _on_DebugInfoLabel_mouse_entered():
	mouse_in = true


func _on_DebugInfoLabel_mouse_exited():
	mouse_in = false


func _on_Button_pressed():
	queue_free()
