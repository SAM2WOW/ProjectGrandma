extends Node
@onready var recipeUI = $CanvasLayer/RecipeUI

var currentRecipet
func _ready():
	if (Engine.is_editor_hint):
		get_window().size = Vector2i(960, 540);
		#updateStage(GameManager.currentStage)
func _process(delta):
	pass

func updateStage(stage: int):
	#Instantiate cook scene

	#Get current stage's receipe
	print('Updated stage')
	currentRecipet = GameManager.recipeManager.GetCurrentRecipe(stage)
	recipeUI.updateIngredientLable(currentRecipet.ingredients)

	
func completeStage():
	if  GameManager.CheckGameEnd():
		print("Complete last stage, game ends")
	else:
		GameManager.currentStage += 1
		updateStage(GameManager.currentStage)
		GameManager.stageComplete.emit()

	
