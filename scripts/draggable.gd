extends RigidBody2D
class_name Draggable

var dragging = false;

# Called when the node enters the scene tree for the first time.
func _ready():
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

func _physics_process(delta):
	pass;

func _on_input_event(viewport, event, shape_idx):
	if !event is InputEventMouseButton: return;
	if event.button_index == 1 && event.pressed:
		GameManager.BeginDragObject(self);

func Drag(delta):
	dragging = true;
	var mousePos: Vector2 = get_global_mouse_position();
	var speed: float = $DragPoint.global_position.distance_to(mousePos) / delta;
	var raycast = PhysicsRayQueryParameters2D.create($DragPoint.global_position, mousePos);
	if get_world_2d().direct_space_state.intersect_ray(raycast):
		speed = clamp(speed, 0, 8000);
	var velocity: Vector2 = speed * $DragPoint.global_position.direction_to(mousePos);
	
	$DragPoint.linear_velocity = velocity;
	
func ObjectAction(event):
	pass;

func AirDrag(delta):
	# print(linear_velocity.length());
	# var drag = -linear_velocity.normalized() * airDrag * pow(linear_velocity.length(), 2) * delta;
	#apply_force(drag*delta);
	# print(drag);
	pass;
