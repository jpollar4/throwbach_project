extends Node2D

# class member variables go here, for example:
# var a = 2
var bLaunched = false;
var bouncer_scene;
var cur_level = 0;
var cur_score = 0;
var cur_trumpet = 1;
var high_score = 0;
var save_path = "user://savegame.save";
var isGameOver = false;

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

func _process(delta):
	
	var bach = get_node("game_parts/Bach")
	var camera = get_node("game_parts/Camera2D")
	var sound = get_node("audio")
	
	if(isGameOver):
		if(!sound.is_playing()):
			get_tree().reload_current_scene()
		return;
	
	if (bach.get_pos().y * -1 > cur_score):
		cur_score = bach.get_pos().y * -1
	
	if (bach.get_pos().y * -1 < cur_score - 500):
		if (cur_score > high_score):
			create_save()
		sound.set_stream(load("res://fail.ogg"))
		sound.play()
		isGameOver = true
		
	
	if(Input.is_key_pressed(KEY_SPACE) && !bLaunched):
		bLaunched = true;
		bach.apply_impulse(Vector2(0,0), Vector2(0,-520));
		bach.set_max_contacts_reported(1);
		bach.set_contact_monitor(true);

	camera.set_pos(bach.get_pos());

	if(Input.is_key_pressed(KEY_LEFT) && bLaunched):
		bach.apply_impulse(Vector2(0,0), Vector2(-5,0));
	if(Input.is_key_pressed(KEY_RIGHT) && bLaunched):
		bach.apply_impulse(Vector2(0,0), Vector2(5,0));
	
	if(!bach.get_colliding_bodies().empty() && bach.get_linear_velocity().y > 0): 
		bach.set_linear_velocity(Vector2(0,0))
		bach.apply_impulse(Vector2(0,0), Vector2(0,rand_range(-300, -500)));
		sound.set_stream(load("res://trumpet" + String(cur_trumpet) + ".ogg"))
		cur_trumpet +=1;
		if(cur_trumpet == 4):
			cur_trumpet= 1
		sound.play()
		
		
		bach.get_colliding_bodies()[0].queue_free()

	if (bach.get_pos().y < cur_level*-1000):
		cur_level += 1
		createAllBouncersForLevel(cur_level+1)
		print(String(cur_level));

func createBouncer(old_pos):
	var scene_instance = bouncer_scene.instance()
	scene_instance.set_pos(old_pos + Vector2(rand_range(-1000, 1000),rand_range(-1, -1000)));	
	var new_node = get_node("game_parts").add_child(scene_instance)

func createAllBouncersForLevel(level):
	
	var num_bouncers = (25 - level);
	if (num_bouncers <= 2):
		num_bouncers = 3;
	for i in range(num_bouncers):
		createBouncer(Vector2(0,level * -1000))


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	bouncer_scene = load("res://bouncer.tscn");
	read_savegame()
	createAllBouncersForLevel(0)
	createAllBouncersForLevel(1)
	
	set_process(true)
