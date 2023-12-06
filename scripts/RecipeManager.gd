extends Node2D

@export var recipe : Array[RecipeComponent] = [];
const heatDescriptions = {
	0.5: "Low Heat",
	0.75: "Medium Low",
	1.25: "Medium",
	1.5: "Medium High",
	2.0: "High"
};
var points : float;
var totalPoints : float;

func _ready():
	print("Recipe Manager is ready: ", self);
	recipe.sort_custom(func(x, y): return x.step < y.step);
	for component in recipe:
		component._ready();
		print(component.GetDescription());
	Global.recipeManager.CheckRecipePoints();
	
func CheckRecipePoints():
	totalPoints = 0.0;
	points = 0.0;
	for recipeStep in recipe:
		if recipeStep is IngredientComponent:
			CheckIngredients(recipeStep);
			# print(points[0].description);
		elif recipeStep is LiquidComponent:
			CheckLiquids(recipeStep);
		elif recipeStep is LiquidMixtureComponent:
			CheckLiquidMixture(recipeStep);
	print("points: ", points, "/", totalPoints)

func CheckIngredients(recipeStep : IngredientComponent) -> float:
	if !Global.instantiationManager.pan.cookingObjects.keys().has(recipeStep.ingredient):
		Global.instantiationManager.pan.cookingObjects[recipeStep.ingredient] = [];
	var objs = Global.instantiationManager.pan.cookingObjects[recipeStep.ingredient];
	var ingPoints = recipeStep.CheckIngredients(objs);
	var stepPoints = 0.0;
	totalPoints += recipeStep.totalPoints;
	for point in ingPoints:
		if !point: continue;
		if point is RecipePoints && objs.size() > 0:
			stepPoints += point.points;
		elif point is RecipeQuantity:
			stepPoints += point.quantityPoints;
		print(stepPoints,"/",recipeStep.totalPoints,": ",point.description);
		points += stepPoints;
	return stepPoints;

func CheckLiquids(recipeStep : LiquidComponent) -> float:
	return 0;

func CheckLiquidMixture(recipeStep : LiquidMixtureComponent) -> LiquidMixturePoints:
	var total = Global.instantiationManager.pan.GetLiquidTotal();
	return null;

# func CheckQuantity(quantityArr)
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
