extends RigidBody2D

var cookingObjects = [];
var liquidParticles = [];
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	CookIngredients(delta);
	
func CookIngredients(delta):
	for ingredient in cookingObjects:
		ingredient.Cook(IngredientState.CookingType.Fried, delta);


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is Ingredient:
		cookingObjects.append(body);
	elif PhysicsServer2D.body_get_object_instance_id(body_rid) == 10:
		liquidParticles.append(body_rid);
		# print("num liquid: ", liquidParticles.size())


func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is Ingredient:
		cookingObjects.erase(body);
	elif PhysicsServer2D.body_get_object_instance_id(body_rid) == 10:
		liquidParticles.erase(body_rid);
		# print("num liquid: ", liquidParticles.size())
