extends "res://scripts/main.gd"

func _ready():
	super._ready()
	
	await get_tree().create_timer(2).timeout
	
	Global.textManager.Activate("Hungry")
	
	await get_tree().create_timer(1).timeout
	
	Global.textManager.Activate("Adobo")
	
	await get_tree().create_timer(2).timeout
	
	Global.textManager.Activate("Adobo1")


func _on_liquid_draggable_on_mouse_hovering():
	Global.textManager.Activate("Sauce")


func _on_pan_on_mouse_hovering():
	Global.textManager.Activate("Fire")


func _on_container_on_grabbed():
	Global.textManager.Activate("Item")


func _on_container_2_on_grabbed():
	Global.textManager.Activate("Item2")


func _on_liquid_draggable_2_on_grabbed():
	Global.textManager.Activate("Sauce2")
