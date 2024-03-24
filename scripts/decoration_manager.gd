extends Node2D

func _ready():
	pass

func get(name):
	return get_node(name.to_lower())
