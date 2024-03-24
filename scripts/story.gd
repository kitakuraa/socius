extends Node2D

signal ok_pressed

onready var game = get_node("/root/game")
onready var dialog = get_node("/root/game/cutscenes")
onready var cutscenes_bar = get_node("/root/game/cutscenes/cutscene_bar")
onready var player = get_node("/root/game/sort/player")
onready var camera = get_node("/root/game/camera")
onready var npc = get_node("/root/game/sort/npc_manager/")
onready var ui = get_node("/root/game/ui")
onready var transition = get_node("/root/game/transition/animation")
onready var properties = get_node("/root/game/properties")
onready var overlay = get_node("/root/game/overlay")
onready var decorations = get_node("/root/game/sort/decorations")
onready var food = get_node("/root/game/food")
onready var half_offset = get_node("/root/game/decorations_half_offset")
onready var title_screen = get_node("/root/game/title_screen")
onready var bgm = get_node("/root/game/bgm")
onready var tween = get_node("/root/game/tween")
onready var night = get_node("/root/game/night")
onready var enter_room = get_node("/root/game/teleporter/enter_room")
onready var wall = get_node("/root/game/wall")
onready var after_attack = get_node("/root/game/after_attack")
onready var notes = get_node("/root/game/notes")
onready var notes_name = get_node("/root/game/notes/action_name")
onready var notes_explaination = get_node("/root/game/notes/action_explaination")
onready var explosion = get_node("/root/game/explosion")
onready var afterbattle = get_node("/root/game/afterbattle")
onready var mission = get_node("/root/game/ui")
onready var bomb = get_node("/root/game/sort/bomb")
onready var crescent = get_node("/root/game/crescent_layer/crescent")
onready var particle = get_node("/root/game/crescent_layer/particle")
onready var ending = get_node("/root/game/ending")
onready var hell_sfx = get_node("/root/game/hell")
onready var mobile = get_node("/root/game/mobile")
onready var side_npc = get_node("/root/game/sort/side_npc")
onready var bomb_timer = get_node("/root/game/ui/timer")

export  var enable_day_listener = true

var current_action = "intro"
var action_finished = 0

func show_notes(name, explaination):
	notes.show()
	notes_name.text = name
	notes_explaination.text = explaination
	player.is_in_cutscene = true
	
func _on_ok_pressed():
	notes.hide()
	player.is_in_cutscene = false
	emit_signal("ok_pressed")

func _ready():
	player.connect("on_position", self, "action")

func show_decorations(decorations_to_show):
	for target in decorations_to_show:
		decorations.get(target).enable()
	
func show_npcs(npcs_to_show):
	for target in npcs_to_show:
		npc.get(target).enable()
	
func hide_decorations(decorations_to_hide):
	for target in decorations_to_hide:
		decorations.get(target).disable()
	
func hide_npcs(npcs_to_hide):
	for target in npcs_to_hide:
		npc.get(target).disable()

