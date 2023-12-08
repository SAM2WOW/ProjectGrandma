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
	
	match liquidType:
		0:
			$WaterGen/SplashParticle.set_modulate(Color("2f1300"))
		1:
			$WaterGen/SplashParticle.set_modulate(Color("ffd12b"))
		2:
			$WaterGen/SplashParticle.set_modulate(Color("2f1300"))

func StartDrag():
	super.StartDrag();
	if Global.currentStage == 0:
		var c = Global.textManager.Activate("LiquidDrag");
		if c.firstTime:
			followText = c;

func ObjectAction(event):
	super.ObjectAction(event);
	produceLiquid = event.pressed;
	if produceLiquid:
		$Pouring.play()
		$WaterGen/SplashParticle.set_emitting(true)
	else:
		$Pouring.stop()
		$WaterGen/SplashParticle.set_emitting(false)

func StopDrag():
	if produceLiquid:
		produceLiquid = false;
		$Pouring.stop()
		$WaterGen/SplashParticle.set_emitting(false)
	
	super.StopDrag();

func _physics_process(delta):
	super._physics_process(delta);
	UpdateLiquidGeneration(delta);
	
	# set volume base on rotation
	$Pouring.set_volume_db(linear_to_db(remap(rotation, -2.35, 0.0, 1.0, 0.0)))

func _process(delta):
	super._process(delta);

func UpdateLiquidGeneration(delta):
	if Global.instantiationManager.numParticles >= Global.instantiationManager.maxNumParticles:
		produceLiquid = false;
	if produceLiquid:
		rotation = lerp_angle(rotation, deg_to_rad(-135), rotateSpeed*delta);
		if $WaterGen.current_particle_count >= $WaterGen.max_water_particles:
			$Pouring.stop()
			$WaterGen/SplashParticle.set_emitting(false)
		if rotation < deg_to_rad(-90) || rotation > deg_to_rad(90):
			$WaterGen.generate = true;
		else:
			$WaterGen.generate = false;
	elif !produceLiquid:
		$Pouring.stop()
		$WaterGen/SplashParticle.set_emitting(false)
		$WaterGen.generate = false;
		if dragging:
			rotation = lerp_angle(rotation, deg_to_rad(0), rotateSpeed*delta);

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
