extends Draggable
@export var rotateSpeed : float = 100;


# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	super._physics_process(delta);
	if dragging:
		rotation = lerp_angle(rotation, deg_to_rad(30), rotateSpeed*delta);


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

