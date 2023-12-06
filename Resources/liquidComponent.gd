extends RecipeComponent
class_name LiquidComponent;

@export_category("Liquid Components")
@export var liquidType : Global.LiquidType;
@export var consistencyPoints : Array[LiquidPoints];

func GetDescription() -> String:
	return description;
