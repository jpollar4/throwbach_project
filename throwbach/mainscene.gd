extends Node2D

# class member variables go here, for example:
# var a = 2
var bLaunched = false;
var bouncer_scene;

func _process(delta):
	if(Input.is_key_pressed(KEY_SPACE) && !bLaunched):
		bLaunched = true;
		get_node("Bach").apply_impulse(Vector2(0,0), Vector2(0,-220));
		get_node("Bach").set_max_contacts_reported(2);
		get_node("Bach").set_contact_monitor(true);
		print("yeah");
		
		
		
	get_node("Camera2D").set_pos(get_node("Bach").get_pos());

	if(Input.is_key_pressed(KEY_LEFT) && bLaunched):
		get_node("Bach").apply_impulse(Vector2(0,0), Vector2(-5,0));
	if(Input.is_key_pressed(KEY_RIGHT) && bLaunched):
		get_node("Bach").apply_impulse(Vector2(0,0), Vector2(5,0));
	
	if(!get_node("Bach").get_colliding_bodies().empty()): 
		get_node("Bach").apply_impulse(Vector2(0,0), Vector2(0,rand_range(-300, -500)));
		
		var scene_instance = bouncer_scene.instance()
		scene_instance.set_name("bouncer_scene")
		scene_instance.set_pos(get_node("Bach").get_colliding_bodies()[0].get_pos() + Vector2(rand_range(-100, 100),rand_range(-300, -800)));
		var new_node = add_child(scene_instance)
		
		get_node("Bach").get_colliding_bodies()[0].queue_free()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	bouncer_scene = load("res://bouncer.tscn");
	
	
	set_process(true)