func play_bgm(name):
	tween.interpolate_property(bgm, "volume_db", - 50, - 10, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	if ( not game.testmode):
		bgm.playing = false
		bgm.stream = load("res://music/" + name + ".mp3")
		bgm.playing = true

func turn_off_bgm():
	tween.interpolate_property(bgm, "volume_db", - 10, - 50, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_cutscenes_dialog_ready():
	yield (get_tree().create_timer(0.1), "timeout")
	action(current_action)
	
func transition(start = true, end = true):
	if (start):
		transition.play("transition")
		yield (transition, "animation_finished")
	if (end):
		yield (get_tree().create_timer(1), "timeout")
		transition.play_backwards("transition")
		yield (transition, "animation_finished")
	
func action(action_name):
	match (action_name):
		"intro":
			ui_hide()
			play_bgm("castle_bgm")
			
			player.is_in_cutscene = true
			player.move(Vector2(2807, - 1111))
			player.hide()
			
			yield (get_tree().create_timer(1), "timeout")
			
			dialog.display("Raja", "Penasihat, tolong panggilkan anakku.", "king/1")
			yield (dialog, "dialog_ended")
				
			dialog.display("Penasihat", "Baik, yang mulia.", "advisor/1")
			yield (dialog, "dialog_ended")
			
			dialog.toggle_cutscenes_bar(true)
			
			npc.get("advisor").move_along_path([Vector2(175, - 68), Vector2(175, - 56)])
			yield (npc.get("advisor"), "npc_arrived")
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			player.move(Vector2(2807, - 577))
			npc.get("advisor").move(Vector2(2711, - 1093))
			player.align(Vector2.UP)
			player.show()
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")

			player.move_along_path([Vector2(175, - 59)])
			yield (player, "player_arrived")
			
			dialog.toggle_cutscenes_bar(false)
	
			dialog.display("Raja", "Kemarilah, nak.", "king/2")
			yield (dialog, "dialog_ended")
			
			dialog.toggle_cutscenes_bar(true)
			
			player.move_along_path([Vector2(175, - 69)])
			yield (player, "player_arrived")
			
			dialog.toggle_cutscenes_bar(false)
			
			dialog.display("Raja", "Althea, sekarang sudah genap 17 tahun usiamu. Ayah rasa ini adalah saat yang tepat untuk menguji kemampuanmu sebagai calon raja.", "king/3")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Baik Ayahanda. Ananda siap untuk memenuhi ujian tersebut.", "althea/11")
			yield (dialog, "dialog_ended")
			
			dialog.display("Raja", "Bagus ... bagus ...", "king/4")
			yield (dialog, "dialog_ended")
			
			dialog.display("Raja", "Kau tahu kan, bahwa raja yang baik harus bisa melihat dan mendengar rakyat-rakyatnya, serta memecahkan permasalahan mereka. ", "king/5")
			yield (dialog, "dialog_ended")

			dialog.display("Althea", "Iya Ayahanda. Itu merupakan kewajiban seorang raja.", "althea/12")
			yield (dialog, "dialog_ended")
			
			dialog.display("Raja", "Kalau begitu, sekarang pergilah menyamar sebagai warga biasa ke kota Arreta. Lakukanlah apa yang kiranya akan dilakukan oleh seorang raja yang baik. ", "king/7")
			yield (dialog, "dialog_ended")

			dialog.display("Althea", "Baik Ayahanda.", "althea/13")
			yield (dialog, "dialog_ended")
			
			dialog.display("Raja", "Sebelum kau pergi, ambillah buku ini. Buku ini akan memberimu petunjuk jika kau bingung apa yang harus kau lakukan.", "king/6")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Baik Ayahanda.", "althea/13")
			yield (dialog, "dialog_ended")
			
			dialog.toggle_cutscenes_bar(true)
			
			camera.set_camera_follow(false)
			player.move_along_path([Vector2(175, - 54)])
			yield (player, "player_arrived")
			
			dialog.toggle_cutscenes_bar(false)
			
			title_screen.show()
			title_screen.get_node("animation").play("animation")
			
			yield (get_tree().create_timer(1), "timeout")
			
			player.move(Vector2(143, 225))
			camera.set_camera_follow(true)
			player.sprite.texture = load("res://characters/player_as_folk.png")
			
			yield (title_screen.get_node("animation"), "animation_finished")
			
			turn_off_bgm()
			
			player.is_in_cutscene = false
			
			action("teleported")
			
		"teleported":
			ui_hide()
			play_bgm("town_bgm")
			
			npc.get("villager").display_emoji("exclamation")
			npc.get("villager").talk_action = "mission_1"
			npc.get("villager").connect("talked_to_npc", self, "action")

			if (enable_day_listener):
				player.wait_player_at(Vector2(9, - 44), "enter_city")
				
				player.wait_player_at(Vector2(59, - 82), "mission_3")
				
				player.wait_player_at(Vector2(6, - 107), "mission_4")
				
				player.wait_player_at(Vector2(83, - 79), "mission_5")
				
				player.wait_player_at(Vector2(20, - 80), "mission_6")
				
				player.wait_player_at(Vector2(22, - 124), "mission_7")
				
				player.wait_player_at(Vector2(160, - 121), "mission_8")
				
				player.wait_player_at(Vector2(58, - 165), "mission_11")
				
				player.wait_player_at(Vector2(48, - 102), "mission_12")
				
				player.wait_player_at(Vector2( - 3, - 171), "mission_14")
				
				player.wait_player_at(Vector2(64, - 132), "mission_15")
				
				player.wait_player_at(Vector2(76, - 148), "mission_16")
				




			dialog.display("Althea", "Akhirnya sampai juga.", "althea/14")
			yield (dialog, "dialog_ended")
			
			ui_show()
			mission.add_mission("enter_city", "Pergi ke kota")
		
		"enter_city":
			ui_hide()
			
			dialog.display("Althea", "(Wah, kota ini sangat besar.)", "althea/15")
			yield (dialog, "dialog_ended")
			
			mission.add_mission("explore", "Amati warga dan permasalahan-permasalahan mereka (0/16)")
			mission.remove_mission("enter_city")
			
			ui_show()
			
		"take_crystal":
			ui_hide()
			
			player.is_in_cutscene = true
			
			dialog.display("Althea", "Benda apa ini? Terlihat berkilau, aku simpan saja lah, lumayan. ", "althea/16")
			yield (dialog, "dialog_ended")
			
			player.wait_player_at(Vector2(42, - 83), "mission_2")
			
			player.is_in_cutscene = false
		
			ui_show()
		
		"mission_1":
			ui_hide()
			
			npc.get("villager").talk_action = null
			npc.get("villager").disconnect("talked_to_npc", self, "action")
			
			npc.get("villager").align(Vector2(0, 1))
			player.align(Vector2(0, - 1))
			
			dialog.display("Warga 1", "Duh, kotak ini banyak sekali. Kita tidak akan bisa membawa semua kotak ini hanya berdua.", "vill2/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 2", "Iya. Hey, kamu yang disana. Bisa bantu kami membawa kotak-kotak ini?", "vill4/1")
			yield (dialog, "dialog_ended")
			
			dialog.display_choices(["Bantu", "Tidak bantu"])
			var result = yield (dialog, "dialog_ended")
			
			player.is_in_cutscene = true
			
			if (result == 0):
				dialog.display("Althea", "Dengan senang hati!", "althea/21")
				yield (dialog, "dialog_ended")
				
				transition.play("transition")
				yield (transition, "animation_finished")
				
				properties.set_cell( - 2, - 15, - 1)
				properties.set_cell( - 1, - 15, - 1)
				properties.set_cell( - 1, - 14, - 1)
				properties.set_cell(0, - 13, - 1)
				
				yield (get_tree().create_timer(1), "timeout")
				transition.play_backwards("transition")
				yield (transition, "animation_finished")
				
				dialog.display("Warga 1", "Terima kasih banyak sudah membantu kami. ", "vill2/2")
				yield (dialog, "dialog_ended")

				dialog.display("Althea", "Tentu, sudah menjadi kewajibanku. ", "althea/22")
				yield (dialog, "dialog_ended")
				
				dialog.display("Warga 2", "Baiklah, kami pergi dulu. ")
				yield (dialog, "dialog_ended")
				
				dialog.toggle_cutscenes_bar(true)
			else :
				dialog.display("Althea", "Tidak, aku sedang sibuk.", "althea/23")
				yield (dialog, "dialog_ended")
				
				dialog.display("Warga 1", "Baiklah. Maaf menganggumu.", "vill2/3")
				yield (dialog, "dialog_ended")
				
				dialog.display("Warga 2", "Coba kau panggil Caius. Mungkin dia bisa membantu kita.", "vill4/3")
				yield (dialog, "dialog_ended")
				
				dialog.display("Warga 1", "Iya juga.")
				yield (dialog, "dialog_ended")
				
				dialog.toggle_cutscenes_bar(true)
				
				npc.get("villager").move_along_path([Vector2(4, - 56)])
				yield (npc.get("villager"), "npc_arrived")
				
				npc.get("villager3").enable()
				npc.get("villager").move_along_path([Vector2(4, - 43)])
				npc.get("villager3").move_along_path([Vector2(4, - 47)])
				yield (npc.get("villager"), "npc_arrived")
				
				npc.get("villager").align(Vector2(0, 1))
				npc.get("villager3").align(Vector2(0, 1))
				
				dialog.toggle_cutscenes_bar(false)
				
				dialog.display("Caius", "Mengapa kalian memanggilku?", "caius/1")
				yield (dialog, "dialog_ended")
				
				dialog.display("Warga 1", "Kami membutuhkan bantuanmu untuk mengangkat kotak-kotak ini.", "vill2/4")
				yield (dialog, "dialog_ended")
				
				dialog.display("Caius", "Baiklah, mari kita angkat bersama!", "caius/2")
				yield (dialog, "dialog_ended")
				
				transition.play("transition")
				yield (transition, "animation_finished")
				
				properties.set_cell( - 2, - 15, - 1)
				properties.set_cell( - 1, - 15, - 1)
				properties.set_cell( - 1, - 14, - 1)
				properties.set_cell(0, - 13, - 1)
				
				yield (get_tree().create_timer(1), "timeout")
				transition.play_backwards("transition")
				yield (transition, "animation_finished")
			
				dialog.display("Warga 2", "Selesai juga. Terima kasih sudah mau membantu kami, Caius.", "vill4/4")
				yield (dialog, "dialog_ended")
				
				dialog.display("Caius", "Bukan masalah. Aku izin pergi dulu.", "caius/3")
				yield (dialog, "dialog_ended")
				
				dialog.display("Warga 1", "Kami juga ingin pergi dulu.", "vill2/5")
				yield (dialog, "dialog_ended")
				
				dialog.toggle_cutscenes_bar(true)
				
				npc.get("villager3").move_along_path([Vector2(4, - 61)])
				yield (npc.get("villager3"), "npc_arrived")
				npc.get("villager3").disable()
			
			npc.get("villager").move_along_path([Vector2(6, - 43), Vector2(9, - 46), Vector2(25, - 46), Vector2(27, - 46)])
			
			yield (get_tree().create_timer(1), "timeout")
			
			npc.get("villager2").move_along_path([Vector2(6, - 41), Vector2(6, - 43), Vector2(9, - 46), Vector2(25, - 46), Vector2(27, - 46)])
			yield (npc.get("villager2"), "npc_arrived")
			
			npc.get("villager").disable()
			npc.get("villager2").disable()
			
			player.is_in_cutscene = false
			dialog.toggle_cutscenes_bar(false)
			
			show_notes("Gotong royong", "Kegiatan atau usaha yang dilakukan banyak orang dalam suatu pembangunan untuk mencapai tujuan bersama. ")
			yield (self, "ok_pressed")
		
			ui_show()
		
		"mission_2":
			ui_hide()
			player.align(player.global_position.direction_to(npc.get("villager4").global_position))
			
			dialog.display("Warga", "Kira-kira barang apa yang bisa ditukarkan dengan pedang itu?", "vill3/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Hoglin", "Ngrok. cukup 1 batang emas, ngrok.", "hoglin/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga", "Aku tidak punya emas sebanyak itu.", "vill3/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Hoglin", "Baiklah. aku akan menerima benda berkilau apapun yang kau punya, ngrok.", "hoglin/2")
			yield (dialog, "dialog_ended")
			
			dialog.display_choices(["Berikan benda berkilau yang kamu temukan", "Diam saja"])
			var result = yield (dialog, "dialog_ended")
			
			player.is_in_cutscene = true
			
			if (result == 0):
				player.move_along_path([Vector2(39, - 83), Vector2(37, - 84)])
				yield (player, "player_arrived")
				
				player.align(Vector2(0, - 1))

				dialog.display("Althea", "Permisi, aku punya kristal ini, mungkin bisa berguna untuk pertukaran barang kalian..", "althea/31")
				yield (dialog, "dialog_ended")
			
				dialog.display("Hoglin", "Kristal ini sangat indah, ngrok! Silahkan ambil pedangnya.", "hoglin/3")
				yield (dialog, "dialog_ended")
				
				transition.play("transition")
				yield (transition, "animation_finished")
				
				half_offset.set_cellv(Vector2(12, - 30), 563)
				
				yield (get_tree().create_timer(1), "timeout")
				transition.play_backwards("transition")
				yield (transition, "animation_finished")
				
				npc.get("villager4").align(npc.get("villager4").global_position.direction_to(player.global_position))
				player.align(player.global_position.direction_to(npc.get("villager4").global_position))
				
				dialog.display("Warga", "Terima kasih sudah membantuku!", "vill3/3")
				yield (dialog, "dialog_ended")
				
				npc.get("villager4").display_emoji("smile")
				
				dialog.display("Althea", "Dengan senang hati.", "althea/32")
				yield (dialog, "dialog_ended")
				
				dialog.display("Althea", "(Tadi juga aku menemukan kristal itu di jalan sih.)", "althea/33")
				yield (dialog, "dialog_ended")
			else :
				dialog.display("Warga", "Yah, aku tidak punya benda berkilau apapun.", "vill3/4")
				yield (dialog, "dialog_ended")
				
				dialog.display("Hoglin", "Ada uang ada barang, ngrok.", "hoglin/4")
				yield (dialog, "dialog_ended")
				
			dialog.toggle_cutscenes_bar(true)
			
			npc.get("villager4").move_along_path([Vector2(37, - 80), Vector2(10, - 80)])
			yield (npc.get("villager4"), "npc_arrived")
			npc.get("villager4").disable()
			
			dialog.toggle_cutscenes_bar(false)
			
			player.is_in_cutscene = false
			
			show_notes("Bargaining", "Kerja sama yang dilaksanakan atas dasar perjanjian mengenai pertukaran barang dan jasa antara dua organisasi atau lebih.")
			yield (self, "ok_pressed")
			
			ui_show()
				
		"mission_3":
			ui_hide()
			
			dialog.display("Althea", "(Wah, pasar ini banyak sekali pedagang Hoglin.)", "althea/41")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "(Kelihatannya pasar ini dikuasai oleh Hoglin. Dan aku belum melihat satupun ras lain yang berjualan di pasar ini.)", "althea/42")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "(Padahal, kudengar mereka baru saja bermigrasi kesini.)", "althea/43")
			yield (dialog, "dialog_ended")
			
			show_notes("Paternalisme", "Penguasaan kelompok pendatang terhadap kelompok pribumi.")
			yield (self, "ok_pressed")
			
			ui_show()
			
		"mission_4":
			ui_hide()
			
			dialog.display("Penjaga 1", "Haha, tembakanmu meleset terus!", "guard_captain/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga 2", "Diamlah. itu karena angin.", "guard/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga 1", "Kalau tembakanmu meleset terus begini, aku yang akan menjadi kepala penjaga berikutnya!", "guard_captain/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga 2", "Jangan harap!", "guard/2")
			yield (dialog, "dialog_ended")
			
			camera.set_camera_follow(true)
			
			show_notes("Persaingan", "Proses sosial ketika terdapat ke-2 pihak atau lebih saling berlomba melakukan sesuatu untuk mencapai kemenangan tertentu. Persaingn terjadi jikalau beberapa pihak menginginkan sesuatu dengan jumlah yang terbatas ataupun menjadi pusat perhatian")
			yield (self, "ok_pressed")
			
			ui_show()
			
		"mission_5":
			ui_hide()
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			camera.set_camera_follow(false)
			camera.global_position = Vector2(1282, - 1195)
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			player.align(player.global_position.direction_to(Vector2(1282, - 1192)))
			
			dialog.display("Warga", "Dasar babi-babi licik! mereka menguasai pasar kita.", "vill/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Elf", "Iya. semenjak kedatangan mereka, kita menjadi sulit berjualan.", "elf/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Ork", "Bagaimana kalau kita minta kepada walikota untuk mengusir mereka dari kota ini?", "ork/0")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga", "Aku setuju!", "vill/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Duh, sepertinya mulai terjadi perselisihan nih)", "althea/61")
			yield (dialog, "dialog_ended")
			
			camera.set_camera_follow(true)
			
			show_notes("Kontraversi", "Sikap menentang dengan tersembunyi agar tidak adanya perselisihan (konflik) terbuka. Kontravensi merupakan proses sosial dengan tanda ketidakpastian, keraguan, penolakan, dan penyangkalan dengan tidak diungkapkan secara terbuka.")
			yield (self, "ok_pressed")
			
			ui_show()
			
		"mission_6":
			ui_hide()
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			player.is_in_cutscene = true
			
			player.move(Vector2(310, - 1316))
			player.align(Vector2(1, 0))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.toggle_cutscenes_bar(true)
			
			npc.get("ork").enable()
			npc.get("ork").move_along_path([Vector2(22, - 81), Vector2(22, - 84)])
			npc.get("ork").display_emoji("anger")
			yield (npc.get("ork"), "npc_arrived")
			
			dialog.toggle_cutscenes_bar(false)
			
			dialog.display("Ork", "Hey kau, babi licik!", "ork/1")
			yield (dialog, "dialog_ended")
			
			npc.get("hoglin").display_emoji("exclamation")
				
			dialog.display("Ork", "Apel-apel yang kau jual ini sudah busuk!", "ork/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Hoglin", "Itu karena kau tidak cepat-cepat memakannya, ngrok!", "hoglin/5")
			yield (dialog, "dialog_ended")
			
			dialog.display("Ork", " Itu cuma alasanmu, dasar babi serakah!", "ork/3")
			yield (dialog, "dialog_ended")
			
			dialog.display("Ork", "Kalian ini memang dari dulu selalu saja begini!", "ork/4")
			yield (dialog, "dialog_ended")
			
			npc.get("hoglin").display_emoji("anger")
			dialog.display("Hoglin", "Kalau kau tidak suka kami, kenapa tidak belanja di tempat lain saja, ngrok!", "hoglin/6")
			yield (dialog, "dialog_ended")
			
			dialog.display("Ork", " Karena kalian mengambil alih pasar kami, babi bodoh!", "ork/5")
			yield (dialog, "dialog_ended")
			
			dialog.display("Hoglin", "Beraninya kau, ngrok!", "hoglin/7")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "(Sepertinya ini akan sulit ...)", "althea/62")
			yield (dialog, "dialog_ended")
			
			action("mission_13")
			
		"mission_7":
			ui_hide()
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			player.is_in_cutscene = true
			
			player.move(Vector2(318, - 1972))
			player.align(Vector2(1, 0))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Warga 1", "Hey, apa benar kepala penjaga kota melakukan korupsi?", "vill2/11")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 2", "Bisa jadi. Apalagi ia sering keluar kota dan kembali dengan membawa barang mewah.", "vill4/11")
			yield (dialog, "dialog_ended")
			
			dialog.toggle_cutscenes_bar(true)
			
			npc.get("captain").enable()
			npc.get("captain").move_along_path([Vector2(28, - 121)])
			
			yield (get_tree().create_timer(1), "timeout")
			npc.get("captain").align(Vector2(0, - 1))
			
			npc.get("guard").enable()
			npc.get("guard").move(Vector2(743, - 1935))
			npc.get("guard").move_along_path([Vector2(32, - 121)])
			yield (npc.get("guard"), "npc_arrived")
			npc.get("guard").align(Vector2( - 1, 0))
			
			dialog.toggle_cutscenes_bar(false)
			
			dialog.display("Kepala penjaga", "Apa kabar, warga-wargaku?", "captain/1")
			yield (dialog, "dialog_ended")
			
			npc.get("villager6").display_emoji("exclamation")
			dialog.display("Warga 3", "Ini dia kepala penjaga sialan yang mencuri uang-uang kita!", "vill5/1")
			yield (dialog, "dialog_ended")
			
			npc.get("villager7").display_emoji("anger")
			dialog.display("Warga 1", "Jangan pura-pura tidak tahu! Semua sudah terlihat dan sudah banyak bukti, walikota akan datang dan segera menangkapmu, dasar koruptor!", "vill2/12")
			yield (dialog, "dialog_ended")
			
			npc.get("captain").display_emoji("anger")
			dialog.display("Kepala penjaga", "Beraninya kalian! Penjaga, tangkap warga-warga kurang ajar ini!", "captain/2")
			yield (dialog, "dialog_ended")
			
			npc.get("guard").display_emoji("sleeping")
			dialog.display("Penjaga", "...")
			yield (dialog, "dialog_ended")
			npc.get("guard").hide_emoji()
			
			dialog.display("Kepala penjaga", "Penjaga! Kenapa kau cuma diam saja?", "captain/3")
			yield (dialog, "dialog_ended")
			
			dialog.toggle_cutscenes_bar(true)
			
			npc.get("mayor").enable()
			npc.get("mayor").move(Vector2(743, - 1935))
			npc.get("mayor").move_along_path([Vector2(46, - 119), Vector2(27, - 119)])
			
			yield (get_tree().create_timer(1), "timeout")
			
			npc.get("guard_captain").enable()
			npc.get("guard_captain").move_along_path([Vector2(46, - 119), Vector2(30, - 119)])
			
			npc.get("mayor").z_index = 10
			npc.get("guard_captain").z_index = 10
			
			yield (npc.get("guard_captain"), "npc_arrived")
			npc.get("guard_captain").align(Vector2(0, - 1))

			dialog.toggle_cutscenes_bar(false)
			
			dialog.display("Walikota", "Diam dan jangan banyak bicara, kepala penjaga. Atau harus kusebut, mantan kepala penjaga?", "mayor/1")
			yield (dialog, "dialog_ended")
			
			npc.get("villager6").hide_emoji()
			npc.get("villager7").hide_emoji()
			
			npc.get("captain").display_emoji("exclamation")
			dialog.display("Kepala penjaga", "A-apa? Pak walikota?", "captain/4")
			yield (dialog, "dialog_ended")
			
			npc.get("captain").align(Vector2(0, 1))
			npc.get("captain").hide_emoji()
			
			dialog.display("Walikota", "Aku sudah mendengar banyak laporan warga bahwa kau melakukan korupsi dan melakukan penindasan kepada warga. ", "mayor/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Kepala penjaga", "Ini semua tidak benar!", "captain/5")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Haha. Kau kira aku datang kesini tanpa bukti? Aku sudah melakukan penyelidikan. ", "mayor/3")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Kau terbukti melakukan pungutan liar kepada warga serta menggunakan uang itu untuk membeli barang mewah. ", "mayor/4")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Penjaga, jebloskan dia ke penjara! ", "mayor/5")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga", "Laksanakan. ")
			yield (dialog, "dialog_ended")
			
			transition.play("transition")
			yield (transition, "animation_finished")

			npc.get("captain").disable()
			npc.get("guard").disable()

			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Walikota", "Baiklah para warga, Sekarang koruptor itu akan saya penjarakan dahulu, lalu akan kita tentukan hukuman apa yang akan diterimanya besok. Sekarang, kapten akan menjadi kepala penjaga baru agar tidak terjadi kekacauan yang lebih lanjut.", "mayor/6")
			yield (dialog, "dialog_ended")
			
			dialog.display("Kapten", "Siap, laksanakan.", "guard3/2")
			yield (dialog, "dialog_ended")
			
			dialog.toggle_cutscenes_bar(true)
			
			npc.get("guard_captain").move_along_path([Vector2(46, - 119)])
			yield (get_tree().create_timer(1), "timeout")
			
			npc.get("mayor").move_along_path([Vector2(46, - 119)])
			yield (npc.get("mayor"), "npc_arrived")
			
			dialog.toggle_cutscenes_bar(false)
			
			npc.get("captain").disable()
			npc.get("guard_captain").disable()
			npc.get("mayor").disable()
			
			dialog.display("Warga 1", "Syukurlah walikota mendengar keluhan kita.", "vill2/13")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 2", "Iya. Semoga kepala penjaga baru kita tidak seperti yang sebelumnya.", "vill4/12")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 3", "Tenang saja. Kepala penjaga baru kita adalah orang yang jujur dan baik, kok.", "vill5/2")
			yield (dialog, "dialog_ended")
			
			player.is_in_cutscene = false
			
			show_notes("Kooptasi", "Proses terjadinya pergantian kepemimpinan di suatu lembaga agar tidak terjadinya konflik.")
			yield (self, "ok_pressed")
			action("prison")
			
		"prison":
			player.is_in_cutscene = true
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			turn_off_bgm()
		
			npc.get("captain").enable()
			npc.get("guard_captain").enable()
			npc.get("guard").enable()
			npc.get("guard").z_index = 100
			npc.get("guard_captain").z_index = 100
			
			npc.get("captain").move(Vector2(3678, - 1822))
			npc.get("captain").align(Vector2(0, 0))
			
			npc.get("guard").move(Vector2(3678, - 1750))
			npc.get("guard").align(Vector2(0, - 1))
			
			npc.get("guard_captain").move(Vector2(3718, - 1750))
			npc.get("guard_captain").align(Vector2(0, - 1))
	
			camera.set_camera_follow(false)
			camera.global_position = Vector2(3678, - 1780)
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			play_bgm("prison_bgm")
			
			dialog.display("Kapten", "Dasar kepala penjaga tak tahu malu.", "guard3/3")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga", "Iya. Kau sudah diberi kepercaan oleh walikota untuk menjadi kepala penjaga, tapi kau mengkhinati kepercayaannya.", "guard3/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Kapten", "Ayo, tinggalkan dia. Biarkan dia membusuk di penjara", "guard3/4")
			yield (dialog, "dialog_ended")
			
			npc.get("guard_captain").move_along_path([Vector2(232, - 95)])
			yield (get_tree().create_timer(1), "timeout")
			npc.get("guard").move_along_path([Vector2(229, - 95)])
			yield (npc.get("guard_captain"), "npc_arrived")
			
			dialog.display("Kepala penjaga", "Beraninya kalian menjebloskanku ke penjara. Padahal, raja sendiri yang mengangkatku menjadi kepala penjaga.", "captain/6")
			yield (dialog, "dialog_ended")
			
			yield (get_tree().create_timer(2), "timeout")
			
			npc.get("maskedman").z_index = 100
			npc.get("maskedman").enable()
			npc.get("maskedman").move_along_path([Vector2(230, - 110)])
			yield (npc.get("maskedman"), "npc_arrived")
			npc.get("maskedman").align(Vector2(0, - 1))
			
			dialog.display("Orang bertopeng", "Ahh, aku mencium aroma dendam.", "masked_man/1")
			yield (dialog, "dialog_ended")
			
			npc.get("captain").display_emoji("exclamation")
			dialog.display("Kepala penjaga", "Siapa kau? Bagaimana kau bisa masuk kesini?", "captain/11")
			yield (dialog, "dialog_ended")
			npc.get("captain").hide_emoji()
			
			dialog.display("Orang bertopeng", "Itu tidak penting. Aku mendengar kau ingin membalas mereka, kan?", "masked_man/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Kepala penjaga", "Iya. Kau bisa membantuku?", "captain/12")
			yield (dialog, "dialog_ended")
			
			dialog.display("Orang bertopeng", "Hahaha. Tentu saja. Tapi, aku tak mau membantumu tanpa imbalan.", "masked_man/3")
			yield (dialog, "dialog_ended")

			dialog.display("Kepala penjaga", "Lalu, apa yang kau mau?", "captain/13")
			yield (dialog, "dialog_ended")

			dialog.display("Orang bertopeng", "Cukup tandatangani kontrak ini dengan darahmu. Itu saja.", "masked_man/4")
			yield (dialog, "dialog_ended")
		
			dialog.display("Kepala penjaga", "(Orang ini menawarkan perjanjian dengan darah ...)", "captain/14")
			yield (dialog, "dialog_ended")
			
			dialog.display("Kepala penjaga", "(Mungkin saja dia adalah anggota sekte atau demon yang menyamar ...)")
			yield (dialog, "dialog_ended")

			dialog.display("Orang bertopeng", "Bagaimana? Apa kau menerima penawaranku ini? Aku tak punya banyak waktu.", "masked_man/5")
			yield (dialog, "dialog_ended")
			
			dialog.display("Kepala penjaga", "...")
			yield (dialog, "dialog_ended")
			
			dialog.display("Kepala penjaga", "Baiklah.", "captain/15")
			yield (dialog, "dialog_ended")
			
			dialog.display("Orang bertopeng", "Keputusan bagus. Aku jamin kau tak akan menyesali keputusan ini.", "masked_man/6")
			yield (dialog, "dialog_ended")

			dialog.display("Kepala penjaga", "(Semoga.)", "captain/16")
			yield (dialog, "dialog_ended")
			
			dialog.display("Orang bertopeng", "Baiklah. Aku akan mengeluarkanmu dari sel ini.", "masked_man/7")
			yield (dialog, "dialog_ended")

			transition.play("transition")
			yield (transition, "animation_finished")
			
			npc.get("captain").move(Vector2(3738, - 1750))
			npc.get("captain").z_index = 100
			npc.get("maskedman").align(Vector2(0, 0))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Kepala penjaga", "(Bagaimana bisa dia mengeluarkanku secepat ini ...)")
			yield (dialog, "dialog_ended")

			dialog.display("Orang bertopeng", "Nah, sekarang ikut aku. Aku punya beberapa tugas untuk kau selesaikan ...", "masked_man/8")
			yield (dialog, "dialog_ended")
			
			npc.get("maskedman").move_along_path([Vector2(230, - 95)])
			yield (get_tree().create_timer(1), "timeout")
			npc.get("captain").move_along_path([Vector2(232, - 95)])
			yield (npc.get("maskedman"), "npc_arrived")
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			turn_off_bgm()
			
			camera.set_camera_follow(true)
			npc.get("guard").z_index = 1
			npc.get("guard_captain").z_index = 1
			npc.get("captain").z_index = 1
			npc.get("maskedman").z_index = 1
			player.is_in_cutscene = false
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			play_bgm("town_bgm")
			
			ui_show()
			
		"mission_8":
			ui_hide()
			
			dialog.display("Penjaga restoran", "Selamat datang di restoran Yosuha!", "bartender/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Permisi, pesan Panas 1.", "althea/71")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga restoran", "Woy, ini bukan mekdi!", "bartender/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Lalu, menu apa saja yang ada disini?", "althea/72")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga restoran", "Kami menyediakan berbagai macam hidangan khas kota Arterra.", "bartender/3")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Apa saja hidangan khas itu?", "althea/73")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga restoran", "Cacing Merah Goreng khas kerajaan Minoan, Cicak Angkasa dari desa Elven, dan Batang Emas Coklat khas negara Hoglin.", "bartender/4")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Hmm, makanan disini sangat unik ternyata.", "althea/74")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga restoran", "Iya, karena ada berbagai ras hidup disini sejak waktu yang cukup lama, sehingga ada banyak percampuran budaya. ", "bartender/5")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga restoran", "Ngomong-ngomong, apa yang ingin kau pesan?", "bartender/6")
			yield (dialog, "dialog_ended")
			
			dialog.display_choices(["Tanya tentang makanan lain.", "Cacing Merah Goreng!", "Pesan minum saja."])
			var result = yield (dialog, "dialog_ended")
			
			if (result == 0):
				dialog.display("Althea", "Apa tidak ada makanan normal?", "althea/75")
				yield (dialog, "dialog_ended")
				
				dialog.display("Penjaga restoran", "Tentu saja ada. Kami tetap menyediakan makanan manusia. Kami menyediakan ikan bakar, roti, dan sayur-sayuran.", "bartender/7")
				yield (dialog, "dialog_ended")
				
				dialog.display("Althea", "Baiklah, aku pesan 2 roti dan 1 ikan bakar.", "althea/76")
				yield (dialog, "dialog_ended")
				
			elif (result == 1):
				dialog.display("Althea", "Aku mau pesan cacing merah goreng! Sepertinya enak ... ", "althea/76b")
				yield (dialog, "dialog_ended")
				
				dialog.display("Penjaga restoran", "Kau memiliki selera yang unik, haha. ", "bartender/8")
				yield (dialog, "dialog_ended")
				
			dialog.display("Penjaga restoran", "Baik, silahkan cari kursi dan akan saya antarkan. ", "bartender/9")
			yield (dialog, "dialog_ended")
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			player.is_in_cutscene = true
			player.z_index = 1
			player.move(Vector2(3046, - 1796))
			player.align(Vector2(0, 1))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
		
			dialog.display("Althea", "(Selagi menunggu, aku akan mengamati apa yang terjadi disini ...) ", "althea/77")
			yield (dialog, "dialog_ended")
		
			show_notes("Akulturasi", "Proses penerimaan dan pengolahan unsur-unsur kebudayaan asing menjadi bagian dari kultur suatu kelompok, tanpa menghilangkan kepribadian kebudayaan asli. Akulturasi merupakan hasil dari perpaduan kedua kebudayaan dalam waktu lama.")
			yield (self, "ok_pressed")
			
			action("mission_9")
			
		"mission_9":
			transition.play("transition")
			yield (transition, "animation_finished")
			
			camera.set_camera_follow(false)
			camera.global_position = Vector2(2640, - 1774)
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Bangsawan", "Mino, apa benar kau akan memberikanku posisi penasihat kerajaan? ")
			yield (dialog, "dialog_ended")
			
			dialog.display("Mino", "Suttt, jangan keras-keras! ", "mino/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Bangsawan", "Maaf ...")
			yield (dialog, "dialog_ended")
			
			dialog.display("Mino", "Iya, aku akan memberikanmu posisi penasihat jika aku berhasil menggulingkan raja. Tapi, kau harus membantuku dengan mengerahkan pasukan-pasukanmu untuk membantuku menggulingkan raja. ", "mino/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Bangsawan", "Maaf ...")
			yield (dialog, "dialog_ended")
			
			show_notes("Koalisi", "Kombinasi antara dua kelompok atau lebih yang mempunyai tujuan yang sama. Koalisi bersifat politis(melibatkan politik)")
			yield (self, "ok_pressed")
			
			action("mission_10")
			
		"mission_10":
			transition.play("transition")
			yield (transition, "animation_finished")
			
			camera.global_position = Vector2(2832, - 1774)
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Walikota", "Aku sangat puas dengan hasil kerja kalian kemarin!", "mayor/7")
			yield (dialog, "dialog_ended")
			
			dialog.display("Kontraktor ork", "HAHAHA. Tentu saja! Kepuasan klien adalah tujuan utama kami.", "contractor/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Aku bermaksud untuk mempekerjakan kalian lagi.", "mayor/8")
			yield (dialog, "dialog_ended")
			
			dialog.display("Kontraktor ork", "Dalam proyek apa?", "contractor/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Kau ingat tanah yang sempat longsor kemarin kan? Warga desa memintaku untuk mengubahnya menjadi sesuatu yang lebih bermanfaat, lebih tepatnya menjadi lahan pertanian.", "mayor/9")
			yield (dialog, "dialog_ended")
			
			dialog.display("Kontraktor ork", "Lalu, berapa bayarannya? ", "contractor/3")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "5 batang emas.", "mayor/10")
			yield (dialog, "dialog_ended")
			
			dialog.display("Kontraktor ork", "SEPAKAT! Penawaran kalian selalu bagus, manusia!", "contractor/4")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Hahaha.", "mayor/11")
			yield (dialog, "dialog_ended")
			
			npc.get("ork_contractor").display_emoji("exclamation")
			dialog.display("Kontraktor ork", "Hey kau!", "contractor/5")
			yield (dialog, "dialog_ended")
			
			dialog.toggle_cutscenes_bar(true)
			
			npc.get("ork_contractor").move_along_path([Vector2(184, - 111)])
			yield (npc.get("ork_contractor"), "npc_arrived")
			npc.get("ork_contractor").align(Vector2(1, 0))
			player.align(Vector2( - 1, 0))
			
			dialog.toggle_cutscenes_bar(false)
			
			dialog.display("Kontraktor ork", "APA LIAT-LIAT!? Kau menguping pembicaraan kami dari tadi!?", "contractor/6")
			yield (dialog, "dialog_ended")
			
			dialog.display_choices(["\"Iya. Kenapa memangnya?\"", "\"Tidak kok. Aku cuma memperhatikan orang yang duduk dibelakangmu.\"", "Cosplay menjadi tembok."])
			var result = yield (dialog, "dialog_ended")
			
			npc.get("ork_contractor").hide_emoji()
			
			if (result == 0):
				dialog.display("Kontraktor ork", "Kalau kau butuh pekerjaan, cukup bilang padaku HAHAHA. Kau sedikit membuatku takut, tahu.", "contractor/7")
				yield (dialog, "dialog_ended")
			
				dialog.display("Althea", "I-iya hehe. Tapi aku belum terlalu membutuhkan pekerjaan sekarang.", "althea/78")
				yield (dialog, "dialog_ended")
			
			elif (result == 1):
				dialog.display("Kontraktor ork", "Kau punya selera yang bagus ya! HAHAHA!", "contractor/8")
				yield (dialog, "dialog_ended")
			
				dialog.display("Kontraktor ork", "Ayo, dekati dia, jangan malu-malu! Kalau kau malu kau akan menjadi jones seperti walikota itu. HAHAHA!", "contractor/9")
				yield (dialog, "dialog_ended")
				
				dialog.display("Walikota", "Hey, itu rahasia.", "mayor/12")
				yield (dialog, "dialog_ended")
			
			else :
				dialog.display("Althea", "...")
				yield (dialog, "dialog_ended")
				
				dialog.display("Kontraktor ork", "JAWAB AKU!", "contractor/10")
				yield (dialog, "dialog_ended")
				
				dialog.display("Kontraktor ork", "Hey walikota, apa manusia itu rusak? Dia cuma diam saja dari tadi.", "contractor/11")
				yield (dialog, "dialog_ended")
				
				dialog.display("Walikota", "Sudahlah, tinggalkan dia. mungkin dia nolep.", "mayor/13")
				yield (dialog, "dialog_ended")

				dialog.display("Kontraktor ork", "HWUHH. Lari ada wibu!", "contractor/12")
				yield (dialog, "dialog_ended")

				dialog.display("Walikota", "Hey, jangan begitu.", "mayor/14")
				yield (dialog, "dialog_ended")
				
			npc.get("ork_contractor").move_along_path([Vector2(178, - 111)])
			yield (npc.get("ork_contractor"), "npc_arrived")
			npc.get("ork_contractor").align(Vector2(0, 0))
			player.align(Vector2(0, 0))
			
			show_notes("Joint-venture", "Bentuk kerja sama dalam perusahaan proyek khusus, seperti pembangunan, penebangan hutan dan perhotelan")
			yield (self, "ok_pressed")
			
			dialog.display("Althea", "(Huh, bikin kaget saja.)", "althea/79")
			yield (dialog, "dialog_ended")
				
			npc.get("bartender").move_along_path([Vector2(163, - 120), Vector2(163, - 114), Vector2(187, - 114), Vector2(187, - 112)])
			yield (npc.get("bartender"), "npc_arrived")
				
			dialog.display("Penjaga restoran", "Permisi, pesananmu sudah sampai.", "bartender/11")
			yield (dialog, "dialog_ended")
			
			food.set_cell(62, - 38, 368)
			
			dialog.display("Althea", "Baiklah, sebaiknya aku menghabiskan ini dulu.", "althea/79b")
			yield (dialog, "dialog_ended")
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			player.is_in_cutscene = false
			player.z_index = 2
			player.move(Vector2(3046, - 1836))
			camera.set_camera_follow(true)
			
			npc.get("bartender").move(Vector2(2565, - 1914))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Althea", "(Enak juga makanan disini ternyata ...)", "althea/80")
			yield (dialog, "dialog_ended")
			
			ui_show()
				
		"mission_11":
			ui_hide()
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			player.is_in_cutscene = true
			player.move(Vector2(871, - 2588))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			npc.get("reo").align(npc.get("reo").global_position.direction_to(player.global_position))
			player.align(player.global_position.direction_to(npc.get("reo").global_position))
			
			dialog.display("Reo", "Akulah Reo, pahlawan pemberantas demon!", "reo/1")
			yield (dialog, "dialog_ended")
			
			npc.get("reo").display_emoji("exclamation")
			
			dialog.display("Reo", "Hey, apa kau demon?", "reo/2")
			yield (dialog, "dialog_ended")
			
			npc.get("reo").hide_emoji()
			
			dialog.display_choices(["\"Sebegitu seramkah wajahku?\"", "\"Bukan. Aku manusia\"", "\"Iya. Aku demon dan aku akan menangkapmu, hahaha!"])
			var result = yield (dialog, "dialog_ended")
			
			if (result == 0):
				dialog.display("Althea", "Sebegitu seramkah wajahku?", "althea/81")
				yield (dialog, "dialog_ended")
				
				dialog.display("Reo", "Ja-jangan salah paham. Wajahmu tidak seram kok. yang seram itu auramu.", "reo/3")
				yield (dialog, "dialog_ended")
				
				dialog.display("Althea", "(Jangan bilang itu aura nolepku ...)", "althea/82 dan 83")
				yield (dialog, "dialog_ended")
			
			elif (result == 1):
				dialog.display("Reo", "Oh begitu ... Tapi auramu begitu menyeramkan seperti demon!", "reo/4")
				yield (dialog, "dialog_ended")
				
				dialog.display("Althea", "(Jangan bilang itu aura nolepku ...)", "althea/82 dan 83")
				yield (dialog, "dialog_ended")
				
			else :
				dialog.display("Reo", "Su-sudah kuduga! aku bisa merasakannya dari auramu.", "reo/5")
				yield (dialog, "dialog_ended")
				
				dialog.display("Reo", "Auramu memang menyeramkan seperti demon!", "reo/6")
				yield (dialog, "dialog_ended")
				
			dialog.display("?", "Reo ... Reo ... Dimana kamu?", "arin/1")
			yield (dialog, "dialog_ended")
			
			npc.get("reo").align(Vector2( - 1, 0))
			
			npc.get("reo").display_emoji("wave")
			dialog.display("Reo", "Disini kak!", "reo/7")
			yield (dialog, "dialog_ended")
			npc.get("reo").hide_emoji()
			
			player.is_in_cutscene = true
			dialog.toggle_cutscenes_bar(true)
			
			npc.get("arin").enable()
			npc.get("arin").move_along_path([Vector2(52, - 166)])
			yield (npc.get("arin"), "npc_arrived")
			npc.get("arin").align(Vector2(1, 0))
			
			dialog.toggle_cutscenes_bar(false)
			
			npc.get("arin").display_emoji("anger")
			dialog.display("?", "Ah, dasar Reo. Aku berkeliling desa untuk mencarimu!", "arin/2")
			yield (dialog, "dialog_ended")
			npc.get("arin").hide_emoji()
			
			npc.get("arin").align(Vector2(0, 1))
			dialog.display("Arin", "Ah, halo. Aku kakak anak ini. Namaku Arin.", "arin/3")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Iya, salam kenal.", "althea/84")
			yield (dialog, "dialog_ended")
		
			dialog.display("Arin", "Maaf ya kalau adikku mengganggumu tadi. Dia memang usil.", "arin/4")
			yield (dialog, "dialog_ended")
			
			npc.get("reo").display_emoji("yum")
			dialog.display("Reo", "Hehe.", "reo/8")
			yield (dialog, "dialog_ended")
			npc.get("reo").hide_emoji()
			
			dialog.display("Althea", "Kudengar, adikmu ini sangat ingin memberantas para demon ya?", "althea/85")
			yield (dialog, "dialog_ended")
			
			npc.get("reo").align(Vector2(0, 1))
			dialog.display("Reo", "Iya! Aku akan membunuh semua demon yang ada di dunia!", "reo/9")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Memangnya kenapa kau mau memberantas semua demon?", "althea/86")
			yield (dialog, "dialog_ended")
			
			dialog.display("Reo", "Dulunya kami tinggal di kota besar sebelum tinggal disini, namun demon menghancurkan kota kami dan sekarang kami tinggal di kota ini.", "reo/10")
			yield (dialog, "dialog_ended")
			
			dialog.display("Reo", "Tapi kakak selalu saja melarangku untuk pergi berperang melawan demon!", "reo/11")
			yield (dialog, "dialog_ended")
			
			npc.get("arin").align(Vector2(1, 0))
			dialog.display("Arin", "Kau masih terlalu kecil, Reo. Kau belum boleh menjadi pemburu demon sekarang.", "arin/6")
			yield (dialog, "dialog_ended")
			
			npc.get("reo").align(Vector2( - 1, 0))
			dialog.display("Reo", "Kakak selalu bilang begitu. Padahal aku ini kuat. Aku pasti bisa membunuh semua demon!", "reo/12")
			yield (dialog, "dialog_ended")
			
			dialog.display("Arin", "Reo, mengalahkan demon itu tidak segampang yang kamu bayangkan. Kalau mengalahkan demon itu gampang, pasti kakak sudah mendaftar menjadi pemburu demon dan membunuh semua demon.", "arin/5")
			yield (dialog, "dialog_ended")
			
			dialog.display("Reo", "Iya juga sih ...", "reo/13")
			yield (dialog, "dialog_ended")
			
			dialog.display("Reo", "T-Tapi ...", "reo/14")
			yield (dialog, "dialog_ended")
			
			dialog.display("Arin", "Ini demi kebaikanmu sendiri juga, Reo.", "arin/8")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Iya Reo. Jika kau terus berlatih, aku percaya kau akan menjadi seorang pemburu demon yang hebat (kek alu)!", "althea/87")
			yield (dialog, "dialog_ended")
			
			npc.get("reo").align(Vector2(0, 1))
			dialog.display("Reo", "Itu benar!", "reo/15")
			yield (dialog, "dialog_ended")
			
			npc.get("arin").align(Vector2(0, 1))
			dialog.display("Arin", "Ngomong-ngomong, kita belum kenalan. Siapa namamu?", "arin/7")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Oh, namaku Althea.", "althea/88")
			yield (dialog, "dialog_ended")
			
			dialog.display("Arin", "Baiklah, kami pamit pulang dulu. dah!", "arin/9")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Dadah.", "althea/89")
			yield (dialog, "dialog_ended")
			
			dialog.toggle_cutscenes_bar(true)
			
			npc.get("arin").move_along_path([Vector2(25, - 165)])
			yield (get_tree().create_timer(1), "timeout")
			
			npc.get("reo").move_along_path([Vector2(25, - 165)])
			yield (npc.get("reo"), "npc_arrived")
			
			dialog.toggle_cutscenes_bar(false)
			player.is_in_cutscene = false
			
			npc.get("arin").disable()
			npc.get("reo").disable()
			
			show_notes("Koersi", "Bentuk dari akomodasi yang berlangsung karena dengan didominasi suatu pihak/kelompok.")
			yield (self, "ok_pressed")

			ui_show()

		"mission_12":
			ui_hide()
			
			transition.play("transition")
			yield (transition, "animation_finished")
		
			player.is_in_cutscene = true
			dialog.toggle_cutscenes_bar(true)
			
			player.move(Vector2(774, - 1691))
			player.align(Vector2(0, 0))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			npc.get("thief").enable()
			npc.get("thief").move_along_path([Vector2(70, - 102)])
			yield (get_tree().create_timer(1), "timeout")
			
			dialog.toggle_cutscenes_bar(false)
			
			player.display_emoji("exclamation")
			dialog.display("Althea", "(Arghh, kenapa orang itu? Dia hampir saja menabrakku.)", "althea/91")
			yield (dialog, "dialog_ended")
			player.hide_emoji()
			
			dialog.display("Warga", "Tangkap dia!", "vill/3")
			yield (dialog, "dialog_ended")
			
			npc.get("villager9").enable()
			npc.get("villager9").move_along_path([Vector2(70, - 102)])
			yield (get_tree().create_timer(0.5), "timeout")
			
			npc.get("villager10").enable()
			npc.get("villager10").move_along_path([Vector2(70, - 102)])
			yield (npc.get("villager10"), "npc_arrived")
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			npc.get("thief").move(Vector2(1389, - 1659))
			
			npc.get("villager9").move(Vector2(1347, - 1659))
			npc.get("villager9").align(Vector2(1, 0))
			
			npc.get("villager10").move(Vector2(1427, - 1659))
			npc.get("villager10").align(Vector2( - 1, 0))
			
			player.move(Vector2(1331, - 1724))
			player.align(Vector2(0, 0))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Warga 1", "Jadi ini maling yang mencuri rancangan Crescent?", "vill7/4")
			yield (dialog, "dialog_ended")
			
			dialog.display("Maling", "Bohong!", "thief/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 2", "Kalau begitu? Yang ada di tanganmu itu?", "vill6/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Maling", "Eh ... hehe.", "thief/3")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 1", "Langsung ke intinya saja. Pilih, kembalikan rancangan Crescent itu dan serahkan dirimu ke penjaga, atau kami akan berikan salam ekonomi.", "vill7/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Maling", "...")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 1", "Eh salah. Salam persahabatan maksudnya.", "vill7/2")
			yield (dialog, "dialog_ended")
		
			dialog.display("Maling", "Pilihan yang sulit ya ...", "thief/4")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 2", "Kalau kau tidak memilih dalam 10 detik, maka aku akan mengubahmu menjadi Hoglin!", "vill6/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 2", "10 ... 9 ... 8 ... 7 ... 6 ... 5 ... 4 ... 3 ... 2 ... 1 ...", "vill6/3")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 2", "Iya ... iya ... Aku menyerahkan diri.", "thief/5")
			yield (dialog, "dialog_ended")

			dialog.display("Warga 2", "Nah, daritadi dong ...", "vill6/4")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 1", "Baiklah, ayo kita tangkap dia dan bawa ke balai kota.", "vill7/3")
			yield (dialog, "dialog_ended")

			transition.play("transition")
			yield (transition, "animation_finished")
			
			npc.get("villager9").disable()
			npc.get("villager10").disable()
			npc.get("thief").disable()
			
			player.is_in_cutscene = false
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			show_notes("Arbitrase", "Arbitrase adalah bentuk akomodasi yang terjadi apabila terdapat pihak-pihak yang berselisih tidak sanggup mencapai kompromi sendiri. Maka dari itu diundanglah kelompok ketiga yang tidak berat sebelah (netral) untuk mengusahakan penyelesaian.")
			yield (self, "ok_pressed")
		
			ui_show()
		
		"mission_13":
			ui_hide()
			
			dialog.toggle_cutscenes_bar(true)
			npc.get("mayor").enable()
			npc.get("mayor").move(Vector2(839, - 1303))
			npc.get("mayor").move_along_path([Vector2(26, - 82)])
			yield (npc.get("mayor"), "npc_arrived")
			dialog.toggle_cutscenes_bar(false)
			
			dialog.display("Walikota", "Sudah-sudah, jangan bertengkar.", "mayor/21")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Kalian ini, selalu saja begini.", "mayor/22")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Hoglin, kau sebaiknya pastikan dulu bahwa barang yang kau jual benar-benar bagus. Jika ada barang yang kurang bagus, kau harus bertanggung jawab.", "mayor/23")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Kau juga ork, kau harus memeriksa barang yang kau beli.", "mayor/24")
			yield (dialog, "dialog_ended")
			
			dialog.display("Hoglin", "Baik, ngrok. Aku akan menukarnya dengan yang baru.", "hoglin/8")
			yield (dialog, "dialog_ended")
			
			dialog.display("Ork", "Nah, daritadi dong ...")
			yield (dialog, "dialog_ended")
			
			npc.get("hoglin").hide_emoji()
			npc.get("ork").hide_emoji()
			
			dialog.display("Althea", "(Untung ada walikota ...)", "althea/92")
			yield (dialog, "dialog_ended")
			
			dialog.toggle_cutscenes_bar(true)
			npc.get("ork").move_along_path([Vector2(22, - 81), Vector2(50, - 81)])
			yield (npc.get("ork"), "npc_arrived")
			npc.get("ork").disable()
			
			npc.get("mayor").move_along_path([Vector2(50, - 81)])
			yield (npc.get("mayor"), "npc_arrived")
			npc.get("mayor").disable()
			
			dialog.toggle_cutscenes_bar(false)
			
			player.is_in_cutscene = false
			
			show_notes("Mediasi", "Pihak ketiga untuk penengah atau juru damai. Keputusan berdamai tergantung pihak-pihak yang betikai")
			yield (self, "ok_pressed")
			
			ui_show()
			
		"mission_14":
			ui_hide()
			
			dialog.display("Warga 1", "Terus, Bagaimana soal harta warisan?", "legacy1/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 2", "Harga warisan 100% akan diberikan padaku.", "legacy2/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 1", "Apa, diberikan 100% katamu?", "legacy1/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 1", "Aku adalah orang yang paling dekat dengan paman dan selalu membantu pekerjaannya!", "legacy1/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 2", "Orang yang membantu paman bukan cuma kamu, aku juga sering membantu!", "legacy2/2")
			yield (dialog, "dialog_ended")
		
			dialog.display("Warga 1", "Hmm. Kita ini saudara. Tidak baik rasanya jika kita bertengkar, apalagi karena harta warisan.", "legacy1/4")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 2", "Iya juga ...", "legacy2/3")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 1", "Bagaimana kalau kita ikuti hukumnya dulu, atau bagaimana. Lebih baik dibagi rata agar adil.", "legacy1/5")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga 2", "Huh, baiklah!", "legacy2/4")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "(Perebutan harta warisan? Jika dikaitkan dengan keluargaku, aku adalah anak tunggal jadi seharusnya seluruh harta warisan Ayah akan diberikan kepadaku.)", "althea/93")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", " (Yah ... semoga begitu)", "althea/94")
			yield (dialog, "dialog_ended")
			
			show_notes("Konsiliasi", "Upaya mempertemukan keinginan pihak-pihak yang berselisih untuk tercapainya suat persetujuan bersama")
			yield (self, "ok_pressed")
			
			ui_show()

		"mission_15":
			ui_hide()
			
			dialog.display("Althea", "(Wah, ternyata tempat ini banyak ras lain yang berkumpul ...)", "althea/95")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "(Tidak heran sih, kota Arterra ini padat sekali penduduknya.)", "althea/96")
			yield (dialog, "dialog_ended")
			
			show_notes("Toleransi", "Bentuk akomodasi tanpa adanya persetujuan resmi karena tanpa disadari dan direncanakan, adanya keinginan untuk menghindarkan diri dari perselisihan yang saling merugikan.")
			yield (self, "ok_pressed")
			
			ui_show()
			
		"mission_16":
			ui_hide()
			transition.play("transition")
			yield (transition, "animation_finished")
		
			player.is_in_cutscene = true
			player.move(Vector2(1270, - 2316))
			player.align(Vector2(0, - 1))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			npc.get("villager5").display_emoji("anger")
			dialog.display("Warga", "Hey banteng bodoh, ramuanku tumpah semua karena tertabrakmu!", "vill/4")
			yield (dialog, "dialog_ended")
			
			npc.get("minotaur").display_emoji("anger")
			dialog.display("Minotaur", "Manusia bodoh, kau yang jalan tidak pake mata!", "mino/21")
			yield (dialog, "dialog_ended")
			
			dialog.display("Minotaur", "Lagipula, hanya ramuan murah yang tumpah.", "mino/22")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga", "Kau tidak tahu berapa harga ramuan ini!", "vill/5")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga", "Dasar banteng pengikut Mega-...", "vill/6")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga", "Megatron!", "vill/7")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga", "Ramuan ini kubeli dari kota Elf.", "vill/7b")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga", "Ramuan ini harganya sangat mahal! Aku harus begadang live mandi lumpur selama sebulan untuk membeli ramuan ini.", "vill/8")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga", "Yang jelas kau harus ganti rugi semua!", "vill/9")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga", "Kalau tidak akan kubawa kau ke penjara!", "vill/10")
			yield (dialog, "dialog_ended")
			
			dialog.display("Minotaur", "Hanya dengan menumpahkan ramuan saja aku bisa dipenjara? kau bercanda?", "mino/23")
			yield (dialog, "dialog_ended")
			
			dialog.toggle_cutscenes_bar(true)
			
			npc.get("mayor").enable()
			npc.get("mayor").move(Vector2(1391, - 2103))
			npc.get("mayor").move_along_path([Vector2(86, - 149), Vector2(79, - 149)])
			yield (npc.get("mayor"), "npc_arrived")
			npc.get("mayor").align(Vector2( - 1, 0))
			
			dialog.toggle_cutscenes_bar(false)
			
			dialog.display("Walikota", "Ada apa ribut-ribut begini?")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga", "Banteng pengikut megatron itu menumpahkan ramuan mahal yang baru saja aku beli di kota elf, pak walikota!", "vill/11")
			yield (dialog, "dialog_ended")
			
			dialog.display("Minotaur", "Manusia itu yang jalannya tidak lihat-lihat!", "mino/24")
			yield (dialog, "dialog_ended")
			
			npc.get("villager5").hide_emoji()
			npc.get("minotaur").hide_emoji()
			
			dialog.display("Walikota", "Sudah-sudah. Karena akan terjadi kekacauan jika kita membahasnya disini, mari kita adakan sidang di kantor walikota. Kalian berdua, ikut aku.")
			yield (dialog, "dialog_ended")
			
			npc.get("mayor").move_along_path([Vector2(79, - 149), Vector2(86, - 132)])
			yield (get_tree().create_timer(1), "timeout")
			
			npc.get("minotaur").move_along_path([Vector2(79, - 149), Vector2(86, - 132)])
			yield (get_tree().create_timer(1), "timeout")
			
			npc.get("villager5").move_along_path([Vector2(79, - 149), Vector2(86, - 132)])
			yield (npc.get("villager5"), "npc_arrived")
			
			npc.get("mayor").disable()
			npc.get("minotaur").disable()
			npc.get("villager5").disable()
			
			dialog.display("Althea", "(Wah, tiba-tiba mereka tenang dan mau mengikuti persidangan.)")
			yield (dialog, "dialog_ended")
			
			player.is_in_cutscene = false
			
			show_notes("Ajudikasi", "Bentuk akomodasi yang melibatkan pihak pengadilan untuk menyelesaikan konflik. Kedua pihak biasanya lebih memilih pengadilan sebagai pihak ketiga karena akan ada sidang yang akan memberikan jawaban tentang konflik yang terjadi.")
			yield (self, "ok_pressed")

			ui_show()

		"night_transition":
			ui_hide()
			mission.remove_mission("explore")
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			game.already_night = true
			night.show()
			
			hide_npcs(["villager", "villager2", "villager4", "villager5", "villager6", "villager7", "villager8", "minotaur", "hoglin", "ork_contractor"])
			hide_decorations(["hoglin2", "hoglin3", "villager", "villager2", "villager3", "villager4", "villager5", "villager6", "villager7", "mino", "nobleman", "blacksmith", "tavern_mayor", "farmer", "archer_2", "archer_3"])
			show_decorations(["elf", "elf2", "elf3", "dark_elf", "dark_elf2"])
			
			for child in side_npc.get_children():
				child.disable()
			
			player.light.show()
			
			turn_off_bgm()
			yield (get_tree().create_timer(1), "timeout")
			play_bgm("night_bgm")
			
			npc.get("arin_grave").enable()
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Althea", "(Wah tak terasa sudah sore sekarang.)", "althea/98")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "(Para warga sudah mengakhiri aktifitas mereka.)", "althea/99")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "(Dan aku juga sudah mulai lapar ...)", "althea/100")
			yield (dialog, "dialog_ended")
			
			mission.add_mission("go_to_restaurant", "Pergi ke restoran.")
			
			player.wait_player_at(Vector2(160, - 121), "mission_17")
			
			food.set_cell(59, - 38, - 1)

			ui_show()

		"mission_17":
			ui_hide()
			mission.remove_mission("go_to_restaurant")
			
			dialog.display("Penjaga restoran", "Ah kau, kita bertemu lagi.", "bartender/21")
			yield (dialog, "dialog_ended")
			
			player.align(Vector2(0, - 1))
			
			dialog.display("Penjaga restoran", "Kau ingin pesan apa kali ini?", "bartender/22")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Hmmm, sepertinya kali ini aku akan memesan roti saja.", "althea/101")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga restoran", "Baik. Silahkan cari tempat duduk.", "bartender/23")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Baiklah.", "althea/102")
			yield (dialog, "dialog_ended")
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			player.move(Vector2(2807, - 1788))
			player.z_index = 0
			player.align(Vector2(0, 0))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			player.is_in_cutscene = true
			dialog.toggle_cutscenes_bar(true)
			
			yield (get_tree().create_timer(1), "timeout")
			npc.get("bartender").move_along_path([Vector2(163, - 120), Vector2(163, - 114), Vector2(173, - 114), Vector2(173, - 112)])
			yield (npc.get("bartender"), "npc_arrived")
			npc.get("bartender").align(Vector2(1, 0))
			
			dialog.toggle_cutscenes_bar(false)
			
			dialog.display("Penjaga restoran", "Permisi, ini pesanannya.", "bartender/24")
			yield (dialog, "dialog_ended")
			
			food.set_cell(58, - 38, 368)
			
			dialog.display("Althea", "Apakah aku boleh bertanya sesuatu?", "althea/103")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga restoran", "Iya. Silahkan.", "bartender/25")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Mengapa elf-elf itu saling berjauh-jauhan?", "althea/104")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga restoran", "Oh, karena mereka bukan elf biasa, melainkan dark elf.", "bartender/26")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Dark elf?", "althea/105")
			yield (dialog, "dialog_ended")

			dialog.display("Penjaga restoran", "Lihat meja paling ujung? Itu adalah ras Elf. Sedangkan yang ada di sampingmu itu adalah dark elf. Selain memiliki perbedaan pada fisik, mereka juga memiliki perbedaan sumber kekuatan.", "bartender/27")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga restoran", "Elf menggunakan kekuatan cahaya untuk menggunakan sihirnya, sedangkan dark elf menggunakan kekuatan kegelapan untuk menggunakan sihir.", "bartender/28")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga restoran", "Dulu sempat terjadi perang besar antara kedua jenis elf itu. Untungnya, mereka kembali berdamai karena bersatu melawan invasi demon.", "bartender/29")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga restoran", "Tapi, tetap saja jika ras elf dan dark elf bertemu mereka akan saling berjauhan agar tak terjadi konflik seperti dahulu lagi.", "bartender/30")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Oh, baik. Terima kasih.", "althea/106")
			yield (dialog, "dialog_ended")

			dialog.display("Althea", "Lalu bolehkah aku bertanya satu hal lagi?", "althea/107")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga restoran", "Silahkan.", "bartender/31")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Dimana aku bisa menginap?", "althea/108")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga restoran", "Kau bisa pergi ke penginapan di sebelah barat alun-alun.", "bartender/32")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Oh, baik. Terima kasih lagi.", "althea/109")
			yield (dialog, "dialog_ended")
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			food.set_cell(58, - 38, - 1)
			
			player.z_index = 2
			player.is_in_cutscene = false
			player.move(Vector2(2807, - 1836))
			npc.get("bartender").move(Vector2(2565, - 1914))
			npc.get("bartender").align(Vector2(0, 0))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Althea", "Enak sekali. Mungkin karena aku juga sedang lapar, sih.", "althea/110")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Sebaiknya aku cepat-cepat pergi ke penginapan.", "althea/111")
			yield (dialog, "dialog_ended")
			
			mission.add_mission("go_to_inn", "Pergi ke penginapan.")
			
			player.wait_player_at(Vector2(171, - 164), "inn")
			
			ui_show()
			
		"inn":
			ui_hide()
			mission.remove_mission("go_to_inn")
			
			enter_room.disabled = false
			
			dialog.display("Penjaga penginapan", "Selamat datang di penginapan!", "innkeeper/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Aku ingin memesan kamar untuk semalam.", "althea/112")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga penginapan", "Baik. Ini kuncinya. Kamarmu berada di pintu sana.", "innkeeper/2")
			yield (dialog, "dialog_ended")
			
			player.wait_player_at(Vector2(163, - 205), "sleep")
			
			ui_show()
			
		"sleep":
			ui_hide()
			
			dialog.display("Althea", "Ah, sungguh hari yang menyenangkan.", "althea/113")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Semoga besok bisa semenyenangkan hari ini juga.", "althea/114")
			yield (dialog, "dialog_ended")
			
			turn_off_bgm()
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			yield (get_tree().create_timer(1), "timeout")
			game.already_night = false
			
			show_decorations(["hoglin2", "hoglin3", "villager", "villager2", "villager3", "villager4", "villager5", "villager6", "villager7", "mino", "nobleman", "blacksmith", "farmer", "archer_2", "archer_3"])
			hide_decorations(["elf", "elf2", "elf3", "dark_elf", "dark_elf2"])
			
			play_bgm("town_bgm")
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Althea", "Tidurku semalam sungguh nyenyak.")
			yield (dialog, "dialog_ended")
			
			show_decorations(["villager8", "villager9", "villager10", "innkeeper"])
			for child in side_npc.get_children():
				child.enable()
			
			player.wait_player_at(Vector2(160, - 170), "mission_18")
			
			ui_show()
			
		"mission_18":
			ui_hide()
			
			npc.get("mayor").move(Vector2(943, - 1999))
			npc.get("mayor").enable()
			
			npc.get("guard_captain").move(Vector2(895, - 2039))
			npc.get("guard_captain").align(Vector2(1, 0))
			npc.get("guard_captain").enable()
			
			npc.get("innkeeper").display_emoji("exclamation")
			npc.get("innkeeper").align(Vector2( - 1, 0))
			dialog.display("Penjaga penginapan", "Selamat pagi. Kau baru bangun ya rupanya. Aku akan pergi sebentar untuk mengerjakan Crescent. Apa kau mau ikut?", "innkeeper/3")
			yield (dialog, "dialog_ended")
			npc.get("innkeeper").hide_emoji()

			player.align(Vector2(1, 0))
			dialog.display("Althea", "Crescent? Apa itu?", "althea/121")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga penginapan", "Crescent adalah sebuah senjata yang akan digunakan untuk melawan invasi demon.", "innkeeper/4")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Oh, begitu.", "althea/122")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga penginapan", "Ngomong-ngomong, kau mau ikut?", "innkeeper/5")
			yield (dialog, "dialog_ended")
			
			player.is_in_cutscene = true
			
			dialog.display("Althea", "Aku akan ikut.", "althea/123")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga penginapan", "Baiklah. Ayo berangkat bersama.", "innkeper/6")
			yield (dialog, "dialog_ended")
			
			transition.play("transition")
			yield (transition, "animation_finished")
		
			player.move(Vector2(1015, - 2060))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Warga", "Baiklah, aku sudah membawa rancangan dari Crescent. Silahkan kalian lihat.", "vill9/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Elf", "Wah, sungguh keagungan yang luar biasa.", "elf/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Minotaur", "Senjata ini sangat bagus. Pasti akan berguna.", "mino/31")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga", "Iya. Senjata ini akan sangat membantu kita untuk melawan invasi demon di tanah seberang.", "vill9/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Elf", "Tapi, bukankan akan sangat berbahaya apabila senjata ini jatuh ke tangan yang salah?", "elf/3")
			yield (dialog, "dialog_ended")
			
			dialog.display("Minotaur", "Tenang saja. senjata ini pasti akan selalu aman.", "mino/32")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga", "Sesuai perjanjian kita, maka mari kita mulai pengerjaan Crescent. Kami, manusia akan memberikan kemampuan terbaik kami untuk mendesain senjata ini. Minotaur, tolong kumpulkan bahan-bahan yang diperlukan bersama dengan para Minoan lainnya. Elf, tolong bantu meningkatkan senjata ini dengan kekuatan magis dari ras kalian.", "vill9/3")
			yield (dialog, "dialog_ended")
			
			dialog.display("Minotaur", "Baik. Kami akan membantu semaksimal mungkin.", "mino/33")
			yield (dialog, "dialog_ended")
			
			dialog.display("Warga", "Baiklah, ayo mulai bekerja!", "vill9/4")
			yield (dialog, "dialog_ended")
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			hide_decorations(["villager8", "villager9", "villager10"])

			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Althea", "Jadi ini, senjata hasil dari perpaduan 3 ras?", "althea/124")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga penginapan", "Iya, sangat menarik bukan, 3 ras yang memiliki kepentingan berbeda dapat disatukan karena suatu hal.", "innkeeper/7")
			yield (dialog, "dialog_ended")

			show_notes("Asimilasi", "Usaha-usaha untuk meredakan perbedaan antarindividu atau antarkelompok guna mencapai satu kesepakatan berdasarkan kepentingan dan tujuan-tujuan bersama.")
			yield (self, "ok_pressed")

			yield (get_tree().create_timer(1), "timeout")

			action("mission_19")

		"mission_19":
			player.is_in_cutscene = true
			play_bgm("bomb_bgm")
			
			npc.get("guard").move(Vector2(1448, - 1974))
			npc.get("guard").enable()
			npc.get("guard").move_along_path([Vector2(65, - 124), Vector2(65, - 126)])
			yield (npc.get("guard"), "npc_arrived")
			npc.get("guard").align(Vector2( - 1, 0))
			
			dialog.display("Penjaga", "Ga-gawat! Para demon sedang berjalan menuju kota!", "guard2/1")
			yield (dialog, "dialog_ended")
			
			npc.get("mayor").display_emoji("exclamation")
			npc.get("mayor").align(Vector2(1, 0))
			
			dialog.display("Walikota", "Pasti rencana pengerjaan Crescent sudah bocor.", "mayor/41")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Baiklah, evakuasi perempuan dan anak-anak dahulu.", "mayor/42")
			yield (dialog, "dialog_ended")
			npc.get("mayor").hide_emoji()
			
			npc.get("mayor").align(Vector2(0, - 1))
			dialog.display("Walikota", "Lalu, kumpulkanlah semua orang yang bisa bertarung, kepala penjaga.", "mayor/43")
			yield (dialog, "dialog_ended")
			
			dialog.display("Kepala penjaga", "Baik.")
			yield (dialog, "dialog_ended")
			
			npc.get("guard_captain").move_along_path([Vector2(58, - 124), Vector2(90, - 124)])
			yield (get_tree().create_timer(1), "timeout")
			npc.get("guard").move_along_path([Vector2(65, - 124), Vector2(90, - 124)])
			yield (npc.get("guard_captain"), "npc_arrived")
		
			transition.play("transition")
			yield (transition, "animation_finished")
		
			camera.set_process(true)
			camera.set_camera_follow(false)
			camera.global_position = Vector2(722, - 3252)
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			explosion.show()
			explosion.play("default")
			yield (get_tree().create_timer(1), "timeout")
			explosion.hide()
			
			tween.interpolate_property(wall, "global_position", global_position, Vector2(global_position.x, global_position.y + 250), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			hide_npcs(["villager", "villager2", "villager4", "villager5", "villager6", "villager7", "villager8", "minotaur", "hoglin", "ork_contractor", "bartender"])
			hide_decorations(["hoglin2", "hoglin3", "villager", "villager2", "villager3", "villager4", "villager5", "villager6", "villager7", "mino", "nobleman", "blacksmith", "tavern_mayor", "farmer", "archer_2", "archer_3", "innkeeper"])
			
			for child in side_npc.get_children():
				child.queue_free()
			
			after_attack.show()
			
			yield (get_tree().create_timer(1), "timeout")
			camera.set_process(false)
			wall.queue_free()
			
			npc.get("azazel").move_along_path([Vector2(45, - 207)])
			npc.get("azazel").get_node("animated").play("walk")
			yield (npc.get("azazel"), "npc_arrived")
			npc.get("azazel").get_node("animated").play("idle")
			
			dialog.display("Azazel", "HAHAHAHAHHA. Sepertinya kalian masih terlalu lemah, manusia. Tembok yang kalian buat ini sangat lembut seperti tahu. Mudah untuk dihancurkan!", "azazel/1")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Dasar demon sialan! Apa yang kalian mau?", "mayor/44")
			yield (dialog, "dialog_ended")
			
			dialog.display("Azazel", "Dasar manusia bodoh! Kalian masih tak sadar? Kami menginginkan nyawa kalian dan ketakutan kalian. HAHAHAHAHA.", "azazel/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Azazel", "Selain itu, aku mendengar dari mata-mataku bahwa kalian sedang membuat sebuah senjata untuk mengalahkan kami.", "azazel/3")
			yield (dialog, "dialog_ended")
			
			dialog.display("Azazel", "Aku tak ingin mainan buatan kalian itu menyulitkanku di masa depan. Jadi akan kuhancurkan sekarang.", "azazel/4")
			yield (dialog, "dialog_ended")
			
			dialog.display("Azazel", "Karena aku sedang baik hati, sekarang kuberi pilihan. Serahkan 10 tumbal kepadaku dan hancurkan senjata itu, atau akan ku ratakan kota ini dengan tanah!", "azazel/5")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Tidak akan pernah!", "mayor/45")
			yield (dialog, "dialog_ended")
			
			dialog.display("Azazel", "Dasar kalian manusia menyedihkan. SERANG!", "azazel/6")
			yield (dialog, "dialog_ended")
			
			for child in npc.get("undead").get_children():
				if (child is AnimatedSprite):
					child.play("walk")
					child.frame = rand_range(0, 8)
					
			npc.get("undead").move_along_path([Vector2(45, - 190)])
			
			npc.get("azazel").get_node("animated").play("walk")
			npc.get("azazel").move_along_path([Vector2(45, - 190)])
			yield (npc.get("azazel"), "npc_arrived")
			
			npc.get("azazel").disable()
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			for child in npc.get("undead").get_children():
				if (child is AnimatedSprite):
					child.play("idle")
			
			camera.set_camera_follow(true)
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Walikota", "Sebaiknya kita segera berlindung. Biarkan kepala penjaga dan yang lain yang mengurusnya.", "mayor/46")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Ba-baik.", "althea/125")
			yield (dialog, "dialog_ended")
			
			camera.set_camera_follow(false)
			
			npc.get("mayor").move_along_path([Vector2(58, - 124), Vector2(90, - 124)])
			yield (get_tree().create_timer(1), "timeout")
			player.move_along_path([Vector2(62, - 124), Vector2(88, - 124)])
			yield (npc.get("mayor"), "npc_arrived")
			
			npc.get("mayor").align(Vector2( - 1, 0))
			player.align(Vector2(1, 0))
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			camera.global_position = Vector2(716, - 2938)
			npc.get("guards").enable()
			npc.get("guard_captain").move(Vector2(564, - 2866))
			npc.get("guard_captain").align(Vector2(0, - 1))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Kepala penjaga", "Para penjaga. Ini adalah kota yang kita cintai. Jangan biarkan kota ini hancur begitu saja.", "guard_captain/6")
			yield (dialog, "dialog_ended")
			
			dialog.display("Kepala penjaga", "SASAGEYOOOOOO!", "guard_captain/7")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga", "SASAGEYOOOOOOOO!", "guard2/2")
			yield (dialog, "dialog_ended")
			
			dialog.display("Azazel", "HAHAHAHHA! Menarik ...", "azazel/7")
			yield (dialog, "dialog_ended")
			
			dialog.display("Azazel", "Binasakan mereka! Jangan ada yang lolos!", "azazel/8")
			yield (dialog, "dialog_ended")
			
			dialog.display("Kepala penjaga", "Jangan gentar! MAJUUUU!", "guard_captain/8")
			yield (dialog, "dialog_ended")
			
			camera.set_process(true)
			npc.get("undead").move_along_path([Vector2(45, - 185)])
			npc.get("guards").move_along_path([Vector2(45, - 185)])
			for child in npc.get("undead").get_children():
				if (child is AnimatedSprite):
					child.play("walk")
					child.frame = rand_range(0, 8)
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			camera.set_camera_follow(true)
			camera.set_process(false)
			properties.show()
			overlay.show()
			npc.get("guards").disable()
			npc.get("guard").disable()
			npc.get("undead").disable()
			
			yield (get_tree().create_timer(2), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Walikota", "Penyerangan tadi lumayan dasyat juga.", "mayor/47")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Untungnya penjaga kota berhasil menahan serangan itu.", "mayor/48")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Iya.", "althea/126")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Baiklah kalau begitu. Aku akan memeriksa kondisi kota sebentar.", "mayor/49")
			yield (dialog, "dialog_ended")
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			player.is_in_cutscene = false
			afterbattle.show()
			npc.get("mayor").align(Vector2(0, - 1))
			npc.get("mayor").move(Vector2(910, - 2774))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			show_notes("Konflik", "Suatu perjuangan individu atau kelompok sosial untuk memenuhi tujuannya dengan jalan menantang pihak lawan. Konflik biasa terjadi dengan disertai ancaman atau kekerasan.")
			yield (self, "ok_pressed")
			
			mission.add_mission("find_mayor", "Cari walikota.")
			ui_show()
			
			player.wait_player_at(Vector2(57, - 172), "sub_ending")
			
		"sub_ending":
			ui_hide()
			mission.remove_mission("find_mayor")
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			player.move(Vector2(862, - 2774))
			player.align(Vector2(1, 0))
			
			npc.get("guard_captain").disable()
			
			npc.get("mayor").enable()
			npc.get("mayor").align(Vector2( - 1, 0))
			
			npc.get("guard").enable()
			npc.get("guard").move(Vector2(966, - 2814))
			npc.get("guard").align(Vector2( - 1, 0))
			
			npc.get("villager").show_interactable_text = false
			npc.get("villager").enable()
			npc.get("villager").move(Vector2(822, - 2702))
			npc.get("villager").align(Vector2(0, - 1))
			
			npc.get("villager2").enable()
			npc.get("villager2").move(Vector2(790, - 2734))
			npc.get("villager2").align(Vector2(0, - 1))
			
			npc.get("guard2").enable()
			npc.get("guard3").enable()
			
			player.is_in_cutscene = true
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Althea", "Situasi tadi kacau juga ya. Tapi ternyata kota ini bisa menanganinya.")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Iya. Ini karena seluruh kota ini dapat bekerja sama.")
			yield (dialog, "dialog_ended")
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			camera.set_camera_follow(false)
			camera.global_position = Vector2(110, - 3310)
			npc.get("maskedman").enable()
			npc.get("maskedman").move(Vector2(110, - 3310))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Orang bertopeng", "AHAHAHAHAH.", "masked_man/11")
			yield (dialog, "dialog_ended")
			
			dialog.display("Orang bertopeng", "Aku sudah memasang bom di seluruh kota ini.", "masked_man/12")
			yield (dialog, "dialog_ended")
			
			dialog.display("Orang bertopeng", "Bomnya akan meledak dalam kurun waktu 1 jam lagi. Aku akan membuat kota ini dengan rata dengan tanah!", "masked_man/13")
			yield (dialog, "dialog_ended")
			
			npc.get("maskedman").speed = 200
			npc.get("maskedman").move_along_path([Vector2( - 15, - 207)])
			yield (npc.get("maskedman"), "npc_arrived")
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			camera.set_camera_follow(true)
			npc.get("maskedman").disable()
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Walikota", "Aku kira situasi sudah aman. Tapi ternyata, ada lagi masalah ya ...", "mayor/51")
			yield (dialog, "dialog_ended")
		
			dialog.display("Walikota", "Para penjaga juga sedang terluka sekarang. Kami akan kesulitan untuk mencari dan menjinakkan seluruh bom yang ada di kota ini.", "mayor/52")
			yield (dialog, "dialog_ended")
			
			dialog.display_choices(["Tawarkan bantuan", "Pulang"])
			var result = yield (dialog, "dialog_ended")

			if (result == 0):
				dialog.display("Althea", "Emm ... pak walikota, bagaimana jika aku membantu untuk mencari bom?", "althea_end/2")
				yield (dialog, "dialog_ended")
				
				dialog.display("Walikota", "Hmm, sepertinya aku pernah melihatmu sebelumnya. Siapa kau?")
				yield (dialog, "dialog_ended")
				
				dialog.display("Althea", "Itu tidak penting sekarang pak. Aku akan mencari bom-bom itu. Sebaiknya Anda dan para penjaga mencari dan menangkap dalang di balik ini semua, sebelum ia kabur lebih jauh.")
				yield (dialog, "dialog_ended")
				
				dialog.display("Walikota", "A-apa kau yakin?", "mayor/53")
				yield (dialog, "dialog_ended")
				
				dialog.display("Althea", "Iya, pak walikota. Aku akan membantu semampuku.", "althea_end/3")
				yield (dialog, "dialog_ended")

				npc.get("mayor").align(Vector2(0, - 1))
				dialog.display("Walikota", "Baiklah para penjaga, kalian dengar dia. Ayo kita cari pelaku dari pengebomban ini!")
				yield (dialog, "dialog_ended")
				
				dialog.display("Penjaga", "Laksanakan.")
				yield (dialog, "dialog_ended")
			
				npc.get("guard").speed = 200
				npc.get("guard2").speed = 200
				npc.get("guard3").speed = 200
		
				npc.get("guard").move_along_path([Vector2(57, - 187)])
				npc.get("guard2").move_along_path([Vector2(46, - 187)])
				npc.get("guard3").move_along_path([Vector2(71, - 187)])
				yield (npc.get("guard"), "npc_arrived")
				npc.get("guard").disable()
				npc.get("guard2").disable()
				npc.get("guard3").disable()

				action("find_bombs")
			else :
				dialog.display("Althea", "Sepertinya ini saat yang tepat untukku pulang ...", "althea_end/1")
				yield (dialog, "dialog_ended")
				
				action("sacrificed_ending")
				
		"find_bombs":
				bomb_timer.show()
				bomb_timer.get_node("timer").start()
				tween.interpolate_property(bomb_timer.get_node("hbox/time"), "value", 100, 0, 600, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				tween.start()
			
				ui_show()
			
				bomb.activate()
				mission.add_mission("find_bombs", "Cari bom (0/15)")
				player.is_in_cutscene = false
				
		"bombs_finded":
			ui_hide()
			bomb_timer.hide()
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			player.move(Vector2(862, - 2774))
			player.align(Vector2(1, 0))
			
			npc.get("mayor").align(Vector2( - 1, 0))
			
			var masked = load("res://characters/masked_man.png")
			var mask_open = load("res://characters/masked_captain.png")
			
			npc.get("captain").sprite.texture = masked
			npc.get("captain").enable()
			npc.get("captain").move(Vector2(878, - 2822))
			npc.get("captain").align(Vector2(0, 0))
			
			npc.get("guard").enable()
			npc.get("guard").move(Vector2(918, - 2822))
			npc.get("guard").align(Vector2( - 1, 0))
			
			npc.get("guard2").enable()
			npc.get("guard2").move(Vector2(798, - 2824))
			npc.get("guard2").align(Vector2(1, 0))
		
			npc.get("guard3").enable()
			npc.get("guard3").move(Vector2(902, - 2896))
			npc.get("guard2").align(Vector2(0, 0))
			
			player.is_in_cutscene = true
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Walikota", "Kau sudah kembali ya, cepat sekali.", "mayor/61")
			yield (dialog, "dialog_ended")

			dialog.display("Walikota", "Terima kasih sudah membantu kami. Saat kau mencari bom, kami juga sudah menangkap pelaku yang meletakkan bom-bom itu.", "mayor/62")
			yield (dialog, "dialog_ended")
			
			dialog.display("Walikota", "Nah, ini dia pelakunya. Ayo, buka topengnya.", "mayor/63")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga", "Laksanakan.")
			yield (dialog, "dialog_ended")
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			npc.get("captain").sprite.texture = mask_open
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			npc.get("mayor").display_emoji("exclamation")
			dialog.display("Walikota", "Ke-kepala penjaga? Bukankah kau masih di penjara? Bagaimana bisa ...", "mayor/64")
			yield (dialog, "dialog_ended")
			npc.get("mayor").hide_emoji()
			
			npc.get("villager").display_emoji("anger")
			dialog.display("Warga 1", "Sudah pak walikota, tidak usah berlama-lama. Langsung kita bakar dia saja hidup-hidup!", "vill9/11")
			yield (dialog, "dialog_ended")

			npc.get("villager2").display_emoji("anger")
			dialog.display("Warga 2", "Iya. Aku setuju!", "vill8/1")
			yield (dialog, "dialog_ended")
			
			npc.get("villager").hide_emoji()
			npc.get("villager2").hide_emoji()
			
			dialog.display_choices(["Bakar", "Ajak bicara dulu"])
			var result = yield (dialog, "dialog_ended")
			
			if (result == 0):
				dialog.display("Althea", "Saya setuju, pak walikota. Orang seperti ini sebaiknya kita hukum saja agar tidak menyusahkan kita lebih lanjut.", "althea_end/15")
				yield (dialog, "dialog_ended")
				
				dialog.display("Walikota", "Baiklah ... baiklah ... karena kepala penjaga ini sudah cukup menyusahkan kita, maka akan saya jatuhi hukuman bakar sekarang. Penjaga, siapkan api untuk membakarnya dan pastikan dia tidak lolos lagi.", "mayor/71")
				yield (dialog, "dialog_ended")
				
				dialog.display("Penjaga", "Laksanakan.")
				yield (dialog, "dialog_ended")
				
				transition.play("transition")
				yield (transition, "animation_finished")
				
				npc.get("captain").disable()
				npc.get("guard").disable()
				npc.get("guard2").disable()
				npc.get("guard3").disable()
				
				yield (get_tree().create_timer(1), "timeout")
				transition.play_backwards("transition")
				yield (transition, "animation_finished")
				
				dialog.display("Althea", "Baiklah. Sepertinya, semua masalah sudah selesai.", "althea_end/16")
				yield (dialog, "dialog_ended")
			
				dialog.display("Althea", "Ini waktu yang tepat untukku pulang", "althea_end/17")
				yield (dialog, "dialog_ended")
			
				dialog.display("Walikota", "Baiklah nak. Hati-hati di jalan.", "mayor/72")
				yield (dialog, "dialog_ended")
				
				action("bad_ending")
			else :
				dialog.display("Althea", "Sebaiknya kita bicara dengannya dahulu, pak walikota.", "althea_end/31")
				yield (dialog, "dialog_ended")
				
				npc.get("mayor").align(Vector2(0, 0))
				dialog.display("Walikota", "Itu benar para wargaku. Tak baik jika kita melakukan tindakan anarkis seperti itu.", "mayor/81")
				yield (dialog, "dialog_ended")
				
				npc.get("mayor").align(Vector2(0, - 1))
				player.align(Vector2(0, - 1))
				dialog.display("Walikota", "Kepala penjaga, apa yang menjadi motifmu untuk meletakkan bom-bom itu di kota?", "mayor/82")
				yield (dialog, "dialog_ended")
				
				dialog.display("Kepala penjaga", "I-itu karena kontrakku ...", "captain/31")
				yield (dialog, "dialog_ended")
				
				dialog.display("Walikota", "Kontrak?", "mayor/83")
				yield (dialog, "dialog_ended")
			
				dialog.display("Kepala penjaga", "Saat aku dipenjara, ada orang bertopeng yang menghampiriku dan menawarkan sebuah kontrak.", "captain/32")
				yield (dialog, "dialog_ended")
				
				dialog.display("Kepala penjaga", "Dia berjanji untuk membantuku balas dendam ...", "captain/33")
				yield (dialog, "dialog_ended")
				
				dialog.display("Kepala penjaga", "Sebagai imbalan untuk bantuannya, Orang itu menyuruhku untuk meletakkan bom dan memakai topeng ini untuk menyamar menjadi dirinya.", "captain/34")
				yield (dialog, "dialog_ended")
				
				dialog.display("Kepala penjaga", "Tapi ternyata, dia tak benar-benar membantuku.", "captain/35")
				yield (dialog, "dialog_ended")
				
				dialog.display("Kepala penjaga", "Aku cuma dimanfaatkan oleh orang itu.", "captain/36")
				yield (dialog, "dialog_ended")
				
				dialog.display("Walikota", "Benarkah? Kau tahu siapa orang itu?", "mayor/84")
				yield (dialog, "dialog_ended")
				
				dialog.display("Kepala penjaga", "Aku tak tahu pasti. Tapi yang pasti dia adalah orang suruhan raja.", "captain/37")
				yield (dialog, "dialog_ended")
				
				dialog.display("Althea", "(Apa? Suruhan ayah?)", "althea_end/32")
				yield (dialog, "dialog_ended")

				dialog.display("Walikota", "Untuk apa raja mengebom kotanya sendiri?", "mayor/85")
				yield (dialog, "dialog_ended")
				
				dialog.display("Warga 1", "Iya. Ini tidak masuk akal. Apa kalian benar-benar percaya dengan koruptor ini?", "vill9/12")
				yield (dialog, "dialog_ended")
				
				dialog.display("Kepala penjaga", "Pe-percayalah padaku kali ini. Ini mungkin tak masuk akal, tapi raja memanfaatkan kerusuhan melakukan ini untuk mendapatkan tumbal sebagai perubahannya menjadi demon ...", "captain/38")
				yield (dialog, "dialog_ended")

				dialog.display("Kepala penjaga", "Serangan Azazel dan pengeboman ini hanya untuk pengalihan dan membuat kepanikan. Saat para warga panik, aku juga diperintahkan untuk menangkap dan menculik beberapa warga ...", "captain/39")
				yield (dialog, "dialog_ended")
				
				dialog.display("Warga 2", "De-demon? Jadi raja kita selama ini adalah pengikut demon?", "vill8/2")
				yield (dialog, "dialog_ended")
				
				dialog.display("Warga 1", "T-tidak mungkin!", "vill9/13")
				yield (dialog, "dialog_ended")

				dialog.display("Kepala penjaga", "Aku tak yakin. Tapi yang pasti raja sedang bersiap untuk-", "captain/40")
				yield (dialog, "dialog_ended")
				
				dialog.display("Kepala penjaga", "Argh ...")
				yield (dialog, "dialog_ended")
				
				npc.get("captain").animation.get("parameters/playback").travel("die")
				yield (get_tree().create_timer(1), "timeout")
				
				camera.set_camera_follow(false)
				camera.global_position = Vector2(902, - 3016)
				
				npc.get("maskedman").enable()
				npc.get("maskedman").align(Vector2(0, 0))
				npc.get("maskedman").move(Vector2(902, - 3016))
				
				dialog.display("Orang bertopeng", "Kau bicara terlalu banyak, kepala penjaga.", "masked_man/14")
				yield (dialog, "dialog_ended")
				
				npc.get("maskedman").move_along_path([Vector2(41, - 188)])
				yield (npc.get("maskedman"), "npc_arrived")
				
				camera.set_camera_follow(true)
				
				dialog.display("Walikota", "Dia pasti orang bertopeng yang asli. Tangkap dia, penjaga!", "mayor/91")
				yield (dialog, "dialog_ended")
				
				npc.get("guard").move_along_path([Vector2(46, - 187)])
				npc.get("guard2").move_along_path([Vector2(46, - 187)])
				npc.get("guard3").move_along_path([Vector2(46, - 187)])

				dialog.display("Althea", "Sepertinya, aku sudah harus pergi sekarang.", "althea_end/33")
				yield (dialog, "dialog_ended")
				
				dialog.display("Althea", "Pak walikota ... bolehkah aku meminta satu hal?", "althea_end/34")
				yield (dialog, "dialog_ended")
				
				npc.get("mayor").align(Vector2(0, 0))
				dialog.display("Walikota", "Tentu saja! Kau sudah menyelamatkan kota kami.", "mayor/92")
				yield (dialog, "dialog_ended")

				dialog.display("Althea", "Apakah aku bisa meminta Crescent kalian?", "althea_end/35")
				yield (dialog, "dialog_ended")
				
				dialog.display("Walikota", "Hmm ... benda itu lumayan sulit dibuat, sih. Tapi karena kau sudah menyelamatkan kota ini, aku akan memberikannya untukmu.", "mayor/93")
				yield (dialog, "dialog_ended")
				
				dialog.display("Althea", "Baiklah, terima kasih pak.", "althea_end/36")
				yield (dialog, "dialog_ended")
				
				action("good_ending")
				
		"good_ending":
			transition.play("transition")
			yield (transition, "animation_finished")
			
			turn_off_bgm()
			play_bgm("castle_final_bgm")
			
			night.show()
			get_node("/root/game/floor").hide()
			get_node("/root/game/castle").show()
			get_node("/root/game/sort/decorations/castle_guards").hide()
			
			player.move(Vector2(2807, - 577))
			player.align(Vector2(0, - 1))
			
			var no_shadow = load("res://characters/king_no_shadow.png")
						
			npc.get("king").move(Vector2(2806, - 814))
			npc.get("king").align(Vector2(0, - 1))
			npc.get("king").sprite.texture = no_shadow
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")

			player.move_along_path([Vector2(175, - 48)])
			yield (player, "player_arrived")
			
			dialog.display("Althea", "A-ayahanda!", "althea_end/41")
			yield (dialog, "dialog_ended")
			
			npc.get("king").align(Vector2(0, 0))
			dialog.display("Raja", "Anakku, kau sudah kembali ya ...", "king/100")
			yield (dialog, "dialog_ended")
			
			dialog.display("Raja", "Kau pasti sudah mengetahui rencanaku dari kepala penjaga, kan?", "king/101")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Mengapa ayahanda melakukan ini?", "althea_end/42")
			yield (dialog, "dialog_ended")

			dialog.display("Raja", "Tentu saja untuk keabadian! Sebagai demon, aku bisa hidup abadi!", "king/13")
			yield (dialog, "dialog_ended")
			
			dialog.display("Raja", "Ayo, bergabung denganku menjadi demon, wahai anakku.", "king/14")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Apa, demon? Tidak akan pernah! Ayahanda sendiri yang bilang kan, sebagai raja kita harus melindungi rakyat kita. Mengapa ayahanda malah mengorbankan rakyat demi kepuasan ayahanda sendiri?", "althea_end/43")
			yield (dialog, "dialog_ended")

			dialog.display("Raja", "Kau tahu nak, kita perlu mengorbankan sedikit hal untuk mendapatkan hal yang lebih besar ...", "king/15")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Tapi itu tak benar, ayahanda!", "althea_end/44")
			yield (dialog, "dialog_ended")
			
			dialog.display("Raja", "Benar-salah itu relatif nak. Kalau kau tak mau bergabung denganku, kau akan menjadi tumbal terakhirku untuk menjadi demon sejati! HAHAHHAHA.", "king/16")
			yield (dialog, "dialog_ended")
			
			tween.interpolate_property(hell_sfx, "volume_db", - 50, - 10, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			hell_sfx.playing = true
			
			camera.set_process(true)
			camera.set_camera_follow(false)
			tween.interpolate_property(npc.get("king"), "global_position:y", npc.get("king").global_position.y, npc.get("king").global_position.y - 64, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.interpolate_property(camera, "global_position:y", camera.global_position.y, camera.global_position.y - 64, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.interpolate_property(get_node("/root/game/night/ColorRect"), "color", get_node("/root/game/night/ColorRect").color, Color(0.16, 0, 0, 0.67), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			npc.get("king").animation.get("parameters/playback").travel("flying")
			
			yield (get_tree().create_timer(2), "timeout")
			
			dialog.display("Raja", "Kau akan melihat kekuatan demon sejati, nak. HAHAHAHHA.", "king/17")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Ayahanda, maafkan ananda ...", "althea_end/45")
			yield (dialog, "dialog_ended")
			
			get_node("/root/game/crescent_layer").show()
			crescent.show()
			tween.interpolate_property(crescent, "global_position:y", crescent.global_position.y, crescent.global_position.y - 64, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			yield (get_tree().create_timer(1.5), "timeout")
			
			dialog.display("Raja", "A-apa? Crescent?!", "king/18")
			yield (dialog, "dialog_ended")
			
			tween.interpolate_property(crescent.get_node("light"), "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.interpolate_property(crescent.get_node("light"), "scale", Vector2(0.1, 0.1), Vector2(10, 10), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			yield (get_tree().create_timer(1.5), "timeout")
			
			crescent.get_node("texture").hide()
			night.hide()
			camera.set_process(false)
			tween.interpolate_property(hell_sfx, "volume_db", - 10, - 50, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			
			tween.interpolate_property(crescent, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			yield (get_tree().create_timer(1.5), "timeout")
			hell_sfx.playing = false
			
			tween.interpolate_property(npc.get("king"), "global_position:y", npc.get("king").global_position.y, npc.get("king").global_position.y + 64, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			yield (get_tree().create_timer(1), "timeout")
			npc.get("king").animation.get("parameters/playback").travel("die_half_1")
			
			dialog.display("Raja", "Ah, annakku. Sepertinya kau sudah cocok menjadi raja, yah.", "king/19")
			yield (dialog, "dialog_ended")
			
			npc.get("king").animation.get("parameters/playback").travel("die_half_2")
			yield (get_tree().create_timer(1), "timeout")
			
			dialog.display("Althea", "Semoga begitu, ayahanda.")
			yield (dialog, "dialog_ended")
			
			ending.show()
			
			ending.get_node("container/vbox/label").text = "Ending 1"
			ending.get_node("container/vbox/text").text = "\"Invasion stopped.\""
			
			tween.interpolate_property(ending.get_node("color"), "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.interpolate_property(ending.get_node("container"), "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			turn_off_bgm()
			
			yield (get_tree().create_timer(1), "timeout")
			
			play_bgm("credit_bgm")
			
			yield (get_tree().create_timer(2), "timeout")
			
			tween.interpolate_property(ending.get_node("container"), "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			action("credit_roll")
			
			yield (get_tree().create_timer(0.5), "timeout")
			ending.hide()
			
		"bad_ending":
			transition.play("transition")
			yield (transition, "animation_finished")
			
			night.show()
			get_node("/root/game/floor").hide()
			get_node("/root/game/castle").show()
			get_node("/root/game/sort/decorations/castle_guards").hide()
			
			player.move(Vector2(2807, - 577))
			player.align(Vector2(0, - 1))
			
			var no_shadow = load("res://characters/king_no_shadow.png")
						
			npc.get("king").move(Vector2(2806, - 814))
			npc.get("king").align(Vector2(0, - 1))
			npc.get("king").sprite.texture = no_shadow
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")

			player.move_along_path([Vector2(175, - 48)])
			yield (player, "player_arrived")
			
			dialog.display("Althea", "A-ayahanda!", "althea_end/21")
			yield (dialog, "dialog_ended")
			
			npc.get("king").align(Vector2(0, 0))
			dialog.display("Raja", "AHAHAHAHHA. Kau pasti terkejut ya nak ...", "king/11")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Ayahanda ... Apa ayahanda melakukan kontrak dengan demon?", "althea_end/22")
			yield (dialog, "dialog_ended")
			
			dialog.display("Raja", "Kau pintar juga ya, nak.", "king/12")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Mengapa ayahanda melakukan ini?", "althea_end/23")
			yield (dialog, "dialog_ended")

			dialog.display("Raja", "Tentu saja untuk keabadian! Sebagai demon, aku bisa hidup abadi!", "king/13")
			yield (dialog, "dialog_ended")
			
			dialog.display("Raja", "Ayo, bergabung denganku menjadi demon, wahai anakku.", "king/14")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Apa, demon? Tidak akan pernah! Ayahanda sendiri yang bilang kan, sebagai raja kita harus melindungi rakyat kita. Mengapa ayahanda malah mengorbankan rakyat demi kepuasan ayahanda sendiri?", "althea_end/24")
			yield (dialog, "dialog_ended")

			dialog.display("Raja", "Kau tahu nak, kita perlu mengorbankan sedikit hal untuk mendapatkan hal yang lebih besar ...", "king/15")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Tapi itu tak benar, ayahanda!", "althea_end/25")
			yield (dialog, "dialog_ended")
			
			dialog.display("Raja", "Benar-salah itu relatif nak. Kalau kau tak mau bergabung denganku, kau akan menjadi tumbal terakhirku untuk menjadi demon sejati! HAHAHHAHA.", "king/16")
			yield (dialog, "dialog_ended")
			
			camera.set_process(true)
			camera.set_camera_follow(false)
			tween.interpolate_property(npc.get("king"), "global_position:y", npc.get("king").global_position.y, npc.get("king").global_position.y - 64, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.interpolate_property(camera, "global_position:y", camera.global_position.y, camera.global_position.y - 64, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.interpolate_property(get_node("/root/game/night/ColorRect"), "color", get_node("/root/game/night/ColorRect").color, Color(0.16, 0, 0, 0.67), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			npc.get("king").animation.get("parameters/playback").travel("flying")
			
			yield (get_tree().create_timer(2), "timeout")
			
			dialog.display("Raja", "Kau akan melihat kekuatan demon sejati, nak. HAHAHAHHA.", "king/17")
			yield (dialog, "dialog_ended")
			
			get_node("/root/game/crescent_layer").show()
			particle.show()
			tween.interpolate_property(particle, "modulate", Color(1, 1, 1, 0), Color(0.76, 0, 0, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			yield (get_tree().create_timer(3), "timeout")
			
			tween.interpolate_property(particle, "modulate", Color(1, 1, 1, 0), Color(0, 0, 0, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.interpolate_property(particle.get_node("light"), "scale", Vector2(0.1, 0.1), Vector2(10, 10), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			yield (get_tree().create_timer(1.5), "timeout")
			
			crescent.get_node("texture").hide()
			camera.set_process(false)
			
			particle.get_node("light").material = null
			particle.get_node("light").modulate = Color(0, 0, 0, 1)
			tween.interpolate_property(particle, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			player.hide()
			get_node("/root/game/castle/player").show()
			
			yield (get_tree().create_timer(1.5), "timeout")
			
			tween.interpolate_property(npc.get("king"), "global_position:y", npc.get("king").global_position.y, npc.get("king").global_position.y + 64, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			npc.get("king").animation.get("parameters/playback").travel("fall")
			yield (get_tree().create_timer(2), "timeout")
			
			dialog.display("Raja", "Akhirnya, aku bisa menggapai keabadian. Anakku, terima kasih sudah mau menjadi tumbalku. HAHAHAHAHAH.", "king/21")
			yield (dialog, "dialog_ended")
			
			ending.show()
			turn_off_bgm()
			
			ending.get_node("container/vbox/label").text = "Ending 2"
			ending.get_node("container/vbox/text").text = "\"Corrupted.\""
			
			tween.interpolate_property(ending.get_node("color"), "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.interpolate_property(ending.get_node("container"), "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			play_bgm("credit_bgm")
			
			yield (get_tree().create_timer(3), "timeout")
			
			tween.interpolate_property(ending.get_node("container"), "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			action("credit_roll")
			
			yield (get_tree().create_timer(0.5), "timeout")
			ending.hide()
			
		"sacrificed_ending":
			transition.play("transition")
			yield (transition, "animation_finished")
			
			play_bgm("castle_bgm")
			
			npc.get("king").move(Vector2(2806, - 814))
			npc.get("king").align(Vector2(0, - 1))
			
			player.move(Vector2(2807, - 577))
			player.align(Vector2(0, - 1))
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			player.move_along_path([Vector2(175, - 48)])
			yield (player, "player_arrived")
			
			npc.get("king").align(Vector2(0, 0))
			dialog.display("Raja", "Ah, anakku. Kau sudah kembali, ya. Kau kembali lebih cepat dari dugaanku. ")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Iya, ayahanda.")
			yield (dialog, "dialog_ended")
			
			dialog.display("Raja", "Padahal, aku baru saja ingin memulai pengorbanannya ...")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Pengorbanan? Pengorbanan apa?")
			yield (dialog, "dialog_ended")
			
			dialog.display("Raja", "Penasihat, cepat masuk dan bawa tumbal-tumbal itu.")
			yield (dialog, "dialog_ended")
			
			npc.get("maskedman").move(Vector2(2807, - 577))
			npc.get("maskedman").align(Vector2(0, - 1))
			camera.set_camera_follow(false)
			camera.global_position = Vector2(2807, - 577)
			
			dialog.display("Orang bertopeng", "Baik, yang mulia.")
			yield (dialog, "dialog_ended")
			
			camera.set_camera_follow(true)
			
			dialog.display("Raja", "HAHAHAHAHAHHA.")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "A-apa yang ayahanda lakukan?")
			yield (dialog, "dialog_ended")
			
			dialog.display("Raja", "Ah, aku butuh sedikit tumbal lagi ... Kau akan jadi tumbal terakhirku, nak ... HAHAHHAHAHAH.")
			yield (dialog, "dialog_ended")
			
			transition.play("transition")
			yield (transition, "animation_finished")
			
			play_bgm("castle_final_bgm")
			
			night.show()
			get_node("/root/game/floor").hide()
			get_node("/root/game/castle").show()
			get_node("/root/game/sort/decorations/castle_guards").hide()
			npc.get("maskedman").move_along_path([Vector2(175, - 49)])
			
			player.hide()
			get_node("/root/game/castle/player").show()
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Raja", "Akhirnya, aku bisa menggapai keabadian. Anakku, terima kasih sudah mau menjadi tumbalku. HAHAHAHAHAH.")
			yield (dialog, "dialog_ended")
			
			dialog.display("Raja", "Aku juga ingin berterima kasih padamu, penasihat. Karenamu, rencanaku dapat berjalan lancar.")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penasihat", "Itu bukan masalah besar, yang mulia.")
			yield (dialog, "dialog_ended")
			
			ending.show()
			turn_off_bgm()
			
			ending.get_node("container/vbox/label").text = "Ending 3"
			ending.get_node("container/vbox/text").text = "\"Sacrificed.\""
			
			tween.interpolate_property(ending.get_node("color"), "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.interpolate_property(ending.get_node("container"), "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			play_bgm("credit_bgm")
			
			yield (get_tree().create_timer(3), "timeout")
			
			tween.interpolate_property(ending.get_node("container"), "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			action("credit_roll")
			
			yield (get_tree().create_timer(0.5), "timeout")
			ending.hide()
			
		"credit_roll":
			title_screen.show()
			title_screen.get_node("animation").play("credit")

	if ("mission" in action_name):
		action_finished += 1
		
		if (action_finished < 16):
			mission.update_mission("explore", "Amati warga dan permasalahan-permasalahan mereka (" + str(action_finished) + "/16)")

	if (action_finished == 16 and not game.already_night):
		action("night_transition")

func ui_hide():
	mission.hide()
	mobile.hide()
	
func ui_show():
	mission.show()
	mobile.show()

func _on_crystal_talked_to_npc(x):
	action("take_crystal")
	get_node("/root/game/sort/objects/crystal").queue_free()
