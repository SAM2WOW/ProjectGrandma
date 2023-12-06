extends Draggable
# @export var generatorPoint: Marker2D;
@export var liquidType : Global.LiquidType;
var produceLiquid = false;
var rotateSpeed : float = 5.0;
var bottleImage = [
	"res://arts/ingredients/soy sauce.png",
	"res://arts/ingredients/vinegar.png",
	"res://arts/ingredients/vinegar.png",
]

func _ready():
	super._ready();
	$WaterGen.liquid_type = liquidType;
	
	var texture = load(bottleImage[liquidType])
	$Sprite2D.set_texture(texture)
	$Sprite2DShadow.set_texture(texture)

func ObjectAction(event):
	super.ObjectAction(event);
	produceLiquid = event.pressed;
	
	if produceLiquid:
		$Pouring.play()
	else:
		$Pouring.stop()

func _physics_process(delta):
	super._physics_process(delta);
	UpdateLiquidGeneration(delta);
	
	# set volume base on rotation
	$Pouring.set_volume_db(linear_to_db(remap(rotation, -2.35, 0.0, 1.0, 0.0)))

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


func _on_body_entered(body):
	if not $AudioStreamPlayer2D.is_playing():

		# get velocity
		var velocity = get_linear_velocity()
		var speed = clamp(velocity.length() / 500.0, 0.0, 1.0)
		var volume = lerp(0.7, 1.0, speed)
		var pitch = lerp(0.8, 1.2, speed)

		# set volume and pitch
		$AudioStreamPlayer2D.volume_db = -80.0 + 80.0 * volume;
		$AudioStreamPlayer2D.pitch_scale = pitch;
		$AudioStreamPlayer2D.play()
