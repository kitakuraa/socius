extends Node2D

onready var mission = get_node("/root/game/ui")
onready var dialog = get_node("/root/game/cutscenes")
onready var story = get_node("/root/game/story")

var collected = 0

func _ready():
	pass
	
func taken(x, name):
	collected += 1
	get_node(name).queue_free()
	mission.update_mission("find_bombs", "Cari bom (" + str(collected) + "/15)")

	if (collected == 1):
		dialog.display("Althea", "Bom pertama sudah ketemu, tinggal 14 lagi.", "althea_bomb/1")
		yield (dialog, "dialog_ended")
		
	if (collected == 5):
		dialog.display("Althea", "5 bom sudah ketemu. Orang bertopeng bodoh itu meletakkan bom di tempat-tempat yang mudah.", "althea_bomb/2")
		yield (dialog, "dialog_ended")

	if (collected == 10):
		dialog.display("Althea", "5 bom lagi, dan kota ini akan aman.", "althea_bomb/3")
		yield (dialog, "dialog_ended")

	if (collected == 14):
		dialog.display("Althea", "Baiklah, satu bom tersisa.", "althea_bomb/4")
		yield (dialog, "dialog_ended")

	if (collected == 15):
		dialog.display("Althea", "Sepertinya sudah semua. Yah, ini sangat mudah bagiku.", "althea_bomb/5")
		yield (dialog, "dialog_ended")
		
		story.action("bombs_finded")
	
func activate():
	for bomb in get_children():
		bomb.disable_sort = true
		bomb.enable()
		bomb.connect("talked_to_npc", self, "taken", [bomb.get_name()])
