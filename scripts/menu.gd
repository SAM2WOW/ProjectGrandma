extends Node

func _process(delta):
	# offset the camera base on the mouse position to the center
	var mousePos = get_viewport().get_mouse_position()
	var center = get_viewport().get_visible_rect().size / 2
	var offset = (mousePos - center) / 50
	$Node2D/Camera2D.offset = lerp($Node2D/Camera2D.offset, offset, delta * 5)
	
	# update camera position base on ingredient mode


func _on_hover_area_3_mouse_entered():
	$AnimationPlayer.play_backwards("Intro")
	$CanvasLayer/HUD/HoverArea3.hide()
	
	await get_tree().create_timer(0.6).timeout
	
	get_tree().change_scene_to_file("res://levels/stageOne.tscn")
