extends Node2D

var ingredients = {};
var liquidParticles = {};
var pan;
@export var liquidColors = {
	0: Color.WHITE
}
# Called when the node enters the scene tree for the first time.
func _ready():
	print("instantiation manager ready");
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for type in liquidParticles.values():
		for liquid in type.keys():
			if !liquid:
				type.erase(liquid);
				continue;
			var state = type[liquid];
			var trans = PhysicsServer2D.body_get_state(state.bodyRid,PhysicsServer2D.BODY_STATE_TRANSFORM)
			if !UpdateRender(state, trans): continue;
			CheckCollision(state, trans);
	# var trans = PhysicsServer2D.body_get_state(col[0],PhysicsServer2D.BODY_STATE_TRANSFORM)
	# U


func UpdateRender(state, trans) -> bool:
	trans.origin = trans.origin - GameManager.instantiationManager.global_position;
	RenderingServer.canvas_item_set_transform(state.renderRid,trans)
	if trans.origin.y > 1500:
		#remove RIDs
		PhysicsServer2D.free_rid(state.bodyRid)
		RenderingServer.free_rid(state.renderRid)
		#remove reference
		liquidParticles[state.liquidType].erase(state.bodyRid);
		return false;
	return true;

func CheckCollision(state, trans):
	var space_state := get_world_2d().direct_space_state;
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape_rid = state.shapeRid;
	query.transform = trans
	var results = space_state.intersect_shape(query)
	for coll in results:
		if Global.LiquidType.values().has(coll.collider_id):
			OnParticleCollision(state, coll);
		# print(PhysicsServer2D.body_get_collision_layer(coll.rid));

func OnParticleCollision(colState, colTwo):
	var collTwoState = liquidParticles[colTwo.collider_id][colTwo.rid];
	colState.MixLiquid(collTwoState);

func DeleteParticle(state : LiquidState):
	PhysicsServer2D.free_rid(state.bodyRid);
	RenderingServer.free_rid(state.renderRid);
	liquidParticles[state.liquidType].erase(state.bodyRid);
