extends RecipeComponent
class_name LiquidComponent;

@export_category("Liquid Components")
@export var liquidType : Global.LiquidType;
@export var consistencyPoints : Array[LiquidPoints];

func _ready():
	super._ready();
	var max = 0.0;
	consistencyPoints.sort_custom(func(x,y): return x.belowEqualConsistency < y.belowEqualConsistency);
	for consistency in consistencyPoints:
		if consistency.points > max:
			max = consistency.points;
	totalPoints += max;

func GetDescription() -> String:
	return description;

func GetConsistencyPoints(liquidConsistency : float) -> LiquidPoints:
	for points in consistencyPoints:
		if liquidConsistency <= points.points:
			return points;
	return consistencyPoints[consistencyPoints.size()-1];
