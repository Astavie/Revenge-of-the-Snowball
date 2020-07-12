extends Spatial

var camrot_h = 0;
var camrot_v = 0;
var cam_v_min = -0;
var cam_v_max = 75;
var h_sensitivity = 0.1;
var v_sensitivity = 0.1;
var h_acceleration = 20;
var v_acceleration = 20;
var p_acceleration = 20;

export(NodePath) var snowball;

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	$h/v/Camera.add_exception(get_node(snowball));
	pass;

func _input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camrot_h -= event.relative.x * h_sensitivity;
			camrot_v += event.relative.y * v_sensitivity;

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	
	# Rotate
	camrot_v = clamp(camrot_v, cam_v_min, cam_v_max);
	
	$h.rotation_degrees.y = lerp($h.rotation_degrees.y, camrot_h, delta * h_acceleration);
	$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, camrot_v, delta * v_acceleration);
	
	# Move
	var dis = get_node(snowball).global_transform.origin - global_transform.origin;
	global_translate(lerp(Vector3.ZERO, dis, delta * p_acceleration));

func reset():
	global_transform.origin = get_node(snowball).global_transform.origin;
