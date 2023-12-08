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
var allIngredients : Array
var allLiquid : Array
func _ready():
	recipe.sort_custom(func(x, y): return x.step < y.step);
	$RecipeText.clear();
	$IngredientText.clear();
	var recipeText : String = "[b]Steps[/b]";
	var ingredientsText : String = "[b]Ingredients[/b]\n";
	var prevStep = -1;
	for component in recipe:
		component._ready();
		var desc = component.GetDescription().strip_edges(true,true);
		print(prevStep, " vs ", component.step)
		if component.step >= 0 && component.step != prevStep:
			recipeText += "\n* " +desc + '. ';
		elif component.step == prevStep:
			recipeText += desc + '. ';
		# $RecipeText.add_text(component.GetDescription() + "\n");
		print(desc);
		if component is IngredientComponent:
			var quantRange = component.GetQuantityRange(component.quantityPoints);
			var quantityText : String = str(quantRange[0].belowOrEqualQuantity+1);
			if quantRange.size() > 1: 
				quantityText += " - " + str(quantRange[1].belowOrEqualQuantity);
			ingredientsText += " * " +Ingredient.IngredientType.keys()[component.ingredient] + ": " + quantityText + '\n';
			if(!allIngredients.has(component.ingredient)):
				allIngredients.append(component.ingredient)
		elif component is LiquidMixtureComponent:
			for liquid in component.mixtureDict.keys():
				# var quantRange = component.GetQuantityRange(component.mixtureDict[liquid]);
				ingredientsText += " * " + Global.LiquidType.keys()[liquid] + ": " + "1/2 Cup\n";
				#if(!allLiquid.has(liquid)):
					#allLiquid.append(liquid)
			for i:LiquidMixturePoints in component.liquidMixtureRecipe:
				# ingredientsText += " * " + Global.LiquidType.keys()[i.liquidType] + ": " + "1/2 Cup\n";
				if(!allLiquid.has(i.liquidType)):
					allLiquid.append(i.liquidType)
		prevStep = component.step;
	
	print("recipe text:\n", ingredientsText+recipeText);
	$RecipeText.append_text(recipeText);
	$IngredientText.append_text(ingredientsText)
	
	
	
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
	var consPoints = recipeStep.GetConsistencyPoints(Global.instantiationManager.pan.averageConsistency);
	totalPoints += recipeStep.totalPoints;
	var stepPoints = consPoints.points;
	points += stepPoints;
	print(stepPoints,"/",recipeStep.totalPoints,": ",consPoints.description);
	return stepPoints;

func CheckLiquidMixture(recipeStep : LiquidMixtureComponent) -> float:
	print("check liquid mixture");
	var mixPoints = recipeStep.CheckMixture(Global.instantiationManager.pan.containedLiquid);
	var stepPoints = 0.0;
	totalPoints += recipeStep.totalPoints;
	for point in mixPoints:
		if !point: continue;
		if point is RecipePoints && Global.instantiationManager.pan.GetLiquidTotal() > 0:
			stepPoints+= point.points;
		elif point is RecipeQuantity:
			stepPoints += point.quantityPoints;
		print(stepPoints,"/",recipeStep.totalPoints,": ",point.description);
	points += stepPoints;
	return stepPoints;

func _input(event):
	if event is InputEventKey && event.keycode == KEY_D:
		print("total: ", Global.instantiationManager.pan.GetLiquidTotal());
		Global.recipeManager.CheckRecipePoints();
		

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
