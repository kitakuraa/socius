extends KinematicBody2D

export  var sprite_texture:Texture
export  var direction:Vector2
export  var patrol:PoolVector2Array
export  var speed = 120
export  var disable_sort = false
export  var default_animation:String = "idle"
export  var random_emojis:PoolStringArray
export  var dialogue:PoolStringArray
export  var npc_name:String
export  var is_talkable_npc = false
export  var show_interactable_text = false
export  var interactable_notif = "interact"

onready var dialog = get_node("/root/game/cutscenes")
onready var game = get_node("/root/game")
onready var timer = get_node("timer")
onready var sprite = get_node("sprite")
onready var animation = get_node("animation")
onready var collision = get_node("collision")
onready var tween = get_node("tween")
onready var alert = get_node("alert")
onready var emoji = get_node("alert/emoji")
onready var navigation = get_parent()
onready var player = get_node("/root/game/sort/player")
onready var map_collision = get_node("/root/game/collision")
onready var world_tile = get_node("/root/game/floor")
onready var interact_help = get_node("/root/game/help/container/interact")
onready var take_help = get_node("/root/game/help/container/take")

export  var disabled = false
var player_ = null
var _player = null
var talk_action = null
var velocity = Vector2.ZERO
var current_path = []
var current_position = Vector2.ZERO
var text_shown
var is_interacting = false

signal talked_to_npc
signal npc_arrived

func _ready():
	sprite.texture = sprite_texture
	animation.get("parameters/playback").travel(default_animation)
	animation.set("parameters/" + default_animation + "/blend_position", direction)
	
	ready()
	update_random_emojis()

	if (disabled):
		disable()
	else :
		enable()

func ready():
	set_process(false)
	if ( not patrol):
		set_physics_process(current_path.size() != 0)
	
	if (disabled):
		disable()
	else :
		enable()
	





func _process(delta):
	if (_player and not disable_sort):
		if (_player.global_position.y >= global_position.y - 24):
			z_index = 1
		else :
			if (_player.currently_overlay == null):
				z_index = 10
			else :
				z_index = 11

func _physics_process(delta):
	if (patrol and current_path.size() == 0):
		current_path = Array(patrol)
	
	if (current_path.size() > 0):
		if (current_position == Vector2.ZERO):
			current_position = map_collision.map_to_world(current_path[0]) + Vector2(8, 8)
			current_path.remove(0)
			direction = global_position.direction_to(current_position)

			animation.get("parameters/playback").travel("walk")
			animation.set("parameters/walk/blend_position", direction)
			collision.disabled = true
	else :
		if (velocity == Vector2.ZERO):
			animation.get("parameters/playback").travel("idle")
			if ( not patrol):
				set_physics_process(false)
			collision.disabled = false
			emit_signal("npc_arrived")

	if (current_position != Vector2.ZERO):
		if (global_position.distance_to(current_position) > 2):
			velocity = move_and_slide(direction * speed)
		else :
			velocity = Vector2.ZERO
			current_position = Vector2.ZERO

func _on_area_body_entered(body):
	if (body is KinematicBody2D and body != self):
		player_ = body
		
func _on_area_body_exited(body):
	if (body == player):
		player_ = null
		
func _input(event):
	if (Input.is_action_just_pressed("interact") and player_):
		if ( not is_talkable_npc):
			emit_signal("talked_to_npc", talk_action)
			alert.hide()
		else :
			if ( not is_interacting):
				is_interacting = true
				align(global_position.direction_to(player.global_position))
				player.align(player.global_position.direction_to(global_position))
				
				var lines = Array(dialogue)
				
				if (lines.size() > 0):
					for line in lines:
						if (line[0] != "&"):
							dialog.display(npc_name, line)
							yield (dialog, "dialog_ended")
						else :
							line = line.replace("&", "")
							dialog.display("Althea", line)
							yield (dialog, "dialog_ended")
							
				align(direction)
				is_interacting = false

func align(dir):
	animation.set("parameters/idle/blend_position", dir)

func display_emoji(name):
	alert.show()
	emoji.emoji_name = name
	
func hide_emoji():
	alert.hide()

func _on_sort_area_entered(area):
	var body = area.get_parent()
	if (body is KinematicBody2D and body.name == "player"):
		set_process(true)
		_player = body
		
		if (is_talkable_npc or show_interactable_text):
			if (interact_help.visible):
				player.shared_collision = true
			
			if (interactable_notif != "take"):
				interact_help.show()
			else :
				take_help.show()
				
		text_shown = interactable_notif

func _on_sort_area_exited(area):
	var body = area.get_parent()
	if (body == player):
		if ( not disable_sort):
			z_index = 1
		
		set_process(false)
		_player = null
		
		if (is_talkable_npc or show_interactable_text):
			if ( not player.shared_collision):
				get_node("/root/game/help/container/" + text_shown).hide()
				text_shown = null
			else :
				player.shared_collision = false
		
func move_along_path(path):
	current_path = path
	set_physics_process(true)
		
func move(pos):
	global_position = pos
		
func disable():
	disabled = true
	collision.disabled = true
	hide()
	
	if (is_instance_valid(get_node("audio"))):
		get_node("audio").playing = false
	
func enable():
	disabled = false
	collision.disabled = false
	show()
	
	if (is_instance_valid(get_node("audio"))):
		get_node("audio").playing = true

func update_random_emojis():
	if (random_emojis.size() != 0):
		random_emojis = Array(random_emojis)
		timer.start()
		
		randomize()
		timer.wait_time = rand_range(15, 25)

func _on_timer_timeout():
	randomize()
	display_emoji(random_emojis[randi() % random_emojis.size()])
	yield (get_tree().create_timer(2), "timeout")
	hide_emoji()
	
	randomize()
	timer.wait_time = rand_range(15, 25)
