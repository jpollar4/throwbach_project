extends Node2D

# class member variables go here, for example:
# var a = 2
var bLaunched = false;
var bouncer_scene;
var last_bouncer_height = 0;
var max_height = 0;
var cur_score = 0;
var num_bouncers_hit = 1;
var cur_trumpet = 1;
var high_score = 0;
var save_path = "user://savegame.save";
var isGameOver = false;

func _input(ev):
	var bach = get_node("game_parts/Bach")
	if ev.type == InputEvent.MOUSE_BUTTON and ev.button_index == BUTTON_LEFT and ev.pressed:
		if(!Globals.get("seenSplashScreen")):
			Globals.set("seenSplashScreen", true)
			get_node("Control/SplashScreen").set_hidden(true);
			return;
		if(!Globals.get("seenHowToScreen")):
			Globals.set("seenHowToScreen", true)
			get_node("Control/HowToScreen").set_hidden(true);
			return;
		if(!bLaunched):
			#ThrowBach!
			bLaunched = true;
			bach.apply_impulse(Vector2(0,0), Vector2(0,-520));
			bach.set_max_contacts_reported(1);
			bach.set_contact_monitor(true);
		if (isGameOver):
			get_tree().reload_current_scene()

func create_save():
	var savegame = File.new() #file
	savegame.open(save_path, File.WRITE)
	var save_data = {"highscore": cur_score}
	savegame.store_var(save_data)
	savegame.close()
	
func read_savegame():
	var savegame = File.new() #file
	savegame.open(save_path, File.READ) #open the file
	var save_data = savegame.get_var() #get the value
	savegame.close() #close the file
	high_score = save_data["highscore"] #return the value

func stop_back_left_right(bach):
	bach.apply_impulse(Vector2(0,0),Vector2(-bach.get_linear_velocity().x,0))

func _process(delta):
	
	var bach = get_node("game_parts/Bach")
	var camera = get_node("game_parts/Camera2D")
	var sound = get_node("audio")
	
	if(isGameOver):
		if(!sound.is_playing()):
			get_tree().reload_current_scene()
		return;
	
	if (bach.get_pos().y * -1 > max_height):
		max_height = bach.get_pos().y * -1
	
	if (bach.get_pos().y * -1 < max_height - 500):
		if (cur_score > high_score):
			create_save()
		sound.set_stream(load("res://fail.ogg"))
		sound.play()
		isGameOver = true
		
	var diff = abs(get_global_mouse_pos().x - bach.get_pos().x)
	if(diff > 2):
		if(get_global_mouse_pos().x > bach.get_pos().x):
			if (bach.get_linear_velocity().x < 0):
				stop_back_left_right(bach)
			bach.set_applied_force(Vector2(500,0));
		else:
			if (bach.get_linear_velocity().x > 0):
				stop_back_left_right(bach)
			bach.set_applied_force(Vector2(-500,0));
	else:
		stop_back_left_right(bach)

	camera.set_pos(Vector2(0,bach.get_pos().y));

	if(!bach.get_colliding_bodies().empty()): 
		if(bach.get_colliding_bodies()[0].get_name().find("bouncer") != -1 && !bach.get_colliding_bodies()[0].isDead):
			bach.set_linear_velocity(Vector2(0,0))
			bach.apply_impulse(Vector2(0,0), Vector2(0,rand_range(-500, -600)));
			sound.set_stream(load("res://trumpet" + String(cur_trumpet) + ".ogg"))
			cur_trumpet +=1;
			if(cur_trumpet == 4):
				cur_trumpet= 1
			sound.play()
			if(bach.get_colliding_bodies()[0].isDoublePoints):
				cur_score *= 2
				bach.get_colliding_bodies()[0].handleHit(num_bouncers_hit)
			else:
				cur_score += num_bouncers_hit
				bach.get_colliding_bodies()[0].handleHit(num_bouncers_hit)
				num_bouncers_hit += 1;

	if (bach.get_pos().y < last_bouncer_height+1000):
		createMoreBouncers()
	if (bLaunched && !isGameOver && bach.get_pos().y > -5 && bach.get_linear_velocity().y >= 0):
		bLaunched=false;
		cur_score = 0
		num_bouncers_hit = 1;

func createBouncer(pos):
	var scene_instance = bouncer_scene.instance()
	scene_instance.set_pos(pos);
	var new_node = get_node("game_parts").add_child(scene_instance)
	

func createDoublePointer(pos):
	var scene_instance = bouncer_scene.instance()
	scene_instance.set_pos(pos);
	scene_instance.isDoublePoints = true
	scene_instance.get_node("Sprite").set_modulate(Color(0,1,1,1))
	var new_node = get_node("game_parts").add_child(scene_instance)

func createMoreBouncers():
	
	var temp_height = 0;
	var cur_bouncer_pos_x = rand_range(-400, 400);
	for child in get_node("game_parts").get_children():
		if(child.get_name().find("bouncer") != -1 && child.get_pos().y < temp_height):
			last_bouncer_height = child.get_pos().y;
			cur_bouncer_pos_x = child.get_pos().x;
	
	var num_bouncers = (15 - (cur_score/10));
	if (num_bouncers <= 5):
		num_bouncers = 5;
		
	print (num_bouncers)
	randomize()
	for i in range(num_bouncers):
		createBouncer(Vector2(cur_bouncer_pos_x,last_bouncer_height))
		cur_bouncer_pos_x +=  ((randi() % 20) - 10) * 25;
		if (cur_bouncer_pos_x > 400 or cur_bouncer_pos_x < -400):
			cur_bouncer_pos_x = 0
		if (rand_range(0, 100) > 70):
			createBouncer(Vector2(rand_range(-400, 400),last_bouncer_height))
		last_bouncer_height += -1200/num_bouncers

	createDoublePointer(Vector2(cur_bouncer_pos_x,last_bouncer_height))
	last_bouncer_height += -1200/num_bouncers


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	bouncer_scene = load("res://bouncer.tscn");
	read_savegame()
	createMoreBouncers()
	
	if(Globals.get("seenSplashScreen")):
		get_node("Control/SplashScreen").set_hidden(true);

	if(Globals.get("seenHowToScreen")):
		get_node("Control/HowToScreen").set_hidden(true);
	
	
	set_process_input(true)
	set_process(true)
