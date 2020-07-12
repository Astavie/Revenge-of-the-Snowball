extends KinematicBody

const growth_rate = .075;
const gravity = Vector3(0, -9.8, 0);
export(float) var max_size = 2.5;

var speed = Vector3();
var internal_size = 0.25;
var size = 0.25;

var original_size;
var original_transform;
var moved = false;

export(NodePath) var camera;
export(float) var force = 0.8;
export(float) var max_speed = 100000;

var human_class = preload("res://script/human.gd");

func _ready():
	original_size = internal_size;
	original_transform = global_transform;
	
	size = (max_size * internal_size) / (max_size + internal_size);
	get_node("Collision").shape.radius = (0.5 * size) + 0.03;
	get_node("Mesh").scale = Vector3(size, size, size);

func reset():
	moved = false;
	speed = Vector3.ZERO;
	global_transform = original_transform;
	internal_size = original_size;
	size = (max_size * internal_size) / (max_size + internal_size);
	get_node("Collision").shape.radius = (0.5 * size) + 0.03;
	get_node("Mesh").scale = Vector3(size, size, size);
	get_node(camera).snowball = get_path();
	get_node(camera).reset();

func _process(delta):
	if (Input.is_action_just_pressed("r")):
		reset();

func _physics_process(delta):
	# Get psychic forces
	var aim = get_viewport().get_camera().global_transform.basis;
	var forward = -aim.z;
	forward.y = 0;
	forward = forward.normalized();
	var left = -aim.x;
	left.y = 0;
	left = left.normalized();
	
	var dir = Vector3.ZERO;
	
	if (Input.is_action_pressed("w")):
		dir += forward;
	if (Input.is_action_pressed("a")):
		dir += left;
	if (Input.is_action_pressed("s")):
		dir -= forward;
	if (Input.is_action_pressed("d")):
		dir -= left;
	
	dir = dir.normalized();
	if dir != Vector3.ZERO:
		moved = true;
	
	# Move
	speed += gravity * delta;
	
	var mx = max(max_speed, speed.length());
	speed += dir * (force * delta / (size * size));
	if (speed.length() > mx):
		speed = speed.normalized() * mx;
	
	var prev_speed = speed;
	speed = move_and_slide(speed, Vector3(0, 1, 0), false, 1);
	
	var pause = true;
	
	# Check if we're on the ground
	if (get_slide_count() > 0):
		var collision = get_slide_collision(get_slide_count() - 1);
		
		if collision.collider is human_class and is_large_enough():
			collision.collider.die();
			speed = prev_speed;
		else:
			if collision.collider is human_class:
				collision.collider.laugh();
			
			var rate = 1 + growth_rate * speed.length() * delta;
			
			if rate > 1:
				if rate > 1.005:
					pause = false;
				
				# Increase size
				var prev_size = size;
				internal_size *= rate;
				size = (max_size * internal_size) / (max_size + internal_size);
				var size_increase = (size - prev_size) / 2;
				
				# Translate upwards
				translate(collision.normal * size_increase);
				
				# Apply on collision and mesh
				get_node("Collision").shape.radius = (0.5 * size) + 0.03;
				get_node("Mesh").scale = Vector3(size, size, size);
	
	get_node("Snow").stream_paused = pause;
	
	# Rotate
	var d = Vector3(speed.x, 0, speed.z);
	var rot_speed = d.length();
	if rot_speed > 0:
		rotate(d.rotated(Vector3.UP, PI / 2).normalized(), (rot_speed / size) * delta);

func is_large_enough():
	return size > 1;
