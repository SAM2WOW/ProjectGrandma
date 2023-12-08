extends "res://scripts/main.gd"

func _ready():
	super._ready()
	
	#await get_tree().create_timer(2).timeout
	#
	#Global.textManager.Activate("Kids")



func _on_liquid_draggable_on_mouse_hovering():
	Global.textManager.Activate("Mahal")


func _on_pan_on_mouse_hovering():
	Global.textManager.Activate("Vegetables")


#func _on_pan_body_exited(body: Node):
	#Global.textManager.Activated("Cooking")


#func _on_container_on_grabbed():
	#Global.textManager.Activate("Tofu")


#func _on_container_2_on_grabbed():
	#Global.textManager.Activate("Peppercorns")


#func _on_liquid_draggable_2_on_grabbed():
	#Global.textManager.Activate("Garlic")
