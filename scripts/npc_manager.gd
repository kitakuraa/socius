extends Node2D

var npcs = {}

func _ready():
	
	register("advisor", ["global_position", "current_path", "disabled"])
	register("villager", ["global_position", "current_path", "disabled"])
	register("villager2", ["global_position", "current_path", "disabled"])
	register("villager3", ["global_position", "current_path", "disabled"])
	register("villager4", ["global_position", "current_path", "disabled"])
	register("villager5", ["global_position", "current_path", "disabled"])
	register("villager6", ["global_position", "current_path", "disabled"])
	register("villager7", ["global_position", "current_path", "disabled"])
	register("villager8", ["global_position", "current_path", "disabled"])
	register("villager9", ["global_position", "current_path", "disabled"])
	register("villager10", ["global_position", "current_path", "disabled"])
	register("ork", ["global_position", "current_path", "disabled"])
	register("mayor", ["global_position", "current_path", "disabled"])
	register("guard_captain", ["global_position", "current_path", "disabled"])
	register("captain", ["global_position", "current_path", "disabled"])
	register("guard", ["global_position", "current_path", "disabled"])
	register("hoglin", ["global_position", "current_path", "disabled"])
	register("ork_contractor", ["global_position", "current_path", "disabled"])
	register("bartender", ["global_position", "current_path", "disabled"])
	register("minotaur", ["global_position", "current_path", "disabled"])
	register("arin", ["global_position", "current_path", "disabled"])
	register("reo", ["global_position", "current_path", "disabled"])

func get(name):
	return get_node(name.to_lower())

func register(name, props):
	npcs[name] = {"properties_to_save":props}
