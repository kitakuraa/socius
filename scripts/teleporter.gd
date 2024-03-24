extends Area2D

export  var location = Vector2()
export  var disabled = false
export  var go_outside = false

onready var game = get_node("/root/game")
onready var player = get_node("/root/game/sort/player")
onready var tile = get_node("/root/game/floor")
onready var transition = get_node("/root/game/transition/animation")
onready var camera = get_node("/root/game/camera")
onready var night = get_node("/root/game/night")
onready var enter_help = get_node("/root/game/help/container/exit")
onready var exit_help = get_node("/root/game/help/container/enter")

var is_in_area = false

func _ready():
	pass
	
func _on_class_body_entered(body):
	if (body == player):
		is_in_area = true
		
		if (go_outside):
			enter_help.show()
		else :
			exit_help.show()

func _on_class_body_exited(body):
	if (body == player):
		is_in_area = false
		
		if (go_outside):
			enter_help.hide()
		else :
			exit_help.hide()

func _input(event):
	if (Input.is_action_just_pressed("interact") and is_in_area and not disabled):
		player.allow_move = false
		
		transition.play("transition")
		yield (transition, "animation_finished")
		
		if (game.already_night):
			if (go_outside):
				night.show()
				player.light.show()
			else :
				night.hide()
				player.light.hide()
		
		player.global_position = tile.map_to_world(location) + Vector2(24, 0)
		camera.global_position = tile.map_to_world(location) + Vector2(24, 0)
		var direction = player.animation.get("parameters/idle/blend_position")
		player.align(Vector2(direction.x, direction.y * - 1))
		
		yield (get_tree().create_timer(0.5), "timeout")
		transition.play_backwards("transition")
		
		player.allow_move = true
