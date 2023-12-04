extends StaticBody2D

var panRef : PanContainer;
var heatMultiplier : float = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

func OnKnobTurned(analog):
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(body);
	if body is PanContainer:
		panRef = body;
		panRef.targetHeat = heatMultiplier;


func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is PanContainer:
		body.targetHeat = 0;
		panRef = null;


func _on_knob_turned_knob(analog):
	heatMultiplier = remap(analog, 0, 1, 0, 2);
	if panRef:
		panRef.targetHeat = heatMultiplier;
