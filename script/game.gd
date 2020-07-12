extends Spatial

export(NodePath) var camera_root;
export(NodePath) var timer;

var humans = [];
var won = false;
var lost = false;
var time = 0;

func add_human(human):
	humans.append(human);

func _process(delta):
	if (Input.is_action_just_pressed("r")):
		won = false;
		lost = false;
		time = 0;
		for human in humans:
			human.reset();
		return;
	
	if won:
		return;
	
	if lost:
		return;
	
	var camera = get_node(camera_root);
	if camera.get_node(camera.snowball).global_transform.origin.y < 0:
		lost = true;
		stop_camera();
		get_node(timer).text = " You lost. Press <r> to restart.";
		return;
	
	get_node(timer).text = " Time: %.2f" % time;
	if camera.get_node(camera.snowball).moved:
		time += delta;
	
	for human in humans:
		if !human.is_dead():
			return;
	
	# We won!
	stop_camera();
	won = true;
	get_node(timer).text = " You won with a time of %.2f seconds!" % time;

func stop_camera():
	# Stop camera
	var camera = get_node(camera_root);
	var spatial = Spatial.new();
	spatial.global_transform = camera.get_node(camera.snowball).global_transform;
	add_child(spatial);
	camera.snowball = spatial.get_path();
