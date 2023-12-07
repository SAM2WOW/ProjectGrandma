extends Node

enum LiquidType {SoySauce, Vinegar, AbodoSauce};

@onready var recipeManager;
@onready var gameManager;
@onready var instantiationManager;
@onready var textManager;

# Called when the node enters the scene tree for the first time.
func _ready():
	recipeManager = get_tree().get_first_node_in_group("RecipeManager");
	gameManager = get_tree().get_first_node_in_group("GameManager");
	instantiationManager = get_tree().get_first_node_in_group("InstantiationManager");
	textManager = get_tree().get_first_node_in_group("TextManager");
	print("Recipe Manager Size: ", recipeManager.recipe.size()); 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func remap_range(value, InputA, InputB, OutputA, OutputB):
	return(value - InputA) / (InputB - InputA) * (OutputB - OutputA) + OutputA

func randv_circle(min_radius := 1.0, max_radius := 1.0) -> Vector2:
	var rng = RandomNumberGenerator.new();
	var r2_max := max_radius * max_radius
	var r2_min := min_radius * min_radius
	var r := sqrt(rng.randf() * (r2_max - r2_min) + r2_min)
	var t := rng.randf() * TAU
	return Vector2(r, 0).rotated(t)
