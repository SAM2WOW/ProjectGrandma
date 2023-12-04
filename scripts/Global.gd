extends Node

enum LiquidType {SoySauce, Vinegar};

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
