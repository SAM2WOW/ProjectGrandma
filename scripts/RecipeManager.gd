extends Node2D

@export var recipe : Array[RecipeComponent] = [];
@export var resultText : Array[ResultText] = [];
@export var progressText : Array[ProgressText] = [];

@export_file var badFood : String;
@export_file var goodFood : String;

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
var stepText : String = "";
var noteText : String = "";
func _ready():
	Global.recipeManager = self
	InitRecipeText();

func InitRecipeText():
	recipe.sort_custom(func(x, y): return x.step < y.step);
	$RecipeNode/RecipeText.clear();
	$RecipeNode/IngredientText.clear();
	$EndNode.visible = false;
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
	
	# print("recipe text:\n", ingredientsText+recipeText);
	$RecipeNode/RecipeText.append_text(recipeText);
	$RecipeNode/IngredientText.append_text(ingredientsText)

func ToggleRecipeText(hide : bool):
	var a = 0;
	if hide: a = 1;
	create_tween().tween_property($RecipeNode, "modulate", Color(1,1,1,a), 0.5).set_ease(Tween.EASE_OUT);
	# visible = false;
	
func CheckRecipePoints():
	stepText = "";
	ToggleRecipeText(false);
	$EndNode/EndText.clear();
	$EndNode.visible = true;
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
	var resultsText = "[b]Results:\t%.0f / %.0f Points[/b]" % [points, totalPoints];
	stepText = resultsText + '\n' + stepText;
	
	GetFinalGrade();
	
	$EndNode/NoteText.clear();
	$EndNode/NoteText.append_text(noteText);
	print("scene score: ", Global.sceneScores[Global.currentStage])
	# print("points: %.1f" % (points/totalPoints));
	print("step text:\n", stepText);
	
	$EndNode/Smoke.set_emitting(true)

func GetFinalGrade():
	var score = float(points)/totalPoints
	$EndNode/EndText.append_text(stepText);
	if points/totalPoints <= 0.5:
		$EndNode/Sprite2D.texture = load(badFood);
	else:
		$EndNode/Sprite2D.texture = load(goodFood);
		
	var avgScore : float = 0;
	for i in Global.sceneScores.values():
		avgScore += i;
	avgScore /= Global.sceneScores.size();
	
	if score <= 0.5:
		print("really bad");
	elif score <= 0.75:
		print("ok")
	elif score <= 0.95:
		print("good");
	else:
		print("perfect");
	
	Global.sceneScores[Global.currentStage] = score;
	
func CheckIngredients(recipeStep : IngredientComponent) -> float:
	if !Global.instantiationManager.pan.cookingObjects.keys().has(recipeStep.ingredient):
		Global.instantiationManager.pan.cookingObjects[recipeStep.ingredient] = [];
	var objs = Global.instantiationManager.pan.cookingObjects[recipeStep.ingredient];
	var ingPoints = recipeStep.CheckIngredients(objs);
	var stepPoints = 0.0;
	totalPoints += recipeStep.totalPoints;
	var textArr = [];
	for point in ingPoints:
		if !point: continue;
		if point is RecipePoints && objs.size() > 0:
			textArr.append(point.description.capitalize());
			stepPoints += point.points;
		elif point is RecipeQuantity:
			textArr.append(point.description.capitalize());
			stepPoints += point.quantityPoints;
		print(stepPoints,"/",recipeStep.totalPoints,": ",point.description);
	if textArr.size() > 0: stepText += "* ";
	for t in textArr:
		stepText += t + ". ";
	stepText += "\n";
	points += stepPoints;
	return stepPoints;

func CheckLiquids(recipeStep : LiquidComponent) -> float:
	var consPoints = recipeStep.GetConsistencyPoints(Global.instantiationManager.pan.averageConsistency);
	totalPoints += recipeStep.totalPoints;
	var stepPoints = consPoints.points;
	points += stepPoints;
	stepText += "* " + consPoints.description.capitalize() + '\n';
	print(stepPoints,"/",recipeStep.totalPoints,": ",consPoints.description);
	return stepPoints;

func CheckLiquidMixture(recipeStep : LiquidMixtureComponent) -> float:
	print("check liquid mixture");
	var textArr = [];
	var mixPoints = recipeStep.CheckMixture(Global.instantiationManager.pan.containedLiquid);
	var stepPoints = 0.0;
	totalPoints += recipeStep.totalPoints;
	for point in mixPoints:
		if !point: continue;
		if point is RecipePoints && Global.instantiationManager.pan.GetLiquidTotal() > 0:
			textArr.append(point.description.capitalize());
			stepPoints+= point.points;
		elif point is RecipeQuantity:
			textArr.append(point.description.capitalize());
			stepPoints += point.quantityPoints;
		print(stepPoints,"/",recipeStep.totalPoints,": ",point.description);
	if textArr.size() > 0: stepText += "* ";
	for t in textArr:
		stepText += t + ". ";
	stepText += "\n";
	points += stepPoints;
	return stepPoints;

func _input(event):
	if event is InputEventKey && event.keycode == KEY_D:
		print("total: ", Global.instantiationManager.pan.GetLiquidTotal());
		Global.recipeManager.CheckRecipePoints();
		
func GetCurrentRecipeIngredients():
	for i in allIngredients:
		print("Ingredients:",i)
	for i in allLiquid:
		print("Liquid:", i)


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
