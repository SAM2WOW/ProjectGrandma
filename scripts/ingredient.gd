extends Draggable
class_name Ingredient

enum IngredientType {
	Chicken, Garlic, Onion, Peppercorn, BayLeaf
}
@export var ingredientType: IngredientType;
@export var ingredientStates: Array[IngredientState] = [];
@export var lowVelocityMultiplier: float = 1.0;
@export var highVelocityMultiplier: float = 0.2;
@export var cookingVelocityThresholds: float = 200;

var currentStateIndex: int = 0;
var cookingTimer: float = 0;
var currentVelocityMult: float = lowVelocityMultiplier;

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready();
	if !Global.instantiationManager.ingredients.has(ingredientType): 
		Global.instantiationManager.ingredients[ingredientType] = [];
	Global.instantiationManager.ingredients[ingredientType].append(self);
	ingredientStates.sort_custom(func(x, y): return x.state < y.state);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta);
	UpdateColor(delta);
	pass

func Cook(cookingType: IngredientState.CookingType, heatMultiplier, delta):
	if currentStateIndex >= ingredientStates.size()-1: return;
	if cookingType == IngredientState.CookingType.Boiled:
		var currMult = clamp(linear_velocity.length(), 0, cookingVelocityThresholds);
		currMult = Global.remap_range(currMult, 0, cookingVelocityThresholds, lowVelocityMultiplier, highVelocityMultiplier);
		if currMult < currentVelocityMult:
			currentVelocityMult = currMult;
		else:
			currentVelocityMult += delta * 0.1;
		currentVelocityMult = clamp(currentVelocityMult, highVelocityMultiplier, lowVelocityMultiplier);
	else:
		if linear_velocity.length() >= cookingVelocityThresholds:
			currentVelocityMult = highVelocityMultiplier;
		else:
			currentVelocityMult = lowVelocityMultiplier;
	# print("vel mult: ", currentVelocityMult);
	print(IngredientState.CookingType.keys()[cookingType]);
	# currentVelocityMult
	# print("multiplier: ", GetCurrentState().typeInfluenceMultiplier[cookingType] * velocityMultiplier * heatMultiplier);
	cookingTimer += delta * GetCurrentState().typeInfluenceMultiplier[cookingType] * currentVelocityMult * heatMultiplier;
	if cookingTimer >= GetCurrentState().cookTimer:
		ChangeState(currentStateIndex+1);

func ChangeState(newIndex):
	if newIndex >= ingredientStates.size(): return;
	currentStateIndex = newIndex;
	cookingTimer = 0;
	print("new state ", IngredientState.CookingState.keys()[GetCurrentState().state]);

func UpdateColor(delta):
	if currentStateIndex >= ingredientStates.size()-1: return;
	var timerRatio = ease(cookingTimer / GetCurrentState().cookTimer, 4.8);
	$Sprite2D.modulate = GetCurrentState().stateColor.lerp(ingredientStates[currentStateIndex+1].stateColor, timerRatio);

func GetState(checkState: IngredientState.CookingState):
	for ingState in ingredientStates:
		if (ingState.state == checkState):
			return ingState;
	return null;

func GetCurrentState():
	return ingredientStates[currentStateIndex];

func MultiplyScale(scaleMult: float):
	$Sprite2D.scale *= scaleMult;
	$Sprite2DShadow.set_scale($Sprite2D.get_scale())
	$CollisionShape2D.scale *= scaleMult;
