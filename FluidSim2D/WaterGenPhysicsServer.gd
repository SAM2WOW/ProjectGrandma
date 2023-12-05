extends Node2D

class_name LiquidGenerator
#Water Gen with Physics2DServer
@export var particle_texture:Texture;
@export var max_water_particles = 1000
@export var size_variance : float = 0.2;
@export var numParticlesPerSpawn : int = 3;
var current_particle_count = 0
var spawn_timer = 0
var liquid_type : Global.LiquidType;
@export var spawn_time = 0.05
@export var base_particle_size = 4.5;
var water_particles = []
@export var generate = false;

func create_particle():
	var ps = PhysicsServer2D
	var vs = RenderingServer
	# set position
	var trans = global_transform 
	trans.origin += Vector2(randf_range(-10,10),randf_range(-10,10))
	#physics body
	var water_col = ps.body_create()
	ps.body_set_mode(water_col,PhysicsServer2D.BODY_MODE_RIGID)
	ps.body_set_space(water_col,get_world_2d().space)
	#create circle shape for collision
	var shape = ps.circle_shape_create()
	var randVariance = 1+randf_range(-size_variance, size_variance);
	randVariance = 1;
	ps.shape_set_data(shape,base_particle_size*randVariance)
	#add shape to rigid body
	ps.body_add_shape(water_col,shape,Transform2D.IDENTITY)
	#set collision layer and mask
	ps.body_set_collision_layer(water_col,2)
	ps.body_set_collision_mask(water_col,2)
	ps.body_attach_object_instance_id(water_col,liquid_type);
	#set physics parameters
	ps.body_set_param(water_col,PhysicsServer2D.BODY_PARAM_FRICTION,0.0)
	# ps.body_set_param(water_col,PhysicsServer2D.BODY_PARAM_MASS,0.05)
	ps.body_set_param(water_col,PhysicsServer2D.BODY_PARAM_MASS,0.05)
	ps.body_set_param(water_col,PhysicsServer2D.BODY_PARAM_GRAVITY_SCALE,2.0)
	ps.body_set_state(water_col,PhysicsServer2D.BODY_STATE_TRANSFORM,trans)
	#Visual
	#create canvas item(all 2D objects are canvas items)
	var water_particle = vs.canvas_item_create()
	#set the parent to this object
	vs.canvas_item_set_parent(water_particle, Global.instantiationManager.get_canvas_item())
	#set its transform
	vs.canvas_item_set_transform(water_particle, Global.instantiationManager.global_transform)
	#create a rectangle that will contain the texture
	var rect = Rect2()
	rect.position = Vector2(-8,-8)
	rect.size = particle_texture.get_size()*randVariance/2
	#add the texture to the canvas item
	vs.canvas_item_add_texture_rect(water_particle,rect,particle_texture)
	#set the texture color to pink
	# vs.canvas_item_set_self_modulate(water_particle,Color("ff00ff"))
	vs.canvas_item_set_self_modulate(water_particle,Global.instantiationManager.liquidColors[liquid_type]);
	# vs.canvas_item_set_z_index(water_particle,2);
	#add RID pair to array
	water_particles.append([water_col,water_particle])
	if (!Global.instantiationManager.liquidParticles.keys().has(liquid_type)):
		Global.instantiationManager.liquidParticles[liquid_type] = {};
	Global.instantiationManager.liquidParticles[liquid_type][water_col] = LiquidState.new(
		liquid_type, water_col, water_particle, Global.instantiationManager.liquidColors[liquid_type]
	);

func _physics_process(delta):
	spawn_timer -= delta;
	#add particles while less than max amount set and timer < 0
	if spawn_timer < 0 and current_particle_count < max_water_particles and generate:
		for i in range(numParticlesPerSpawn):
			create_particle()
			current_particle_count += 1
		spawn_timer = spawn_time
