extends Resource;
class_name LiquidState;

@export var liquidType : Global.LiquidType;
@export var maxThickenTimer : float = 23;
@export var consistencyCap: float = 3;
@export var thickenHeatThreshold: float = 0.7;
@export var unthickenHeatThreshold: float = 1.4;
@export var minThickenHeatThreshold: float = 0.1;
@export var maxFriction: float = 5;
@export var maxMass: float = 0.3;#0.15;
@export var heatUpCoefficient: float = 0.2;
@export var coolDownCoefficient: float = 0.1;

var baseFriction : float = 0;
var baseMass : float = 0;
var color : Color;
var consistency : float = 0;
var thickenTimer : float;
var bodyRid : RID;
var shapeRid : RID;
var renderRid : RID;
var currentHeat : float = 0;
var targetHeat : float;
var maxThickenVelocity = 200.0;
var minVelocityMultiplier = 0.2;
var velocityMultiplierCap = 2.0;

var liquidComposition = {};
var collidedLiquids = {};
var pinRids = {};
var currentVelocity : Vector2;

func _init(type, body_rid : RID, render_rid: RID, _color: Color):
	liquidType = type;
	bodyRid = body_rid;
	renderRid = render_rid;
	shapeRid = PhysicsServer2D.body_get_shape(bodyRid, 0);
	baseFriction = PhysicsServer2D.body_get_param(bodyRid, PhysicsServer2D.BODY_PARAM_FRICTION);
	baseMass = PhysicsServer2D.body_get_param(bodyRid, PhysicsServer2D.BODY_PARAM_MASS);
	color = _color;
	# color = RenderingServer.self_m
	thickenTimer = Global.remap_range(consistency,0,consistencyCap,0,maxThickenTimer);
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Thicken(delta, heat):
	currentVelocity = PhysicsServer2D.body_get_state(bodyRid, PhysicsServer2D.BODY_STATE_LINEAR_VELOCITY);
	var velMagnitude = currentVelocity.length();
	velMagnitude = clamp(velMagnitude, 0, maxThickenVelocity);
	var velocityMultiplier = remap(velMagnitude, 0, maxThickenVelocity, minVelocityMultiplier, velocityMultiplierCap);
	# print("vel: ", velocity.length());
	# print("vel mult: ", velocityMultiplier);
	if heat <= thickenHeatThreshold && heat >= minThickenHeatThreshold:
		var thickenSpeed = Global.remap_range(heat, minThickenHeatThreshold, thickenHeatThreshold, 1, 0.2);
		thickenTimer += delta * thickenSpeed * velocityMultiplier;
	elif heat >= unthickenHeatThreshold:
		thickenTimer -= delta * heat * 0.3;
	thickenTimer = clamp(thickenTimer, 0, maxThickenTimer);
	consistency = ease(thickenTimer/maxThickenTimer, 3.0);
	var friction = baseFriction+((maxFriction-baseFriction) * consistency);
	var mass = baseMass+((maxMass-baseMass) * consistency);
	# print(friction, ", ", mass);
	PhysicsServer2D.body_set_param(bodyRid, PhysicsServer2D.BODY_PARAM_FRICTION, friction);
	PhysicsServer2D.body_set_param(bodyRid, PhysicsServer2D.BODY_PARAM_MASS, mass);

func UpdateHeat(delta, heat):
	targetHeat = heat;
	if currentHeat < targetHeat:
		currentHeat += heatUpCoefficient * delta;
	elif currentHeat > targetHeat:
		currentHeat -= coolDownCoefficient * delta;
	heat = clamp(heat, 0, targetHeat);
	Thicken(delta, heat);

func MixLiquid(col : LiquidState):
	if !collidedLiquids.keys().has(col.liquidType): collidedLiquids[col.liquidType] = {};
	collidedLiquids[col.liquidType][col.bodyRid] = col;
	
	color = color.lerp(col.color, 0.5);
	col.color = col.color.lerp(color, 0.5);
	RenderingServer.canvas_item_set_self_modulate(renderRid, color);
	RenderingServer.canvas_item_set_self_modulate(col.renderRid, col.color);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func SUPERBUGGYATTRACTCODE(col : LiquidState):
	if !collidedLiquids[col.liquidType].has(col.bodyRid):
		var joint = PhysicsServer2D.joint_create();
		var trans1 = PhysicsServer2D.body_get_state(bodyRid, PhysicsServer2D.BODY_STATE_TRANSFORM);
		trans1.origin = trans1.origin - Global.instantiationManager.global_position;
		var trans2 = PhysicsServer2D.body_get_state(col.bodyRid, PhysicsServer2D.BODY_STATE_TRANSFORM);
		trans2.origin = trans2.origin - Global.instantiationManager.global_position;
		PhysicsServer2D.joint_make_damped_spring(joint, trans1.origin, trans2.origin, bodyRid, col.bodyRid);
		pinRids[col.bodyRid] = joint;
		collidedLiquids[col.liquidType][col.bodyRid] = col;
	else:
		var trans1 = PhysicsServer2D.body_get_state(bodyRid, PhysicsServer2D.BODY_STATE_TRANSFORM);
		trans1.origin = trans1.origin - Global.instantiationManager.global_position;
		var trans2 = PhysicsServer2D.body_get_state(col.bodyRid, PhysicsServer2D.BODY_STATE_TRANSFORM);
		trans2.origin = trans2.origin - Global.instantiationManager.global_position;
		print("distance: ", trans1.origin.distance_to(trans2.origin))
		if trans1.origin.distance_to(trans2.origin) >= 15:
			# PhysicsServer2D.joint_clear(pinRids[col.bodyRid]);
			PhysicsServer2D.free_rid(pinRids[col.bodyRid]);
			pinRids.erase(col.bodyRid);
			collidedLiquids[col.liquidType].erase(col.bodyRid);
