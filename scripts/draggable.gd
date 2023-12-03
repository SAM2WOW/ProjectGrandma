extends RigidBody2D
class_name Draggable

@export var dragPoint : RigidBody2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	if !dragPoint: dragPoint = get_node("DragPoint");
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	# highlight object
	pass # Replace with function body.


func _on_mouse_exited():
	# unhighlight object
	pass # Replace with function body.


func _on_input_event(viewport, event, shape_idx):
	if !event is InputEventMouseButton: return;
	if event.pressed:
		GameManager.BeginDragObject(self);
		print("pickup");

func Drag(delta):
	var mousePos: Vector2 = get_global_mouse_position();
	print(dragPoint.global_position.distance_to(mousePos))
	var speed: float = dragPoint.global_position.distance_to(mousePos) / delta;
	var velocity: Vector2 = speed * dragPoint.global_position.direction_to(mousePos);
	
	dragPoint.linear_velocity = velocity;
