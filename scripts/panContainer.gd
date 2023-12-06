extends LiquidContainer
class_name PanContainer

var cookingObjects = {};

var cookingHeat : float = 0;
var targetHeat : float = cookingHeat;
var currentCookingState : IngredientState.CookingType;
var averageLiquidHeat : float = 0;
var averageConsistency : float = 0;
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

func _physics_process(delta):
	super._physics_process(delta);

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
	for type in cookingObjects.values():
		for ingredient in type:
			# print(heat)
			ingredient.Cook(currentCookingState, heat, delta);

func UpdateFluids(delta):
	averageLiquidHeat = 0;
	averageConsistency = 0;
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
			averageConsistency += state.consistency;
	averageLiquidHeat /= num;
	averageConsistency /= num;
	print("average consistency: ", averageConsistency);

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	super._on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index);
	if body is Ingredient:
		if !cookingObjects.keys().has(body.ingredientType): 
			cookingObjects[body.ingredientType] = [];
		if !cookingObjects[body.ingredientType].has(body):
			cookingObjects[body.ingredientType].append(body);


func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	super._on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index);
	if body is Ingredient:
		cookingObjects[body.ingredientType].erase(body);

func OnLiquidEnter(id, body_rid):
	super.OnLiquidEnter(id, body_rid);
	if GetLiquidTotal() > liquidThreshold:
		currentCookingState = IngredientState.CookingType.Boiled;
	
func OnLiquidExit(id, body_rid):
	super.OnLiquidExit(id, body_rid);
	if GetLiquidTotal() < liquidThreshold:
		currentCookingState = IngredientState.CookingType.Fried;
