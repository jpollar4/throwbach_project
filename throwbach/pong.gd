
extends Node2D

# Member variables
const INITIAL_BALL_SPEED = 80
var ball_speed = INITIAL_BALL_SPEED
var screen_size = Vector2(640, 400)

# Default ball direction
var direction = Vector2(-1, 0)
var pad_size = Vector2(8, 32)
const PAD_SPEED = 150


func _process(delta):
	# Get ball position and pad rectangles
	var left_rect = Rect2(get_node("left").get_pos() - pad_size*0.5, pad_size)
	var right_rect = Rect2(get_node("right").get_pos() - pad_size*0.5, pad_size)

	# Move left pad
	var left_pos = get_node("left").get_pos()
	
	if (left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
		left_pos.y += -PAD_SPEED*delta
	if (left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
		left_pos.y += PAD_SPEED*delta
	
	get_node("left").set_pos(left_pos)
	
	# Move right pad
	var right_pos = get_node("right").get_pos()
	
	if (right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
		right_pos.y += -PAD_SPEED*delta
	if (right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
		right_pos.y += PAD_SPEED*delta
	
	get_node("right").set_pos(right_pos)


func _ready():
	screen_size = get_viewport_rect().size # Get actual size
	pad_size = get_node("left").get_texture().get_size()
	set_process(true)
