extends Node2D

class_name TextEvent;

#@export var id : String;
#@export var text : String;
#@export var pos : Vector2;
#@export var rotation : float;
@export var dissapearTimer : float;
@export var playOnce : bool = true;
var hasPlayed : bool = false;
var active : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#add_child(Label);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func AwaitDissapear():
	await get_tree().create_timer(dissapearTimer).timeout;
	self.visible = false;
	self.active = false;
