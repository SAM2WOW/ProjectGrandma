extends Node

func _ready():
	
	if (Engine.is_editor_hint):
		pass
		#get_window().size = Vector2i(960, 540);
	print("Main is ready")
		#updateStage(GameManager.currentStage)
		#GameManager.gameEnd.connect(onGameEnd())


func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		completeStage()


func _physics_process(delta):
	# offset the camera base on the mouse position to the center
	var mousePos = get_viewport().get_mouse_position()
	var center = get_viewport().get_visible_rect().size / 2
	var offset = (mousePos - center) / 50
	$Node2D/Camera2D.offset = lerp($Node2D/Camera2D.offset, offset, delta * 5)

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

func onGameEnd():
	print("Game END")
	
