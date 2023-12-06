extends RecipeComponent
class_name LiquidMixtureComponent;

@export var targetLiquid : Global.LiquidType;
@export var liquidMixtureRecipe : Array[LiquidMixturePoints] = [];

func GetDescription() -> String:
	var parts = [];
	for part : LiquidMixturePoints in liquidMixtureRecipe:
		parts.append(Global.LiquidType.keys()[part.liquidType]);
	return description % parts;
