extends Node

func _ready():
	
	if (Engine.is_editor_hint):
		get_window().size = Vector2i(960, 540);
	print("Main is ready")
		#updateStage(GameManager.currentStage)
	Global.gameManager.gameEnd.connect(onGameEnd())
func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		completeStage()

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
	
