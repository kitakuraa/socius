extends Camera2D

onready var player = get_node("/root/game/sort/player")
onready var tween = get_node("tween")

var lerp_speed = 0.1
var pos_x
var pos_y
var shaking = false
var shake_amount = 5

func _ready():
	global_position = player.global_position
	set_process(false)
	
func _physics_process(delta):










	var smooth_stabilizer = 1 - pow(lerp_speed, delta)
	pos_x = round(int(lerp(global_position.x, player.global_position.x, smooth_stabilizer)))
	pos_y = round(int(lerp(global_position.y, player.global_position.y, smooth_stabilizer)))
	global_position = Vector2(pos_x, pos_y)

func _process(delta):
	set_offset(Vector2(rand_range( - 1.0, 1.0) * shake_amount, rand_range( - 1.0, 1.0) * shake_amount))

func set_camera_follow(follow):
	if (follow):
		global_position = player.global_position
		set_physics_process(true)
	else :
		set_physics_process(false)
