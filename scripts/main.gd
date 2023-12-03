extends Node
@onready var recipeUI = $CanvasLayer/RecipeUI
@onready var gameManager = get_node("/root/GameManager")

#stage number

func _ready():
	if (Engine.is_editor_hint):
		get_window().size = Vector2i(960, 540);
	updateStage(0)	

func _process(delta):
	pass

func updateStage(stage: int):
	#Instantiate cook scene
	#Get current stage's receipe
	#var recipe = recipeManager.stageRecipe[stage]
	#for i in recipe.ingredients:
		#print(i)
		pass

func OnCompleteStage():
	gameManager.currentStage +=1
	
