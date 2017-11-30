extends StaticBody2D

# class member variables go here, for example:
# var b = "textvar"
var die_time = 0;
var isDead = false;
var isDoublePoints = false;
var isflyingleft = 1;

func _process(delta):
	var node = get_node("/root/mainscene");
	if(isDead):
		set_pos(get_pos() + Vector2(0,delta*100))
		die_time += delta
		get_node("Trumpet").set_modulate(Color(1,1,1,.7-die_time))
		get_node("Tuba").set_modulate(Color(1,1,1,.7-die_time))
		if(die_time > .5):
			queue_free()
		return;
	
	if(isDoublePoints):
		set_pos(get_pos() + Vector2(delta*100 * isflyingleft,delta*50))
		if (get_pos().x > 400):
			isflyingleft  = -1
		if (get_pos().x < -400):
			isflyingleft  = 1
	else:
		set_pos(get_pos() + Vector2(0,delta*50))
	
	if(node):
		if (node.max_height * -1 < get_pos().y -200 or get_pos().y > -200):
			queue_free()
	else:
		print("what")
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("score").hide()
	set_process(true)
	pass
	
func handleHit(score):
	get_node("score").show()
	if(isDoublePoints):
		get_node("score").set_text("double!")
	else:
		get_node("score").set_text(str(score))
	isDead = true;
	
