extends Node2D

onready var properties = get_node("/root/game/properties")
onready var tileset = properties.tile_set

var property_instance = load("res://property.tscn")
var tree_shader = load("res://tilemaps/tree.tres")


var id = ["tent_1", "tent_2", "self_1", "self_2", "self_3", "fence", "tree", "tree_half_left", "tree_half_right", "bush", "stone_1", "stone_2", "rock_1", "rock_2", "log_dump", "anvil", "stand_1", "stand_2", "grave", "well"]


func _ready():
	var used = properties.get_used_cells()
	
	for cell in used:
		var cell_id = properties.get_cellv(cell)
		if (tileset.tile_get_name(cell_id) in id):
			var cell_size = tileset.tile_get_region(cell_id).size
			var property = property_instance.instance()
			property.get_node("tilemap").tile_set = tileset
			property.get_node("tilemap").set_cellv(Vector2(0, 0), cell_id)
			var coll = CollisionShape2D.new()
			coll.shape = RectangleShape2D.new()
			coll.shape.extents = Vector2(cell_size.x / 2 + 4, cell_size.y / 2 + 4)
			coll.position = Vector2((cell_size.x / 4) + 4, (cell_size.y / 4) + 4)
			property.get_node("area").add_child(coll)
			if (cell_size.y != 48):
				property.size = cell_size.y
			add_child(property)
			property.global_position = properties.map_to_world(cell) + Vector2(16, 16)
			


























































