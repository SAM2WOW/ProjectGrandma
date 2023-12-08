extends Resource

class_name RecipeComponent;

@export var step : int;
@export var description : String;
@export var formatDescription : bool = false;
@export_category("Quantity")
@export var quantityPoints : Array[RecipeQuantity];
var inPot : bool = false;

var totalPoints : float = 0.0;
var totalQuantityPoints : float = 0.0;

func _ready():
	for quantity in quantityPoints:
		if quantity.quantityPoints > totalPoints:
			totalQuantityPoints = quantity.quantityPoints;
	totalPoints = totalQuantityPoints;

func GetQuantityRange(quantArr : Array[RecipeQuantity]) -> Array[RecipeQuantity]:
	if quantArr.size() == 0: return [];
	var quantityRange : Array[RecipeQuantity] = [];
	var maxPointIndex = 0;
	var i = 0;
	var ttl = 0;
	for quantity in quantArr:
		if quantity.quantityPoints > ttl:
			maxPointIndex = i;
			ttl = quantity.quantityPoints;
		i+=1;
	if maxPointIndex > 0 && quantArr[maxPointIndex-1].quantityPoints < 9999:
		quantityRange.append(quantArr[maxPointIndex-1]);
	quantityRange.append(quantArr[maxPointIndex]);
	return quantityRange;

func GetDescription() -> String:
	return description;

func GetQuantityPoints(size) -> RecipeQuantity:
	if quantityPoints.size() <= 0: return null;
	for quantity in quantityPoints:
		if size <= quantity.belowOrEqualQuantity:
			return quantity;
	return quantityPoints[0];
