extends Resource;
class_name LiquidState;

@export var liquidType : Global.LiquidType;
@export var maxThickenTimer : float = 10;
@export var consistencyCap: float = 3;
@export var thickenHeatThreshold: float = 0.7;
@export var unthickenHeatThreshold: float = 1.4;
@export var minThickenHeatThreshold: float = 0.1;
@export var maxFriction: float = 5;
@export var maxMass: float = 0.15;

var baseFriction : float = 0;
var baseMass : float = 0;
var color : Color;
var consistency : float = 0;
var thickenTimer : float;
var bodyRid : RID;
var shapeRid : RID;
var renderRid : RID;

var liquidComposition = {};
var collidedLiquids = {};

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
	if heat <= thickenHeatThreshold && heat >= minThickenHeatThreshold:
		var thickenSpeed = Global.remap_range(heat, minThickenHeatThreshold, thickenHeatThreshold, 1, 0.2);
		thickenTimer += delta * thickenSpeed;
	elif heat >= unthickenHeatThreshold:
		thickenTimer -= delta*heat;
	thickenTimer = clamp(thickenTimer, 0, maxThickenTimer);
	var friction = baseFriction+((maxFriction-baseFriction) * ease(thickenTimer/maxThickenTimer, 4.8));
	var mass = baseMass+((maxMass-baseMass) * ease(thickenTimer/maxThickenTimer, 4.8));
	# print(friction, ", ", mass);
	PhysicsServer2D.body_set_param(bodyRid, PhysicsServer2D.BODY_PARAM_FRICTION, friction);
	PhysicsServer2D.body_set_param(bodyRid, PhysicsServer2D.BODY_PARAM_MASS, mass);

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
