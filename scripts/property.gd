extends StaticBody2D

onready var tilemap = get_node("tilemap")

var player
var size = 0

func _ready():
	set_process(false)
	z_index = 5

func _process(delta):
	if (player):
		if (player.global_position.y >= global_position.y + (size / 2)):
			z_index = 1
		else :
			if (player.currently_overlay == self):
				z_index = 10
			else :
				z_index = 9
			
func _on_area_area_entered(area):
	var body = area.get_parent()
	if (body is KinematicBody2D and body.name == "player"):
		set_process(true)
		player = body
		if (player.currently_overlay == null):
			player.currently_overlay = self

func _on_area_area_exited(area):
	var body = area.get_parent()
	if (body == player):
		z_index = 5
		if (player.currently_overlay == self):
			player.currently_overlay = null
		set_process(false)
		player = null
