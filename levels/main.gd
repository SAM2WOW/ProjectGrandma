extends Node

func _ready():
	if (Engine.is_editor_hint):
		get_window().size = Vector2i(960, 540);

func _process(delta):
	pass
