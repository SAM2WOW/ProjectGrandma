extends Node2D

signal turnedKnob(analog: float)

var following := false
const MAX_DIST := 7000
var knobAnalog : float;

func _ready():
	$knob.rotation = -2;

func _physics_process(delta: float) -> void:
	if following:
		# var ang := get_global_mouse_position().angle_to_point( $knob.global_position ) + PI/2
		var ang = $knob.global_position.angle_to_point(get_global_mouse_position()) + PI/2;
		var d :Vector2= ($knob/knobPoint.position.rotated( $knob.rotation))
		var a = $middlePoint.position.angle_to(d)
		var finalAng :float= remap( a, -3.14, 3.14, 0, 100 )
		# print(finalAng)
		var fang :float= lerp_angle( $knob.rotation, ang, 0.3  )
		# from -2 -> 2 is cooking temp
		$knob.rotation = clamp(fang, -2, 2)
		knobAnalog = remap($knob.rotation, -2, 2, 0, 1);
		# print(knobAnalog);
		emit_signal("turnedKnob", knobAnalog) 
#
#range_lerp(75, 0, 100, -1, 1) # Returns 0.5
func _input(event):
	if !event is InputEventMouseButton: return;
	if event.button_index == 1 && !event.pressed:
		following = false;

func _on_area_2d_input_event(viewport, event, shape_idx):
	if !event is InputEventMouseButton: return;
	if event.button_index == 1 && event.pressed:
		following = true;


func _on_area_2d_mouse_entered():
	pass # Replace with function body.


func _on_area_2d_mouse_exited():
	pass # Replace with function body.
