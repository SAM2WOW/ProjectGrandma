extends RigidBody2D
class_name Draggable

signal on_mouse_hovering
signal on_mouse_exit
signal on_grabbed
signal on_action
signal on_released

var dragging = false;
var hovering = false;

var spriteBaseScale : Vector2;
var shadowBaseScale : Vector2;

var followText : TextEvent = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	spriteBaseScale = $Sprite2D.get_scale();
	shadowBaseScale = $Sprite2DShadow.get_scale();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if followText:
		followText.global_position = Vector2(global_position.x-50, global_position.y-50);
	$Sprite2DShadow.set_global_position(lerp($Sprite2DShadow.get_global_position(), $Sprite2D.get_global_position() + Vector2(12, 12) * int(hovering), 5 * delta))
	$Sprite2DShadow.self_modulate.a = lerp($Sprite2DShadow.self_modulate.a, 0.5 * float(hovering), 5 * delta)

func _physics_process(delta):
	if global_position.y > 1500:
		print("reset")
		linear_velocity = Vector2(0, 0);
		global_position = Vector2(0,0);
	pass;

func StartDrag():
	Global.gameManager.BeginDragObject(self);

func OnHover():
	if Global.gameManager.hoveredObject: Global.gameManager.hoveredObject.UnHover();
		
	Global.gameManager.hoveredObject = self;
	hovering = true;
	create_tween().tween_property($Sprite2D, "scale", spriteBaseScale*1.1, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT);
	create_tween().tween_property($Sprite2DShadow, "scale", shadowBaseScale*1.1, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT);
	# print("hover scale: ", spriteBaseScale*1.2);
	
	emit_signal("on_mouse_hovering")

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
	
func StopDrag():
	dragging = false;
	Global.gameManager.draggedObject = null;
	
	emit_signal("on_released")

func ObjectAction(event):
	emit_signal("on_action")
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
		StartDrag();
		emit_signal("on_grabbed")

func UnHover():
	if Global.gameManager.hoveredObject == self:
		Global.gameManager.hoveredObject = null;
	hovering = false
	#var twn1 : Tween = create_tween();
	#var twn2 : Tween = create_tween();
	create_tween().tween_property($Sprite2DShadow, "scale", shadowBaseScale, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	create_tween().tween_property($Sprite2D, "scale", spriteBaseScale, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT);
	# print("unhover scale: ", spriteBaseScale);

func _on_interact_area_mouse_entered():
	OnHover();


func MultiplyScale(scaleMult: float):
	$Sprite2D.scale *= scaleMult;
	$Sprite2DShadow.set_scale($Sprite2D.get_scale())
	$CollisionShape2D.scale *= scaleMult;
	spriteBaseScale = $Sprite2D.get_scale();
	shadowBaseScale = $Sprite2DShadow.get_scale();

func _on_interact_area_mouse_exited():
	# print("un hover")
	UnHover();
	emit_signal("on_mouse_exit")
