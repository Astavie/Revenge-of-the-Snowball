extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if visible:
		get_parent().add_human(self);
	get_node("Animated_Human_gtk_/AnimationPlayer").play("Idle");
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func is_dead():
	return !get_node("Animated_Human_gtk_/Human Armature").visible;

func die():
	get_node("Animated_Human_gtk_/Human Armature").visible = false;
	get_node("CollisionShape").disabled = true;
	get_node("Particles").emitting = true;
	get_node("Gore").play();

func reset():
	get_node("Animated_Human_gtk_/Human Armature").visible = true;
	get_node("CollisionShape").disabled = false;

func laugh():
	get_node("Animated_Human_gtk_/AnimationPlayer").play("Human ArmatureAction");
	get_node("Animated_Human_gtk_/AnimationPlayer").advance(.5);
	get_node("Animated_Human_gtk_/AnimationPlayer").queue("Idle");
	get_node("Laugh").play();
	pass;
