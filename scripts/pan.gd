extends RigidBody2D

var cookingObjects = [];
var liquidParticles = {};

var cookingHeat = 1.0;
var thickenCap = 3.0;
var thickenHeatThreshold = 0.5;
var thickenTimer = 10.0;
@export var liquidThreshold : int = 10;
var currentCookingState : IngredientState.CookingType;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	CookIngredients(delta);
	ThickenFluids(delta);
	
func CookIngredients(delta):
	for ingredient in cookingObjects:
		ingredient.Cook(currentCookingState, delta);

func ThickenFluids(delta):
	for liquid in liquidParticles.keys():
		if cookingHeat <= thickenHeatThreshold:
			liquidParticles[liquid] += delta;
		else:
			liquidParticles[liquid] -= delta;
		liquidParticles[liquid] = clamp(liquidParticles[liquid], 0, thickenCap);
		var timer = liquidParticles[liquid];
		var friction = Global.remap_range(timer, 0, thickenTimer, 0, thickenCap);
		PhysicsServer2D.body_set_param(liquid, PhysicsServer2D.BODY_PARAM_FRICTION, friction);

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is Ingredient:
		cookingObjects.append(body);
	elif PhysicsServer2D.body_get_object_instance_id(body_rid) == 10:
		print("num liquid: ", liquidParticles.size())
		var friction = PhysicsServer2D.body_get_param(body_rid, PhysicsServer2D.BODY_PARAM_FRICTION);
		var timer = Global.remap_range(friction,0,thickenCap,0,thickenTimer);
		liquidParticles[body_rid] = timer;
		if liquidParticles.size() > liquidThreshold:
			print("boil");
			currentCookingState = IngredientState.CookingType.Boiled;


func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is Ingredient:
		cookingObjects.erase(body);
	elif PhysicsServer2D.body_get_object_instance_id(body_rid) == 10:
		liquidParticles.erase(body_rid);
		print("num liquid: ", liquidParticles.size())
		if liquidParticles.size() < liquidThreshold:
			print("fry");
			currentCookingState = IngredientState.CookingType.Fried;
