extends RecipeComponent
class_name LiquidMixtureComponent;

@export var targetLiquid : Global.LiquidType;
@export var liquidMixtureRecipe : Array[LiquidMixturePoints] = [];
var mixtureDict = {};

func _ready():
	super._ready();
	for mixPoints in liquidMixtureRecipe:
		if !mixtureDict.keys().has(mixPoints.liquidType):
			mixtureDict[mixPoints.liquidType] = [];
		mixtureDict[mixPoints.liquidType].append(mixPoints);
		
	for arr in mixtureDict.values():
		arr.sort_custom(func(x, y): return x.lessOrEqualRatio < y.lessOrEqualRatio);
	
	for typePoints in mixtureDict.values():
		var max = 0.0;
		for typePoint in typePoints:
			if typePoint.points > max:
				max = typePoint.points;
		totalPoints += max;

func GetDescription() -> String:
	if !formatDescription: return description;
	var parts = [];
	for part : LiquidMixturePoints in liquidMixtureRecipe:
		parts.append(Global.LiquidType.keys()[part.liquidType]);
	return description % parts;

func CheckMixture(containedLiquid : Dictionary) -> Array:
	var size = 0;
	for liqRids in containedLiquid.values(): # dict of RID : state
		size += liqRids.keys().size();
	var retArr = [];
	var quantityPoints = GetQuantityPoints(size);
	if liquidMixtureRecipe.size() <= 0: return [null, quantityPoints];
	# elif size
	if size <= 0:
		for arr in mixtureDict.values(): retArr.append(arr[0]);
		retArr.append(quantityPoints);
		return retArr;

	for mixType in mixtureDict.keys():
		var mixPoints = mixtureDict[mixType];
		if !containedLiquid.keys().has(mixType): 
			retArr.append(mixPoints[0]);
			continue;
		var typeArr = containedLiquid[mixType].keys();
		for mixPoint in mixPoints:
			if float(typeArr.size())/size <= mixPoint.lessOrEqualRatio:
				retArr.append(mixPoint);
				break;
	retArr.append(quantityPoints);
	return retArr;
