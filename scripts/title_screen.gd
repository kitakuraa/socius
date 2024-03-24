extends Node2D

onready var player = get_node("player")
onready var loading = get_node("loading")
onready var tween = get_node("loading/container/tween")

var game = load("res://game.tscn")

func _on_start_pressed():
	loading.show()
	
	tween.interpolate_property(loading.get_node("container"), "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield (tween, "tween_all_completed")

	var game_instance = game.instance()
	get_tree().root.add_child(game_instance)
	
	yield (get_tree(), "idle_frame")
	
	get_tree().root.get_node("title").queue_free()
