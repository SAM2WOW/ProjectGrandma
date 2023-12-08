extends LiquidContainer
class_name PanContainer

var cookingObjects = {};

var cookingHeat : float = 0;
var targetHeat : float = cookingHeat;
var currentCookingState : IngredientState.CookingType;
var averageLiquidHeat : float = 0;
var averageConsistency : float = 0;
var averageLiquidVelocity : float = 0;
var averageIngredientVelocity : float = 0;

@export var liquidThreshold : int = 20;
@export var heatUpCoefficient: float = 0.2;
@export var coolDownCoefficient: float = 0.2;

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
	
	# update audio
	if cookingObjects.has("Ingredient"):
		print(cookingObjects["Ingredient"].size())
		if cookingObjects["Ingredient"].size() > 0 and cookingHeat > 0.0:
			if not $Boiling.is_playing():
				$Boiling.play()
				$Frying.play()
				
			var heatWeight =  (cookingHeat / 2)
			var boiledWeight = clamp(GetLiquidTotal() / liquidThreshold, 0.0, 1.0)
			$Boiling.set_volume_db(linear_to_db(boiledWeight * heatWeight))
			$Frying.set_volume_db(linear_to_db((1 - boiledWeight) * heatWeight))
			
			var deepWaterWeight = clamp(GetLiquidTotal() / 400.0, 0.0, 1.0)
			$Boiling.set_pitch_scale(lerp(1.0, 0.76, deepWaterWeight))
		else:
			if $Boiling.is_playing():
				$Boiling.stop()
				$Frying.stop()

func _physics_process(delta):
	super._physics_process(delta);

func UpdateHeat(delta):
	if cookingHeat < targetHeat:
		cookingHeat += heatUpCoefficient * delta;
		# print(cookingHeat)
	elif cookingHeat > targetHeat:
		cookingHeat -= coolDownCoefficient * delta;
		# print(cookingHeat)
	cookingHeat = clamp(cookingHeat, 0, 2);
	# print("cooking heat: ", cookingHeat);
	
func CookIngredients(delta):
	var heat = cookingHeat;
	averageIngredientVelocity = 0;
	var total = 0;
	if currentCookingState == IngredientState.CookingType.Boiled: heat = averageLiquidHeat;
	for type in cookingObjects.values():
		for ingredient in type:
			total += 1;
			averageIngredientVelocity += ingredient.linear_velocity.length();
			# print(heat)
			ingredient.Cook(currentCookingState, heat, delta);
	averageIngredientVelocity /= total;

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
			averageLiquidVelocity += state.currentVelocity.length();
	if num != 0:
		averageLiquidHeat /= num;
		averageConsistency /= num;
		averageLiquidVelocity /= num;
	else:
		averageLiquidHeat = 0;
		averageConsistency = 0;
		averageLiquidVelocity = 0;
	# print("average consistency: ", averageConsistency);

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	super._on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index);
	if body is Ingredient:
		Global.gameManager.AddObjectToPan("Ingredient",body.ingredientType)
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
	Global.gameManager.AddObjectToPan("Liquid",id)
	if GetLiquidTotal() > liquidThreshold:
		currentCookingState = IngredientState.CookingType.Boiled;
	
func OnLiquidExit(id, body_rid):
	super.OnLiquidExit(id, body_rid);
	if GetLiquidTotal() < liquidThreshold:
		currentCookingState = IngredientState.CookingType.Fried;

func GetCookingSize() -> int:
	var total = 0;
	for i in cookingObjects.values():
		total+= i.size();
	# print("total: ", total);
	return total;
