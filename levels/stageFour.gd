extends "res://scripts/main.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	await get_tree().create_timer(3).timeout
	
	Global.textManager.Activate("1")
	
	await get_tree().create_timer(10).timeout
	
	Global.textManager.Activate("2")
	
	await get_tree().create_timer(10).timeout
	
	Global.textManager.Activate("3")
	
	await get_tree().create_timer(10).timeout
	
	Global.textManager.Activate("4")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
