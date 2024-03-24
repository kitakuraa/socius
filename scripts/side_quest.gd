extends Node2D

onready var game = get_node("/root/game")
onready var dialog = get_node("/root/game/cutscenes")
onready var cutscenes_bar = get_node("/root/game/cutscenes/cutscene_bar")
onready var player = get_node("/root/game/sort/player")
onready var camera = get_node("/root/game/camera")
onready var npc = get_node("/root/game/sort/npc_manager/")
onready var ui = get_node("/root/game/ui")
onready var transition = get_node("/root/game/transition/animation")
onready var mission = get_node("/root/game/ui")
onready var color = get_node("/root/game/title_screen/color")

var magician_state = "idle"
var collected_items = []

var player_as_girl = load("res://characters/player_as_girl.png")
var player_default = load("res://characters/player_as_folk.png")
var hoglin = load("res://characters/hoglin_1.png")

func _on_arin_grave_talked_to_npc(x):
	mission.hide()
	transition.play("transition")
	yield (transition, "animation_finished")
	
	player.align(Vector2(0, 0))
	player.move(Vector2(1038, 152))
	player.is_in_cutscene = true
	
	camera.set_camera_follow(false)
	camera.global_position = Vector2(1038, 184)
	
	yield (get_tree().create_timer(1), "timeout")
	transition.play_backwards("transition")
	yield (transition, "animation_finished")
	
	dialog.display("Althea", "Arin?")
	yield (dialog, "dialog_ended")
	
	npc.get("arin_grave").align(Vector2(0, - 1))
	dialog.display("Arin", "Althea ... maksudku, Pangeran Althea, kita bertemu lagi ya ...", "arin_side/1")
	yield (dialog, "dialog_ended")
	
	dialog.display("Althea", "Kau sudah tahu rahasiaku ya?", "althea_side/1")
	yield (dialog, "dialog_ended")
	
	dialog.display("Arin", "Kau juga sudah tau kan rahasiaku ... me-mengapa kau tak lari?", "arin_side/2")
	yield (dialog, "dialog_ended")

	dialog.display("Althea", "Iya. tapi mengapa aku harus lari?", "althea_side/2")
	yield (dialog, "dialog_ended")
	
	dialog.display("Arin", "Mereka bilang aku akan balas dendam dan membunuh siapapun yang menemuiku ... apa kau tak takut denganku?", "arin_side/3")
	yield (dialog, "dialog_ended")
	
	dialog.display("Althea", "Tidak mungkin. kakak sebaik dirimu tak akan melakukan itu. Aku tahu, kau bergentayangan bukan karena ingin balas dendam kan, tapi karena-", "althea_side/3")
	yield (dialog, "dialog_ended")
	
	dialog.display("Arin", "Karena Reo. Aku masih belum tenang melepasnya sendiri. Apalagi kedua orangtua kami sudah tiada. Hanya aku satu-satunya keluarganya sekarang.", "arin_side/4")
	yield (dialog, "dialog_ended")
	
	dialog.display("Althea", "Sudah kuduga. Jangan khawatir, Reo adalah anak yang kuat. Dia pasti bisa menjaga dirinya sendiri.", "althea_side/4")
	yield (dialog, "dialog_ended")
	
	dialog.display("Althea", "Aku juga bisa membantumu menjaganya jika kau mau.", "althea_side/5")
	yield (dialog, "dialog_ended")
	
	dialog.display("Arin", "Be-benarkah?", "arin_side/5")
	yield (dialog, "dialog_ended")
	
	dialog.display("Althea", "Iya. sekarang, kau bisa pergi dengan tenang. Aku juga akan memerintahkan orang kerajaan mengusut kasus pembunuhanmu. Aku akan memastikan mereka mendapat hukuman yang sepadan.", "althea_side/6")
	yield (dialog, "dialog_ended")
	
	dialog.display("Arin", "Terima kasih, Althea. Aku akan selalu mengenang jasamu.", "arin_side/6")
	yield (dialog, "dialog_ended")
	
	dialog.display("Althea", "Tak usah dipikirkan. Berbahagialah disana bersama orangtuamu.", "althea_side/7")
	yield (dialog, "dialog_ended")
	
	dialog.display("Arin", "Semoga kita bisa bertemu lagi ya, entah kapan.", "arin_side/7")
	yield (dialog, "dialog_ended")
	
	transition.play("transition")
	yield (transition, "animation_finished")
	
	npc.get("arin_grave").disable()
	
	yield (get_tree().create_timer(1), "timeout")
	transition.play_backwards("transition")
	yield (transition, "animation_finished")
	
	dialog.display("Arin", "Pasti, entah kapan.")
	yield (dialog, "dialog_ended")
	
	camera.set_camera_follow(true)
	player.is_in_cutscene = false
	mission.show()

