extends Draggable
# @export var generatorPoint: Marker2D;

var produceLiquid = false;

func _ready():
	super._ready();

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
		if rotation < deg_to_rad(-90) || rotation > deg_to_rad(90):
			$WaterGen.generate = true;
		else:
			$WaterGen.generate = false;
	elif !produceLiquid && dragging:
		$WaterGen.generate = false;
		rotation = lerp_angle(rotation, deg_to_rad(0), 5*delta);
