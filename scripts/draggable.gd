extends RigidBody2D
class_name Draggable

var dragging = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass;

func _on_input_event(viewport, event, shape_idx):
	if !event is InputEventMouseButton: return;
	if event.button_index == 1 && event.pressed:
		GameManager.BeginDragObject(self);

func Drag(delta):
	dragging = true;
	var dragObj = self;
	# dragObj = $DragPoint;
	var mousePos: Vector2 = get_global_mouse_position();
	var massMult = clamp(1.0/mass, 0.1, 1.0);
	var speed: float = massMult * dragObj.global_position.distance_to(mousePos) / delta;
	var raycast = PhysicsRayQueryParameters2D.create(dragObj.global_position, mousePos);
	if get_world_2d().direct_space_state.intersect_ray(raycast):
		speed = clamp(speed, 0, 8000);
	var velocity: Vector2 = speed * dragObj.global_position.direction_to(mousePos);
	dragObj.linear_velocity = velocity;
	# $DragPoint.linear_velocity = velocity;
	
func ObjectAction(event):
	pass;

func AirDrag(delta):
	# print(linear_velocity.length());
	# var drag = -linear_velocity.normalized() * airDrag * pow(linear_velocity.length(), 2) * delta;
	#apply_force(drag*delta);
	# print(drag);
	pass;


func _on_interact_area_input_event(viewport, event, shape_idx):
	if !event is InputEventMouseButton: return;
	if event.button_index == 1 && event.pressed:
		GameManager.BeginDragObject(self);


func _on_interact_area_mouse_entered():
	pass # Replace with function body.


func _on_interact_area_mouse_exited():
	pass # Replace with function body.
