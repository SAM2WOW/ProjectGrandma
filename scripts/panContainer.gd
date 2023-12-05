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
	for key in containedLiquid.keys():
		for liquid in containedLiquid[key].values():
			liquid.Thicken(delta, cookingHeat);

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
	if GetLiquidTotal() > liquidThreshold:
		currentCookingState = IngredientState.CookingType.Boiled;
	
func OnLiquidExit(id, body_rid):
	super.OnLiquidExit(id, body_rid);
	if GetLiquidTotal() < liquidThreshold:
		currentCookingState = IngredientState.CookingType.Fried;
