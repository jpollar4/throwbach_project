extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var set_fuse=false;
var fired=false;
var fuse_timer = .5;

func _process(delta):
	if(!set_fuse):
		get_node("cannon").set_rot(1.3  + get_node("cannon").get_pos().angle_to_point(get_global_mouse_pos()))
	else:
		fuse_timer -= delta;
	
	if(fuse_timer < 0 && !fired):
		fuse_timer = .2
		var sound = get_node("/root/mainscene/audio");
		sound.set_stream(load("res://cannon.ogg"))
		sound.play()
		get_node("cannon/explode").show()
		get_node("cannon/fuse").hide()
		fired = true;
		get_node("/root/mainscene").launch_bach();
		
	if(fuse_timer < 0 && fired):
		get_node("cannon/explode").hide()
	
	return;
	
func handle_click():
	if(!set_fuse):
		set_fuse = true;
		var sound = get_node("/root/mainscene/audio");
		sound.set_stream(load("res://fuse.ogg"))
		sound.play()
		get_node("cannon/fuse").show()
	
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true);
	get_node("cannon/explode").hide()
	get_node("cannon/fuse").hide()
	pass