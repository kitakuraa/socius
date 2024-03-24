extends KinematicBody2D

var player = null
var cleared = false

onready var label = get_node("label")
onready var decoration = get_node("/root/game/decorations/")
onready var tileset = decoration.tile_set
onready var ui = get_node("/root/game/ui")

func ready():
	if (cleared):
		decoration.set_cell(5, 0, 59)

func _input(event):
	if (Input.is_action_just_pressed("interact") and player and not cleared):
		decoration.set_cell(5, 0, 59)
		cleared = true
		ui.mark_mission_as_done("clean_board")
		label.hide()

func _on_area_body_entered(body):
	if (body is KinematicBody2D and body.name == "player" and ui.missions.has("clean_board") and not cleared):
		label.show()
		player = body

func _on_area_body_exited(body):
	if (body is KinematicBody2D and body.name == "player"):
		label.hide()
		player = null
