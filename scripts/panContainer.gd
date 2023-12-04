extends LiquidContainer
class_name PanContainer

var cookingObjects = [];

var cookingHeat : float = 0;
var targetHeat : float = cookingHeat;
var currentCookingState : IngredientState.CookingType;

@export var thickenCap : float = 3.0;
@export var thickenHeatThreshold : float = 0.5;
@export var thickenTimer : float = 10.0;
@export var liquidThreshold : int = 10;

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready();
	pass # Replace with function body.

func ObjectAction(event):
	super.ObjectAction(event);
	pouring=false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta);
	UpdateHeat(delta);
	CookIngredients(delta);
	ThickenFluids(delta);

func UpdateHeat(delta):
	if cookingHeat < targetHeat:
		cookingHeat = lerpf(cookingHeat, targetHeat, 5*delta)
		# print(cookingHeat)
	elif cookingHeat > targetHeat:
		cookingHeat = lerpf(cookingHeat, targetHeat, 0.2*delta)
		# print(cookingHeat)
	
func CookIngredients(delta):
	for ingredient in cookingObjects:
		ingredient.Cook(currentCookingState, cookingHeat, delta);

func ThickenFluids(delta):
	for liquid in liquidParticles.keys():
		if cookingHeat <= thickenHeatThreshold:
			liquidParticles[liquid] += delta;
		else:
			liquidParticles[liquid] -= delta;
		liquidParticles[liquid] = clamp(liquidParticles[liquid], 0, thickenCap);
		var timer = liquidParticles[liquid];
		var friction = Global.remap_range(timer, 0, thickenTimer, 0, thickenCap);
		friction = ease(friction/thickenCap, 4.8);
		PhysicsServer2D.body_set_param(liquid, PhysicsServer2D.BODY_PARAM_FRICTION, friction);

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	super._on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index);
	if body is Ingredient:
		cookingObjects.append(body);


func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	super._on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index);
	if body is Ingredient:
		cookingObjects.erase(body);

func OnLiquidEnter(id, body_rid):
	super.OnLiquidEnter(id, body_rid);
	var friction = PhysicsServer2D.body_get_param(body_rid, PhysicsServer2D.BODY_PARAM_FRICTION);
	var timer = Global.remap_range(friction,0,thickenCap,0,thickenTimer);
	liquidParticles[body_rid] = timer;
	if liquidParticles.size() > liquidThreshold:
		currentCookingState = IngredientState.CookingType.Boiled;
	
func OnLiquidExit(id, body_rid):
	super.OnLiquidExit(id, body_rid);
	if liquidParticles.size() < liquidThreshold:
		currentCookingState = IngredientState.CookingType.Fried;
