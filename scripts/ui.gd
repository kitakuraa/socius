extends CanvasLayer

signal mission_finished(name)
signal all_missions_finished

onready var mission_container = get_node("mission")
onready var mission_vbox = get_node("mission/vbox")

var font = load("res://fonts/font.tres")

var missions = {}

func _ready():
	pass

func add_mission(name, text):
	var label = Label.new()
	label.name = name
	label.text = text
	label.autowrap = true
	label.set("custom_fonts/font", font)
	label.set("custom_colors/font_color", Color(0, 0, 0))
	
	mission_vbox.add_child(label)
	
func remove_mission(name):
	if (is_instance_valid(mission_vbox.get_node(name))):
		mission_vbox.get_node(name).queue_free()
	
func update_mission(name, text):
	if (is_instance_valid(mission_vbox.get_node(name))):
		mission_vbox.get_node(name).text = text
	
func mark_mission_as_done(name):
	if (missions.has(name)):
		missions[name].finished = true

func clear_missions():
	missions = {}

