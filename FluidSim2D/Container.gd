
extends StaticBody2D

var col = CollisionPolygon2D
func _ready():
	if (Engine.is_editor_hint):
		get_window().size = Vector2i(960, 960);
func _process(delta):
	pass;
	# update()

func _draw():
	pass;
	# draw_colored_polygon(col.polygon,Color.black)
