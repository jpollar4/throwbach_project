extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var flytexture;
var flytexture2;
var crouchtexture;
var falltexture2;
var falltexture;
var frame=0;
var framedelay =0;


func _process(delta):
	
	framedelay +=delta;
	if(framedelay > .1):
		framedelay = 0
		frame += 1;
		if(frame==2):
			frame=0;
	
	if (get_linear_velocity().y < 0):
		if(frame==1):
			get_node("Sprite").set_texture(flytexture)
		else:
			get_node("Sprite").set_texture(flytexture2)
	else:
		if(frame==1):
			get_node("Sprite").set_texture(falltexture)
		else:
			get_node("Sprite").set_texture(falltexture2)
	
	if (get_linear_velocity().x < 0 && get_node("Sprite").get_scale().x == .1):
		get_node("Sprite").set_scale(Vector2(-.1,.1));
	if (get_linear_velocity().x >= 0  && get_node("Sprite").get_scale().x == -.1):
		get_node("Sprite").set_scale(Vector2(.1,.1));
	
	
func _ready():
	flytexture = preload("res://bach_fly1.png")
	flytexture2 = preload("res://bach_fly2.png")
	crouchtexture = preload("res://bach_crouch.png")
	falltexture = preload("res://bach_fall1.png")
	falltexture2 = preload("res://bach_fall2.png")
	# Called every time the node is added to the scene.
	# Initialization here

	set_process(true)
	pass
