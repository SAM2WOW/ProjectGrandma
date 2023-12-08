extends Draggable

class_name LiquidContainer

@export var containedLiquid = {};
var pouring=false;
var rotateSpeed : float = 4.0;
@export var mixThresholdRatio = 0.25;

@export var liquidMix = {
	Global.LiquidType.Vinegar: 0.5, Global.LiquidType.SoySauce: 0.5
}

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready();
	containedLiquid.clear()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta);
	UpdatePouring(delta);
	
func UpdatePouring(delta):
	if pouring:
		var angle = 135;
		if Global.instantiationManager.pan.global_position.x < global_position.x:
			angle *= -1;
		rotation = lerp_angle(rotation, deg_to_rad(angle), rotateSpeed*delta);
	else:
		rotation = lerp_angle(rotation, deg_to_rad(0), rotateSpeed*2*delta);

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if !body_rid: return;
	var id = PhysicsServer2D.body_get_object_instance_id(body_rid);
	#if Global.currentStage == 1:
		#Global.textManager.Activate("Tofu");
	if Global.LiquidType.values().has(id):
		OnLiquidEnter(id, body_rid);

func ObjectAction(event):
	super.ObjectAction(event);
	pouring = event.pressed;

func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if !body_rid: return;
	var id = PhysicsServer2D.body_get_object_instance_id(body_rid);
	if Global.LiquidType.values().has(id):
		OnLiquidExit(id, body_rid);

func OnLiquidEnter(id, body_rid):
	if !containedLiquid.keys().has(id): containedLiquid[id] = {};
	if !Global.instantiationManager.liquidParticles.has(id) || !Global.instantiationManager.liquidParticles[id].has(body_rid):
		return
	containedLiquid[id][body_rid] = Global.instantiationManager.liquidParticles[id][body_rid];
	# print("amt: ", containedLiquid[id].keys().size())

func StartDrag():
	super.StartDrag();
	if Global.currentStage == 0:
		var c = Global.textManager.Activate("Item");
		if c.firstTime:
			followText = c;

func OnLiquidExit(id, body_rid):
	if !containedLiquid.keys().has(id): return;
	containedLiquid[id].erase(body_rid);

func CheckMixed() -> bool:
	var mixed = false;
	for liquid in liquidMix.keys():
		if !containedLiquid.has(liquid):
			mixed = false;
			break;
		var ratio = containedLiquid[liquid].size()/float(GetLiquidTotal());
		if ratio > liquidMix[liquid]-mixThresholdRatio && ratio < liquidMix[liquid]+mixThresholdRatio:
			mixed = true;
		else:
			mixed = false;
	return mixed;
	
func GetLiquidTotal() -> int:
	var total = 0;
	for val in containedLiquid.values():
		total += val.size();
	return total;


func _on_area_2d_input_event(viewport, event, shape_idx):
	pass
	#super._on_input_event(viewport, event, shape_idx);

#func _on_area_2d_mouse_entered():
	#super._on_mouse_entered();
#
#func _on_area_2d_mouse_exited():
	#super._on_mouse_exited();


func _on_body_entered(body):
	if not $AudioStreamPlayer2D.is_playing():
		
		# don't play if mass is too small
		if body == RigidBody2D:
			if body.get_mass() <= 20:
				return
		
		# get velocity
		var velocity = get_linear_velocity()
		var speed = clamp(velocity.length() / 500.0, 0.0, 1.0)
		var volume = lerp(0.0, 1.0, speed)
		var pitch = lerp(0.8, 1.2, speed)
		
		# set volume and pitch
		$AudioStreamPlayer2D.volume_db = linear_to_db(volume);
		$AudioStreamPlayer2D.pitch_scale = pitch;
		$AudioStreamPlayer2D.play()
