extends "res://scripts/main.gd"

func _ready():
	super._ready()
	Global.currentStage = 0;
	await get_tree().create_timer(3).timeout
	
	Global.textManager.Activate("1")
	
	await get_tree().create_timer(7).timeout
	
	Global.textManager.Activate("2")
	
	await get_tree().create_timer(7).timeout
	
	Global.finishSeqText = true;
	
	# Global.textManager.Activate("3")
#
#
#func _on_liquid_draggable_on_mouse_hovering():
	#Global.textManager.Activate("Sauce")
#
#
#func _on_pan_on_mouse_hovering():
	#Global.textManager.Activate("Fire")
#
#
#func _on_container_on_grabbed():
	#Global.textManager.Activate("Item")
#
#
#func _on_container_2_on_grabbed():
	#Global.textManager.Activate("Item2")
#
#
#func _on_liquid_draggable_2_on_grabbed():
	#Global.textManager.Activate("Sauce2")
