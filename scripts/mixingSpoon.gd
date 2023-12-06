extends Draggable
@export var rotateSpeed : float = 100;


# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	super._physics_process(delta);
	if dragging:
		rotation = lerp_angle(rotation, deg_to_rad(30), rotateSpeed*delta);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
