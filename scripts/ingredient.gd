extends Draggable
class_name Ingredient

enum IngredientType {
	Chicken, Garlic, Onion, Peppercorn, BayLeaf
}
@export var ingredientType: IngredientType;
@export var ingredientStates: Array[IngredientState] = [];
var currentStateIndex: int = 0;
var cookingTimer: float = 0;
var cookingVelocityThresholds: float = 100;

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready();
	ingredientStates.sort_custom(func(x, y): return x.state < y.state);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta);
	UpdateColor(delta);
	pass

func Cook(cookingType: IngredientState.CookingType, heatMultiplier, delta):
	if currentStateIndex >= ingredientStates.size()-1: return;
	var velocityMultiplier = 1.0;
	if linear_velocity.length() > cookingVelocityThresholds:
		velocityMultiplier = 0.2;
	# print(GetCurrentState().cookTimer);
	cookingTimer += delta * GetCurrentState().typeInfluenceMultiplier[cookingType] * velocityMultiplier * heatMultiplier;
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
	$CollisionShape2D.scale *= scaleMult;
