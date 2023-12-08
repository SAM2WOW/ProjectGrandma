extends Draggable
class_name Ingredient

enum IngredientType {
	Chicken, Garlic, Onion, Peppercorn, BayLeaf, Pepper, Mushroom, Broccoli
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
		if Global.currentStage == 0:
			var c = Global.textManager.Activate("OnBoil");
			# followText = c;
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
	# print("multiplier: ", GetCurrentState().typeInfluenceMultiplier[cookingType] * velocityMultiplier * heatMultiplier);
	cookingTimer += delta * GetCurrentState().typeInfluenceMultiplier[cookingType] * currentVelocityMult * heatMultiplier;
	if cookingTimer >= GetCurrentState().cookTimer:
		ChangeState(currentStateIndex+1);

func ChangeState(newIndex):
	if newIndex >= ingredientStates.size(): return;
	currentStateIndex = newIndex;
	cookingTimer = 0;
	print("new state ", IngredientState.CookingState.keys()[GetCurrentState().state]);
	if GetCurrentState().state == IngredientState.CookingState.Cooked:
		if Global.currentStage == 0:
			Global.textManager.Activate("3")
		elif Global.currentStage == 2:
			Global.textManager.Activate("4")
	

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

func StartDrag():
	super.StartDrag();
	if Global.currentStage == 0:
		var c = Global.textManager.Activate("Item2");
		followText = c;

func OnHover():
	super.OnHover();
	if Global.currentStage == 0:
		var c = Global.textManager.Activate("Item");
		if c.firstTime:
			followText = c;

func _on_interact_area_mouse_entered():
	super._on_interact_area_mouse_entered();
	if Global.currentStage == 0:
		var c = Global.textManager.Activate("Item");
		if c.firstTime:
			followText = c;
			# c.set_position(Vector2(global_position.x, global_position.y-50))
			
			

func _on_body_entered(body):
	if not $AudioStreamPlayer2D.is_playing():

		# get velocity
		var velocity = get_linear_velocity()
		var speed = clamp(velocity.length() / 500.0, 0.0, 1.0)
		var volume = lerp(0.0, 1.0, speed)
		var pitch = lerp(0.8, 1.2, speed)

		# set volume and pitch
		$AudioStreamPlayer2D.volume_db = linear_to_db(volume);
		$AudioStreamPlayer2D.pitch_scale = pitch;
		$AudioStreamPlayer2D.play()
