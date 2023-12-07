extends Resource

class_name RecipeComponent;

@export var step : int;
@export var description : String;
@export var formatDescription : bool = true;
@export_category("Quantity")
@export var quantityPoints : Array[RecipeQuantity];

var totalPoints : float = 0.0;

func _ready():
	for quantity in quantityPoints:
		if quantity.quantityPoints > totalPoints:
			totalPoints = quantity.quantityPoints;

func GetDescription() -> String:
	return description;

func GetQuantityPoints(size) -> RecipeQuantity:
	if quantityPoints.size() <= 0: return null;
	for quantity in quantityPoints:
		if size <= quantity.belowOrEqualQuantity:
			return quantity;
	return quantityPoints[0];
