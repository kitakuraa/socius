extends RichTextLabel


signal spoke(letter, speed)
signal paused(duration)
signal finished()


export  var skip_action:String = "ui_cancel"
export  var seconds_per_step:float = 0.02


var dialogue_line:Dictionary

var index:int = 0
var percent_per_index:float = 0
var last_wait_index:int = - 1
var last_mutation_index:int = - 1
var waiting_seconds:float = 0
var is_typing:bool = false
var has_finished:bool = false


func _ready()->void :
	bbcode_text = ""


func _process(delta:float)->void :
	if is_typing:
		
		if percent_visible < 1:
			
			if Input.is_action_just_pressed(skip_action):
				percent_visible = 1
				
				for i in range(index, get_total_character_count()):
					mutate_inline_mutations(i)
				has_finished = true
				emit_signal("finished")
				return 
			
			
			if waiting_seconds > 0:
				waiting_seconds = waiting_seconds - delta
			
			
			if waiting_seconds <= 0:
				type_next(delta, waiting_seconds)
		else :
			is_typing = false
			if has_finished == false:
				has_finished = true
				emit_signal("finished")


func reset_height()->void :
	
	if dialogue_line.text == "":
		fit_content_height = false
		rect_min_size = Vector2(rect_size.x, 0)
		rect_size = Vector2.ZERO
		yield (get_tree(), "idle_frame")
		return 
	
	fit_content_height = true
	
	
	
	var size_check_label = duplicate(0)
	size_check_label.modulate.a = 0
	get_tree().current_scene.add_child(size_check_label)
	size_check_label.rect_size.x = rect_size.x
	size_check_label.bbcode_text = dialogue_line.text
	
	
	yield (get_tree(), "idle_frame")
	
	
	rect_min_size = Vector2(rect_size.x, size_check_label.get_content_height())
	rect_size = Vector2.ZERO
	
	
	size_check_label.queue_free()
	


func type_next(delta:float, seconds_needed:float)->void :
	if last_mutation_index != index:
		last_mutation_index = index
		mutate_inline_mutations(index)
	
	if last_wait_index != index and get_pause(index) > 0:
		last_wait_index = index
		waiting_seconds += get_pause(index)
		emit_signal("paused", get_pause(index))
	else :
		percent_visible += percent_per_index
		index += 1
		seconds_needed += seconds_per_step * (1.0 / get_speed(index))
		if seconds_needed > delta:
			waiting_seconds += seconds_needed
			if index < text.length():
				emit_signal("spoke", text[index - 1], get_speed(index))
		else :
			type_next(delta, seconds_needed)


func type_out()->void :
	bbcode_text = dialogue_line.text
	percent_visible = 0
	index = 0
	has_finished = false
	waiting_seconds = 0
	
	
	yield (get_tree(), "idle_frame")
	if not get_total_character_count():
		emit_signal("finished")
		queue_free()
		return 
	
	if seconds_per_step == 0:
		is_typing = false
		percent_visible = 1
		
		for i in range(index, get_total_character_count()):
			mutate_inline_mutations(i)
		emit_signal("finished")
	else :
		percent_per_index = 100.0 / float(get_total_character_count()) / 100.0
		is_typing = true



func get_pause(at_index:int)->float:
	return dialogue_line.pauses.get(at_index, 0)



func get_speed(at_index:int)->float:
	var speed:float = 1
	for data in dialogue_line.speeds:
		if data[0] > at_index:
			return speed
		speed = data[1]
	return speed



func mutate_inline_mutations(index:int)->void :
	for inline_mutation in dialogue_line.inline_mutations:
		
		if inline_mutation[0] > index:
			return 
		if inline_mutation[0] == index:
			
			get_node("/root/DialogueManager").mutate(inline_mutation[1], dialogue_line.extra_game_states)
