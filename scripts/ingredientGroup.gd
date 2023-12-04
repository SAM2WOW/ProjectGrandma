extends Node2D

# @export var ingredientType: 
@export_file var ingredientPath: String;
@export var numIngredients: int;
@export var sizeVarianceMultiplier: float = 0.2;
var ingredients = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	if ingredientPath == "": return;
	for i in numIngredients:
		var ingredient = load(ingredientPath).instantiate();
		var randPos = Global.randv_circle(0, $Area2D/CollisionShape2D.shape.radius);
		ingredient.global_position = global_position + randPos;
		ingredient.MultiplyScale(1+randf_range(-sizeVarianceMultiplier, sizeVarianceMultiplier));
		InstantiationManager.add_child(ingredient);
		ingredients.append(ingredient);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
