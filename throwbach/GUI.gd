extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _process(delta):
	set_pos(get_owner().get_node("game_parts/Camera2D").get_camera_screen_center ( ) );
	get_node("score").set_bbcode(str(get_node("/root/mainscene").cur_score));
	get_node("highscore").set_bbcode(str(get_node("/root/mainscene").high_score))
	
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	pass
