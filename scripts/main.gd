extends Node

var recipeMode = false

func _ready():
	
	print("Main is ready")
	Global.gameManager.stageComplete.connect(completeStage)
	Global.gameManager.gameEnd.connect(onGameEnd)
	$CanvasLayer/TestLevelText.text = "Level" + str(Global.currentStage+1)
	Global.recipeManager.GetCurrentRecipeIngredients()
	$CanvasLayer/HUD/CompeletLevelButton.modulate.a = 0.1
	
	MusicPlayer.fade_in() 
	MusicPlayer.play_music()
	Global.gameManager.ToggleCursor('normal')
	MusicPlayer.set_pitch(1);

func _process(delta):
	# offset the camera base on the mouse position to the center
	var mousePos = get_viewport().get_mouse_position()
	var center = get_viewport().get_visible_rect().size / 2
	var offset = (mousePos - center) / 50
	$Node2D/Camera2D.offset = lerp($Node2D/Camera2D.offset, offset, delta * 5)
	
	# update camera position base on ingredient mode
	
	
func completeStage():
	#print('Stage Complete')
	$CanvasLayer/HUD/CompeletLevelButton.modulate.a = 1
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($"Node2D/Cooking Scene/CompleteButton", "position", Vector2(-1398, 816), 1)
	

func _input(ev):
	if ev is InputEventKey and ev.keycode == KEY_K:
		onGameEnd()
	#if ev is InputEventKey and ev.keycode == KEY_ENTER:
		#if Global.gameManager.canCompleteStage:
			#Global.gameManager.OnCompleteStage()
	#if ev is InputEventKey and ev.keycode == KEY_S:
		#Global.gameManager.UpdateStage()


func onGameEnd():
	print("Game END")
	
	
	

func _on_hover_area_mouse_entered():
	recipeMode = true
	Global.recipeManager.ToggleRecipeText(true);
	$CanvasLayer/HUD/HoverArea.hide()
	$CanvasLayer/HUD/HoverArea2.show()
	
	$AnimationPlayer.play("Transition")
	$Sounds/SlideSound.play()


func _on_hover_area_2_mouse_entered():
	recipeMode = false
	Global.recipeManager.ToggleRecipeText(false);
	$CanvasLayer/HUD/HoverArea.show()
	$CanvasLayer/HUD/HoverArea2.hide()
	
	$AnimationPlayer.play_backwards("Transition")
	$Sounds/SlideSound.play()


func _on_hover_area_3_mouse_entered():
	$CanvasLayer/HUD/HoverArea3.hide()
	
	$AnimationPlayer.play_backwards("Exit")
	$Sounds/SlideSound.play()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Intro":
		$CanvasLayer/HUD/HoverArea.show()
		Global.recipeManager.ToggleRecipeText(false);
	elif anim_name == "Final":
		$CanvasLayer/HUD/HoverArea3.show()
	if anim_name == "Exit":
		Global.gameManager.OnCompleteStage()


func _on_compelet_level_button_pressed():
	if !Global.gameManager.canCompleteStage:
		return
	#
	$CanvasLayer/HUD/HoverArea.hide()
	$CanvasLayer/HUD/HoverArea2.hide()
	$AnimationPlayer.play("Final")
	$Sounds/SlideSound.play()
	Global.recipeManager.CheckRecipePoints();
	$CanvasLayer/HUD/RestartButton.hide()
	$CanvasLayer/HUD/CompeletLevelButton.hide()
	MusicPlayer.fade_out(true)
	
	await get_tree().create_timer(1).timeout
	$Sounds/CompleteSound.play()

func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_complete_button_input_event(viewport, event, shape_idx):
	if !event is InputEventMouseButton: return;
	if event.button_index == 1 && event.pressed:
		_on_compelet_level_button_pressed()


func _on_complete_button_mouse_entered():
	$"Node2D/Cooking Scene/CompleteButton/Sprite".set_scale(Vector2(1.05, 1.05))


func _on_complete_button_mouse_exited():
	$"Node2D/Cooking Scene/CompleteButton/Sprite".set_scale(Vector2(1, 1))


func _on_restart_button_input_event(viewport, event, shape_idx):
	if !event is InputEventMouseButton: return;
	if event.button_index == 1 && event.pressed:
		get_tree().reload_current_scene()


func _on_restart_button_mouse_entered():
	$"Node2D/Cooking Scene/RestartButton/Sprite".set_scale(Vector2(1.05, 1.05))
	$"Node2D/Cooking Scene/RestartButton/SpriteShadow".show()

func _on_restart_button_mouse_exited():
	$"Node2D/Cooking Scene/RestartButton/Sprite".set_scale(Vector2(1, 1))
	$"Node2D/Cooking Scene/RestartButton/SpriteShadow".hide()
