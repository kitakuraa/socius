extends Resource
class_name DialogueResource


const DialogueConstants: = preload("res://addons/dialogue_manager/constants.gd")


export (int) var resource_version
export (int) var syntax_version
export (String) var raw_text
export (Array, Dictionary) var errors
export (Dictionary) var titles
export (Dictionary) var lines


func _init():
	resource_version = 1
	syntax_version = DialogueConstants.SYNTAX_VERSION
	raw_text = "~ this_is_a_node_title\n\nNathan: This is some dialogue.\nNathan: Here are some choices.\n- First one\n	Nathan: You picked the first one.\n- Second one\n	Nathan: You picked the second one.\n- Start again => this_is_a_node_title\n- End the conversation => END\nNathan: For more information about conditional dialogue, mutations, and all the fun stuff, see the online documentation."
	errors = []
	titles = {}
	lines = {}


func get_next_dialogue_line(title:String, extra_game_states:Array = [])->Dictionary:
	
	var tree:SceneTree = Engine.get_main_loop()
	if tree:
		var dialogue_manager = tree.current_scene.get_node_or_null("/root/DialogueManager")
		if dialogue_manager != null:
			return yield (dialogue_manager.get_next_dialogue_line(title, self, extra_game_states), "completed")

	assert (false, "The \"DialogueManager\" autoload does not appear to be loaded.")
	return {}
