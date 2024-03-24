extends CanvasLayer

onready var name_container = get_node("name_container")
onready var name_label = get_node("name_container/name_label")
onready var text_container = get_node("text_container")
onready var cutscenes_bar = get_node("cutscene_bar")
onready var text_label = get_node("text_container/text_label")
onready var character = get_node("character")
onready var typing = get_node("typing")
onready var ui = get_node("/root/game/ui")
onready var cooldown = get_node("cooldown")
onready var player = get_node("/root/game/sort/player")
onready var buttons = get_node("buttons")
onready var button_vbox = get_node("buttons/vbox")
onready var dub = get_node("/root/game/dub")
onready var bgm = get_node("/root/game/bgm")

signal dialog_ready
signal dialog_ended

var story
var index = 0
var is_typing = false
var allow_typing = true
var is_in_dialog = false
var is_choice = false
var showing_cutscenes_bar = false
var rendered_resource = {}
var characters = ["Yudha", "Rista"]

func _ready():
	var f = File.new()
	f.open("res://data/story.json", f.READ)
	var text = f.get_as_text()
	story = parse_json(text)
	f.close()
	emit_signal("dialog_ready")
	
func _input(event):
	if (event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and is_in_dialog and not is_choice):
		if ( not is_typing):
			emit_signal("dialog_ended")
			is_in_dialog = false
			cooldown.start()
			yield (cooldown, "timeout")
			if ( not showing_cutscenes_bar):
				hide()
			player.allow_move = true
		else :
			allow_typing = false

func display(sender, message, audio = null, potrait = null):
	yield (get_tree().create_timer(0.1), "timeout")
	if (audio != null):
		dub.playing = false
		dub.stream = load("res://dub/" + audio + ".mp3")
		dub.playing = true
		
		bgm.volume_db = - 25
	
	show()
	cooldown.stop()
	is_in_dialog = true
	
	player.allow_move = false
	
	if (sender != null):
		if (potrait != null):
			character.texture = load("res://characters_vn/" + potrait + ".png")
			character.show()
		name_container.show()
		name_label.text = sender
	else :
		name_container.hide()
		character.hide()

	is_typing = true
	text_label.text = ""
	for letter in message.length():
		if (allow_typing):
			text_label.text = text_label.text + message[letter]
			typing.start()
			yield (typing, "timeout")
		else :
			break
	
	text_label.text = message
	allow_typing = true
	is_typing = false

func display_choices(choices):
	yield (get_tree().create_timer(0.1), "timeout")
	name_container.hide()
	show()
	ui.hide()
	cooldown.stop()
	is_in_dialog = true
	
	text_label.text = ""
	
	player.allow_move = false
	
	is_choice = true
	
	buttons.show()
	text_label.hide()

	var index = 0
	
	for choice in choices:
		var button = button_vbox.get_children()[index]
		button.show()
		button.text = choice
		index += 1

func accept_choice(result):
	buttons.hide()
	text_label.show()
	for child in button_vbox.get_children():
		child.hide()
	emit_signal("dialog_ended", result)
	is_in_dialog = false
	is_choice = false
	cooldown.start()
	yield (cooldown, "timeout")
	if ( not showing_cutscenes_bar):
		hide()
	player.allow_move = true

func toggle_cutscenes_bar(shown):
	showing_cutscenes_bar = shown
	if (shown):
		show()
		name_container.hide()
		text_container.hide()
	else :
		hide()
		name_container.show()
		text_container.show()

func _on_button_pressed():
	accept_choice(0)
	
func _on_button2_pressed():
	accept_choice(1)
	
func _on_button3_pressed():
	accept_choice(2)

func _on_dub_finished():
	bgm.volume_db = - 10
