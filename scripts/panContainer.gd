extends LiquidContainer
class_name PanContainer

var cookingObjects = [];

var cookingHeat : float = 0;
var targetHeat : float = cookingHeat;
var currentCookingState : IngredientState.CookingType;
var averageLiquidHeat : float = 0;

@export var thickenCap : float = 3.0;
@export var thickenHeatThreshold : float = 0.5;
@export var thickenTimer : float = 10.0;
@export var liquidThreshold : int = 20;
@export var heatUpCoefficient: float = 0.5;
@export var coolDownCoefficient: float = 0.3;

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready();
	Global.instantiationManager.pan = self;

func ObjectAction(event):
	super.ObjectAction(event);
	pouring=false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta);
	UpdateHeat(delta);
	UpdateFluids(delta);
	CookIngredients(delta);

func UpdateHeat(delta):
	if cookingHeat < targetHeat:
		cookingHeat += heatUpCoefficient * delta;
		# print(cookingHeat)
	elif cookingHeat > targetHeat:
		cookingHeat -= coolDownCoefficient * delta;
		# print(cookingHeat)
	cookingHeat = clamp(cookingHeat, 0, targetHeat);
	
func CookIngredients(delta):
	var heat = cookingHeat;
	if currentCookingState == IngredientState.CookingType.Boiled: heat = averageLiquidHeat;
	for ingredient in cookingObjects:
		ingredient.Cook(currentCookingState, heat, delta);

func UpdateFluids(delta):
	averageLiquidHeat = 0;
	var num = 0;
	for key in containedLiquid.keys():
		for liquid in containedLiquid[key].keys():
			if !liquid:
				containedLiquid[key].erase(liquid);
				continue;
			var state = containedLiquid[key][liquid];
			state.UpdateHeat(delta, cookingHeat);
			num+=1;
			averageLiquidHeat += state.currentHeat;
	averageLiquidHeat /= num;

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	super._on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index);
	if body is Ingredient:
		Global.textManager.Activate("Dad Note");
		Global.textManager.Activate("Mom Note");
		Global.textManager.Activate("Grandma Note");
		cookingObjects.append(body);


func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	super._on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index);
	if body is Ingredient:
		Global.textManager.Deactivate("Mom Note");
		cookingObjects.erase(body);

func OnLiquidEnter(id, body_rid):
	super.OnLiquidEnter(id, body_rid);
	if GetLiquidTotal() > liquidThreshold:
		currentCookingState = IngredientState.CookingType.Boiled;
	
func OnLiquidExit(id, body_rid):
	super.OnLiquidExit(id, body_rid);
	if GetLiquidTotal() < liquidThreshold:
		currentCookingState = IngredientState.CookingType.Fried;
