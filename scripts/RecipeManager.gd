extends Node2D

@export var recipe : Array[RecipeComponent] = [];
var stageRecipes : Array =[]
const RecipeInfos = {
	"1": {
		"ingredients" = ["Apple","Soysauce"],
		"steps" = ["Cooking","Cooking"]
	},
	"2": {
		"ingredients" = ["Beef","Soysauce"],
		"steps" = ["Cooking","Quit"]
	},
	"3": {
		"ingredients" = ["Chicken","Soysauce"],
		"steps" = ["Cooking","Quit","Cooking"]
	},
	"4": {
		"ingredients" = ["Shrimp","Soysauce"],
		"steps" = ["Cooking"]
	},
}
func _ready():
	print("Recipe Manager is ready: ", self);
	recipe.sort_custom(func(x, y): return x.step < y.step);
	#for component in recipe:
		#print(component.description);
#func initRecipes():
	#print("Initialized Recipes")
	#for i in range(GameManager.stageNumbers):
		#var recipe = Recipe.new(RecipeInfos[str(i+1)]['ingredients'],RecipeInfos[str(i+1)]['steps'] )
		#stageRecipes.append(recipe)
	#
#func GetCurrentRecipe(stage: int) ->Recipe:
	#if (stageRecipes.size() == 0):
		#print("ERROR: Recipe Array is Empty")
	#return stageRecipes[stage-1]
#
#class Recipe:
	## Properties of the Recipe class
	#var ingredients : Array
	#var steps : Array
#
	#func _init(ingredients: Array, steps: Array):
		#self.ingredients = ingredients
		#self.steps = steps