func _on_magician_talked_to_npc(x):
	mission.hide()

	if (magician_state == "idle"):
		dialog.display("Penyihir", "Hey ... kemari.")
		yield (dialog, "dialog_ended")

		dialog.display("Penyihir", "Aku sedang membuat sebuah ramuan ajaib. Kau penasaran?")
		yield (dialog, "dialog_ended")

		dialog.display_choices(["Ramuan apa?", "Nggak."])
		var result = yield (dialog, "dialog_ended")

		if (result == 0):
			dialog.display("Penyihir", "Ramuan transformasi ...")
			yield (dialog, "dialog_ended")

			dialog.display("Penyihir", "Menjadi cewek!")
			yield (dialog, "dialog_ended")

			dialog.display("Penyihir", "Kau tertarik?")
			yield (dialog, "dialog_ended")

			dialog.display_choices(["(Sepertinya dia gila ...)", "Gaskeun masseh."])
			result = yield (dialog, "dialog_ended")

			if (result == 0):
				dialog.display("Penyihir", "Banyak orang yang bilang begitu, sih.")
				yield (dialog, "dialog_ended")

			else :
				dialog.display("Penyihir", "Sudah kuduga!")
				yield (dialog, "dialog_ended")

				dialog.display("Penyihir", "Tapi ... untuk membuat ramuan itu aku memerlukan beberapa bahan.")
				yield (dialog, "dialog_ended")

				dialog.display("Penyihir", "Aku butuh botol ramuan hijau, air mandi putri duyung dan sebuah ketel. Seharusnya kau bisa menemukan barang-barang itu di gudang kota di atas alun-alun.")
				yield (dialog, "dialog_ended")

				dialog.display("Penyihir", "Temui aku ketika kau sudah mendapatkan barang-barang itu ya!.")
				yield (dialog, "dialog_ended")

				mission.add_mission("find_materials", "Carikan bahan-bahan untuk ramuan penyihir (0/3)")

				magician_state = "waiting"

		else :
			dialog.display("Penyihir", "Baiklah. Temui aku lagi jika kau berubah pikiran.")
			yield (dialog, "dialog_ended")

	elif (magician_state == "waiting"):
		if (collected_items.size() == 3):
			mission.remove_mission("find_materials")
			dialog.display("Penyihir", "Sempurna! Biarkan aku menyiapkan ini sebentar.")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penyihir", "Silahkan diminum!")
			yield (dialog, "dialog_ended")

			transition.play("transition")
			yield (transition, "animation_finished")

			player.is_in_cutscene = true
			player.move(Vector2(1150, - 1672))
			player.align(Vector2(0, - 1))
			player.get_node("sprite").texture = player_as_girl

			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")

			dialog.display("Althea", "Aku beneran jadi cewek?")
			yield (dialog, "dialog_ended")

			dialog.display("Penyihir", "Iya ...")
			yield (dialog, "dialog_ended")

			dialog.display("Penyihir", "Wangy wangy wangy wangy wangy wangy ...")
			yield (dialog, "dialog_ended")
		
			dialog.display("Penyihir", "Sini sama om ... Heheheha ...")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "(O-orang ini berbahaya!)")
			yield (dialog, "dialog_ended")
			
			npc.get("guard").enable()
			npc.get("guard").move(Vector2(1518, - 1710))
			npc.get("guard").move_along_path([Vector2(76, - 106)])
			yield (npc.get("guard"), "npc_arrived")
			
			dialog.display("Penjaga", "Kau berulah lagi ya. Dasar penyihir mesum!")
			yield (dialog, "dialog_ended")
			
			dialog.display("Penjaga", "Kali ini aku akan benar-benar menangkapmu!")
			yield (dialog, "dialog_ended")
			
			transition.play("transition")
			yield (transition, "animation_finished")

			get_node("/root/game/sort/side_npc/magician").hide()
			npc.get("guard").move(Vector2(1151, - 1692))
			npc.get("guard").align(Vector2(0, 0))

			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
			
			dialog.display("Penjaga", "Aku sudah membereskan dia. Harusnya efek ramuannya hilang setelah beberapa saat, sih.")
			yield (dialog, "dialog_ended")
			
			dialog.display("Althea", "Ah baik, terima kasih.")
			yield (dialog, "dialog_ended")
			
			transition.play("transition")
			yield (transition, "animation_finished")

			npc.get("guard").disable()
			
			yield (get_tree().create_timer(1), "timeout")
			transition.play_backwards("transition")
			yield (transition, "animation_finished")
		else :
			dialog.display("Penyihir", "Bagaimana? Kau menemukan barang-barang itu?")
			yield (dialog, "dialog_ended")

	mission.show()

func _on_bottle_talked_to_npc(x):
	if (magician_state == "idle"):
		dialog.display("Althea", "Hmm, sepertinya ini bukan waktu yang tepat bagiku untuk mengambil benda ini ...")
		yield (dialog, "dialog_ended")
	else :
		dialog.display("Althea", "Pasti ini ramuan hijaunya!")
		yield (dialog, "dialog_ended")
		
		get_node("/root/game/sort/objects/bottle").queue_free()
		collected_items.append("bottle")
		mission.update_mission("find_materials", "Carikan bahan-bahan untuk ramuan penyihir (" + str(collected_items.size()) + "/3)")

func _on_cattle_talked_to_npc(x):
	if (magician_state == "idle"):
		dialog.display("Althea", "Hmm, sepertinya ini bukan waktu yang tepat bagiku untuk mengambil benda ini ...")
		yield (dialog, "dialog_ended")
	else :
		dialog.display("Althea", "Ketelnya ketemu.")
		yield (dialog, "dialog_ended")
		
		get_node("/root/game/sort/objects/cattle").queue_free()
		collected_items.append("cattle")
		mission.update_mission("find_materials", "Carikan bahan-bahan untuk ramuan penyihir (" + str(collected_items.size()) + "/3)")
	
func _on_bucket_talked_to_npc(x):
	if (magician_state == "idle"):
		dialog.display("Althea", "Hmm, sepertinya ini bukan waktu yang tepat bagiku untuk mengambil benda ini ...")
		yield (dialog, "dialog_ended")
	else :
		dialog.display("Althea", "Hmm, harusnya ini adalah air mandi putri duyung.")
		yield (dialog, "dialog_ended")
		
		get_node("/root/game/sort/objects/bucket").queue_free()
		collected_items.append("bucket")
		mission.update_mission("find_materials", "Carikan bahan-bahan untuk ramuan penyihir (" + str(collected_items.size()) + "/3)")
