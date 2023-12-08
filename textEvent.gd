extends Node2D

class_name TextEvent;

@export var dissapearTimer : float;
@export var playOnce : bool = true;
var hasPlayed : bool = false;
var active : bool = false;
var firstTime : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = 10;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func AwaitDissapear():
	await get_tree().create_timer(dissapearTimer).timeout;
	
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(get_child(0), "visible_ratio", 0, 1)
	
	await get_tree().create_timer(1).timeout;
	
	self.visible = false;
	self.active = false;
