extends Node

var recipeMode = false

var currentRecipe
func _ready():
	
	print("Main is ready")
	Global.gameManager.stageComplete.connect(completeStage)
	Global.gameManager.gameEnd.connect(onGameEnd)
	$CanvasLayer/TestLevelText.text = "Level" + str(Global.gameManager.currentStage+1)
	Global.recipeManager.GetCurrentRecipeIngredients()
	$CanvasLayer/CompeletLevelButton.modulate.a = 0.1
 

func _process(delta):
	# offset the camera base on the mouse position to the center
	var mousePos = get_viewport().get_mouse_position()
	var center = get_viewport().get_visible_rect().size / 2
	var offset = (mousePos - center) / 50
	$Node2D/Camera2D.offset = lerp($Node2D/Camera2D.offset, offset, delta * 5)
	
	# update camera position base on ingredient mode
	
	
func completeStage():
	print('Stage Complete')
	$CanvasLayer/CompeletLevelButton.modulate.a = 1	

func _input(ev):
	if ev is InputEventKey and ev.keycode == KEY_K:
		onGameEnd()
	if ev is InputEventKey and ev.keycode == KEY_ENTER:
		if Global.gameManager.canCompleteStage:
			Global.gameManager.OnCompleteStage()
	if ev is InputEventKey and ev.keycode == KEY_S:
		Global.gameManager.UpdateStage()


func onGameEnd():
	print("Game END")
	
	#$CanvasLayer/HUD/HoverArea.hide()
	#$CanvasLayer/HUD/HoverArea2.hide()
	#
	#$AnimationPlayer.play("Final")
	

func _on_hover_area_mouse_entered():
	recipeMode = true
	
	$CanvasLayer/HUD/HoverArea.hide()
	$CanvasLayer/HUD/HoverArea2.show()
	
	$AnimationPlayer.play("Transition")


func _on_hover_area_2_mouse_entered():
	recipeMode = false
	
	$CanvasLayer/HUD/HoverArea.show()
	$CanvasLayer/HUD/HoverArea2.hide()
	
	$AnimationPlayer.play_backwards("Transition")


func _on_hover_area_3_mouse_entered():
	$AnimationPlayer.play_backwards("Exit")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Intro":
		$CanvasLayer/HUD/HoverArea.show()
	elif anim_name == "Final":
		$CanvasLayer/HUD/HoverArea3.show()
	if anim_name == "Exit":
		get_tree().reload_current_scene()


func _on_compelet_level_button_pressed():
	if !Global.gameManager.canCompleteStage:
		print('Cant Complete Stage')
		return
	Global.gameManager.OnCompleteStage()
