extends Node

var recipeMode = false

func _ready():
	
	if (Engine.is_editor_hint):
		# get_window().size = Vector2i(960, 540);
		pass
	print("Main is ready")
		#updateStage(GameManager.currentStage)
		#GameManager.gameEnd.connect(onGameEnd())
 

func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		completeStage()

#func _physics_process(delta):
	# offset the camera base on the mouse position to the center
	var mousePos = get_viewport().get_mouse_position()
	var center = get_viewport().get_visible_rect().size / 2
	var offset = (mousePos - center) / 50
	$Node2D/Camera2D.offset = lerp($Node2D/Camera2D.offset, offset, delta * 5)
	
	# update camera position base on ingredient mode
	

func updateStage(stage: int):
	#Instantiate cook scene

	#Get current stage's receipe
	print('Updated stage')
	# currentRecipet = GameManager.recipeManager.GetCurrentRecipe(stage)
	# recipeUI.updateIngredientLable(currentRecipet.ingredients)

	
func completeStage():
	if  Global.gameManager.CheckGameEnd():
		print("Complete last stage, game ends")
	else:
		Global.gameManager.currentStage += 1
		updateStage(Global.gameManager.currentStage)
		#GameManager.stageComplete.emit()


func _input(ev):
	if ev is InputEventKey and ev.keycode == KEY_K:
		onGameEnd()


func onGameEnd():
	print("Game END")
	
	$CanvasLayer/HUD/HoverArea.hide()
	$CanvasLayer/HUD/HoverArea2.hide()
	
	$AnimationPlayer.play("Final")
	

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
