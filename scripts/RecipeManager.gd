extends Node

class Recipe:
	# Properties of the Recipe class
	var ingredients : Array
	var steps : Array

	func _init(ingredients: Array, steps: Array):
		self.ingredients = ingredients
		self.steps = steps
	

class RecipeManager:
	var stageRecipes : Array =[]
	const RecipeInfos = {
	"1": {
		"ingredients" = ["Apple","Soysauce"],
		"steps" = ["Cooking","Cooking"]
	},
	"2": {
		"ingredients" = ["Beef","Soysauce"],
		"steps" = ["Cooking","Quit"]
	}
}
	func _ready():
		
		initRecipes()
		print("Recipe Manager is ready")
		#print(stageRecipes.size())
		
	func initRecipes():
		for i in range(GameManager.stageNumbers):
			var recipe = Recipe.new(RecipeInfos[str(i)]['ingredients'],RecipeInfos[str(i)]['steps'] )
			stageRecipes.append(recipe)
	
	func GetCurrentRecipe(stage: int) ->Recipe:
		return stageRecipes[stage-1]
