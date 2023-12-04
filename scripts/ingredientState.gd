extends Resource
class_name IngredientState

enum CookingState {Undercooked, Cooked, Overcooked, Burnt};
enum CookingType {Fried, Boiled};
@export var state : CookingState = CookingState.Cooked;
@export var cookTimer : float = 0;
@export var typeInfluenceMultiplier = {CookingType.Fried : 1.0, CookingType.Boiled : 1.0};
@export var stateColor: Color = Color.WHITE;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
