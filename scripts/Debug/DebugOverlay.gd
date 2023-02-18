extends CanvasLayer

var DebugInfoLabel := preload("res://scenes/Debug/DebugInfoLabel.tscn")
var DebugChunkRect := preload("res://scenes/Debug/DebugChunkRect.tscn")

var stats: Array = []


func _ready():
	NodesLib.debug_overlay = self


func _process(_delta):
	var label_text: String

	var fps = Engine.get_frames_per_second()
	label_text = str("FPS: ", fps)
	label_text += "\n"

	var static_memory = OS.get_static_memory_usage()
	label_text += str("Static memory: ", String.humanize_size(static_memory))
	label_text += "\n"

	for s in stats:
		var value = null

		if s[1] and weakref(s[1]).get_ref():
			if s[3]:
				value = s[1].call(s[2])
			else:
				value = s[1].get(s[2])

		label_text += str(s[0], ": ", value)
		label_text += "\n"

	$MainLabel.text = label_text


func add_stat(stat_name: String, object, stat_ref: String, is_method: bool):
	stats.append([stat_name, object, stat_ref, is_method])
	print(stat_name, " exists: ", object and weakref(object).get_ref())


func add_info_label(text: String):
	var info_label = DebugInfoLabel.instance()
	info_label.rect_position = Vector2(32*7, 8)
	add_child(info_label)
	info_label.set_text(text)


func add_chunk_rect(chunk_center: Vector2, rect_color: Color) -> void:
	var chunk_rect: Sprite = DebugChunkRect.instance()
	chunk_rect.position = chunk_center * 32
	chunk_rect.modulate = rect_color
	get_parent().add_child(chunk_rect)
