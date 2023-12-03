extends Draggable
# @export var generatorPoint: Marker2D;

var produceLiquid = false;
@export var generator : LiquidGenerator;

func _ready():
	super._ready();
	if !generator: generator = get_node("WaterGen");

func ObjectAction(event):
	super.ObjectAction(event);
	if event.pressed:
		produceLiquid = true;
	else:
		produceLiquid = false;

func _physics_process(delta):
	super._physics_process(delta);
	UpdateLiquidGeneration(delta);

func _process(delta):
	super._process(delta);

func UpdateLiquidGeneration(delta):
	if produceLiquid:
		rotation = lerp_angle(rotation, deg_to_rad(-135), 5*delta);
		if rotation < deg_to_rad(-90) && rotation > deg_to_rad(-180):
			generator.generate = true;
		else:
			generator.generate = false;
	elif !produceLiquid && dragging:
		generator.generate = false;
		rotation = lerp_angle(rotation, deg_to_rad(0), 5*delta);
