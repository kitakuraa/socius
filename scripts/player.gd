extends KinematicBody2D

export (int) var speed = 85
onready var sprite = get_node("sprite")
onready var animation = get_node("animation")
onready var collision = get_node("collision")
onready var map_collision = get_node("/root/game/collision")
onready var camera = get_node("/root/game/camera")
onready var alert = get_node("alert")
onready var emoji = get_node("alert/emoji")
onready var light = get_node("light")

signal on_position
signal player_arrived

var velocity = Vector2.ZERO
var allow_move = true
export  var is_in_cutscene = false
var waited_list = []
var on_position_action_list = []
var currently_overlay = null
var current_path
var current_position = Vector2.ZERO
var direction = Vector2.ZERO
var shared_collision = false

func _ready():
	set_physics_process(false)
	set_process(true)

func _process(delta):
	var input_vector = Vector2.ZERO
	if (allow_move and not is_in_cutscene):
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
	
	if input_vector == Vector2.ZERO:
		animation.get("parameters/playback").travel("idle")
	else :
		animation.get("parameters/playback").travel("walk")
		animation.set("parameters/idle/blend_position", input_vector)
		animation.set("parameters/walk/blend_position", input_vector)

		move_and_slide(input_vector * speed)
		
		if (waited_list.size() != 0):
			var index = 0
			for waited_at in waited_list:
				if (map_collision.map_to_world(waited_at).distance_to(global_position) <= 96):
					emit_signal("on_position", on_position_action_list[index])
					waited_list.remove(index)
					on_position_action_list.remove(index)
					
				index += 1
		
func _physics_process(delta):
	if (current_path.size() > 0):
		if (current_position == Vector2.ZERO):
			current_position = map_collision.map_to_world(current_path[0]) + Vector2(8, 8)
			current_path.remove(0)
			direction = global_position.direction_to(current_position)

			animation.get("parameters/playback").travel("walk")
			animation.set("parameters/walk/blend_position", direction)
	else :
		if (velocity == Vector2.ZERO):
			animation.get("parameters/playback").travel("idle")
			set_physics_process(false)
			set_process(true)
			emit_signal("player_arrived")
			collision.disabled = false

	if (current_position != Vector2.ZERO):
		if (global_position.distance_to(current_position) > 2):
			velocity = move_and_slide(direction * speed)
		else :
			velocity = Vector2.ZERO
			current_position = Vector2.ZERO

func wait_player_at(pos, action):
	waited_list.append(pos)
	on_position_action_list.append(action)

func align(dir):
	animation.set("parameters/idle/blend_position", dir)
	
func display_emoji(name):
	alert.show()
	emoji.emoji_name = name
	
func hide_emoji():
	alert.hide()

func move(pos):
	global_position = pos
	camera.global_position = pos

func move_along_path(path):
	current_path = path
	set_physics_process(true)
	set_process(false)
	collision.disabled = true
