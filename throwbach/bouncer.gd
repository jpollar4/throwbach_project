extends StaticBody2D

# class member variables go here, for example:
# var b = "textvar"

func _process(delta):
	var node = get_node("/root/mainscene");
	
	if(node):
		if (node.cur_score * -1 < get_pos().y -400):
			queue_free()
	else:
		print("what")
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	pass
