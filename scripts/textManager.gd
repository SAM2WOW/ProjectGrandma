extends Node2D

# @export var textSystem : Array[TextEvent] = [];
# @export var textDictionary : Dictionary = {};

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.visible = false;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
#func AddTextEvent(id : String, text : String, disTime : float):
	#pass
	
func Activate(id : String):
	var child = find_child(id);
	
	if ((child.playOnce == true && child.hasPlayed == true) || child.active == true):
		return;
		
	child.visible = true;
	child.hasPlayed = true;
	child.active = true;
	
	if (child.dissapearTimer != 0):
		child.AwaitDissapear();
	
func Deactivate(id : String):
	var child = find_child(id);
	
	child.visible = false;
	child.active = false;
	
