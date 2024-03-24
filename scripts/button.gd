extends StaticBody2D

onready var label = get_node("label")

var is_mouse_inside = false

func _ready():
	pass

func _on_button_mouse_entered():
	is_mouse_inside = true
	label.custom_fonts.font.outline_size = 1
	print("masuk")

func _on_button_mouse_exited():
	is_mouse_inside = false
	label.custom_fonts.font.outline_size = 0
