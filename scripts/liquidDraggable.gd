extends Draggable
# @export var generatorPoint: Marker2D;
@export var liquidType : Global.LiquidType;
var produceLiquid = false;
var rotateSpeed : float = 5.0;

func _ready():
	super._ready();
	$WaterGen.liquid_type = liquidType;

func ObjectAction(event):
	super.ObjectAction(event);
	produceLiquid = event.pressed;

func _physics_process(delta):
	super._physics_process(delta);
	UpdateLiquidGeneration(delta);

func _process(delta):
	super._process(delta);

func UpdateLiquidGeneration(delta):
	if produceLiquid:
		rotation = lerp_angle(rotation, deg_to_rad(-135), rotateSpeed*delta);
		if rotation < deg_to_rad(-90) || rotation > deg_to_rad(90):
			$WaterGen.generate = true;
		else:
			$WaterGen.generate = false;
	elif !produceLiquid && dragging:
		$WaterGen.generate = false;
		rotation = lerp_angle(rotation, deg_to_rad(0), rotateSpeed*delta);
