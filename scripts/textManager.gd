extends Node2D

#@export var textSystem : Array[textEvent] = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.visible = false;
		
		child.get_child(0).set_visible_ratio(0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
#func AddTextEvent(id : String, text : String, disTime : float):
	#pass
	
func Activate(id : String):
	var child = find_child(id);
	
	if (child == null):
		print("Can't find textEvent with name ", id);
		return;
	
	if ((child.playOnce == true && child.hasPlayed == true) || child.active == true):
		return;
		
	child.visible = true;
	child.hasPlayed = true;
	child.active = true;
	
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(child.get_child(0), "visible_ratio", 1, 1)
	
	if (child.dissapearTimer != 0):
		child.AwaitDissapear();
	
func Deactivate(id : String):
	var child = find_child(id);
	
	if (child == null):
		print("Can't find textEvent with name ", id);
		return;
	
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(child.get_child(0), "visible_ratio", 0, 1)
	
	await get_tree().create_timer(1).timeout;
	
	child.visible = false;
	child.active = false;
	
