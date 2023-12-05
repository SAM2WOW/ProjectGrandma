extends Node
@onready var recipeUI = $CanvasLayer/RecipeUI

func _ready():
	if (Engine.is_editor_hint):
		get_window().size = Vector2i(960, 540);
	print("Main is ready")
		#updateStage(GameManager.currentStage)
		#GameManager.gameEnd.connect(onGameEnd())
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
	if  GameManager.CheckGameEnd():
		print("Complete last stage, game ends")
	else:
		GameManager.currentStage += 1
		updateStage(GameManager.currentStage)
		#GameManager.stageComplete.emit()

func onGameEnd():
	print("Game END")
	
