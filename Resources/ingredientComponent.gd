extends RecipeComponent
class_name IngredientComponent;

@export_category("If Ingredient")
@export var ingredient : Ingredient.IngredientType;
@export var donenessPoints : Array[IngredientPoints];
@export var showName : bool = false

func _ready():
	super._ready();
	var max = 0.0;
	for doneness in donenessPoints:
		if doneness.points > max:
			max = doneness.points;
	totalPoints += max;

func GetDescription() -> String:
	var parts = [];
	if !formatDescription: return description;
	if quantityPoints.size() >= 4:
		parts.append(quantityPoints[1].belowOrEqualQuantity+1);
		parts.append(quantityPoints[2].belowOrEqualQuantity);
	elif quantityPoints.size() >= 3:
		parts.append(quantityPoints[1].belowOrEqualQuantity+1);
	if showName:
		parts.append(Ingredient.IngredientType.keys()[ingredient]);
		
	return description % parts;

func CheckIngredients(cookedIngredients : Array) -> Array:
	var quantityPoints = GetQuantityPoints(cookedIngredients.size());
	if donenessPoints.size() <= 0: return [null, quantityPoints];
	cookedIngredients.sort_custom(func(x, y): return x.GetCurrentState().state < y.GetCurrentState().state);
	var judgeIngredients = [];
	if cookedIngredients.size() > 0:
		judgeIngredients = [cookedIngredients[0], cookedIngredients[cookedIngredients.size()-1]];
	var lowestPoints = null;#donenessPoints[0];
	# var lowestPoints = null;
	for donenessPoints : IngredientPoints in donenessPoints:
		if judgeIngredients.size() <= 0: continue;
		if ((donenessPoints.doneness == judgeIngredients[0].GetCurrentState().state || 
		donenessPoints.doneness == judgeIngredients[1].GetCurrentState().state)):
			if !lowestPoints:
				lowestPoints = donenessPoints;
			elif donenessPoints.points < lowestPoints.points:
				lowestPoints = donenessPoints;
	if !lowestPoints: lowestPoints = donenessPoints[0];
	return [lowestPoints, quantityPoints];
