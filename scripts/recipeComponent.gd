extends Resource

class_name RecipeComponent;

@export_category("If Ingredient")
@export var ingredient : Ingredient.IngredientType;
@export var doneness : IngredientState.CookingType;

@export_category("If Liquid")
@export var liquidType : Global.LiquidType;
@export var liquidConsistency : float;

@export_category("Quantity")
@export var minQuantity : int;
@export var maxQuantity : int;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
