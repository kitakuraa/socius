extends Node2D

export  var testmode = true
var already_night = false
var platform

onready var player = get_node("sort/player")
onready var camera = get_node("camera")
onready var npc = get_node("sort/npc_manager")
onready var decorations = get_node("sort/decorations")
onready var ui = get_node("ui")
onready var story = get_node("story")
onready var cutscenes = get_node("cutscenes")
onready var arrow1 = get_node("sort/objects/arrow1")
onready var arrow2 = get_node("sort/objects/arrow2")
onready var mobile = get_node("mobile")
onready var loading = get_node("loading")
onready var tween = get_node("loading/container/tween")

func _ready():
	loading.show()
	
	tween.interpolate_property(loading.get_node("container"), "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield (tween, "tween_all_completed")
	loading.hide()
	
	platform = OS.get_model_name()
	if (platform == "GenericDevice"):
		mobile.layer = - 10
		pass
	else :
		pass

func _input(event):
	if (Input.is_action_just_pressed("screenshot")):
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		image.save_png("screenshot.png")

func activate_joystick():
	mobile.layer = 3
	mobile.get_node("joystick").use_input_actions = true
	mobile.get_node("action_button").action = "interact"
	
func _on_archer_timer_timeout():
	arrow1.z_index = 0
	arrow2.z_index = 0
	
	decorations.get("archer1").get_node("animated").play("archer_shooting")
	yield (get_tree().create_timer(1.875), "timeout")
	decorations.get("archer1").get_node("animated").play("archer_idle")

	arrow2.get_node("tween").interpolate_property(arrow1, "global_position", Vector2( - 120, - 1392), Vector2( - 120, - 1592), 0.7, Tween.TRANS_LINEAR)
	arrow2.get_node("tween").start()
	yield (get_tree().create_timer(0.2), "timeout")
	arrow2.z_index = 100

	decorations.get("archer2").get_node("animated").play("archer_shooting")
	yield (get_tree().create_timer(1.875), "timeout")
	decorations.get("archer2").get_node("animated").play("archer_idle")
	
	arrow1.get_node("tween").interpolate_property(arrow1, "global_position", Vector2( - 23, - 1392), Vector2( - 23, - 1592), 0.7, Tween.TRANS_LINEAR)
	arrow1.get_node("tween").start()
	yield (get_tree().create_timer(0.2), "timeout")
	arrow1.z_index = 100

func _on_settings_pressed():
	activate_joystick()
