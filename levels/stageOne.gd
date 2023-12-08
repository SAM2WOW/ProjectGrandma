extends "res://scripts/main.gd"

func _ready():
	super._ready()
	
	await get_tree().create_timer(2).timeout
	
	Global.textManager.Activate("Hungry")
	
	await get_tree().create_timer(2).timeout
	
	Global.textManager.Activate("Adobo")
	
	await get_tree().create_timer(2).timeout
	
	Global.textManager.Activate("Adobo1")
