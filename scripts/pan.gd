extends RigidBody2D

var cookingObjects = [];
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	CookIngredients(delta);
	
func CookIngredients(delta):
	for ingredient in cookingObjects:
		ingredient.Cook(IngredientState.CookingType.Fried, delta);

func _on_area_2d_body_entered(body):
	if !body is Ingredient: return;
	cookingObjects.append(body);

func _on_area_2d_body_exited(body):
	if !body is Ingredient: return;
	cookingObjects.erase(body);
