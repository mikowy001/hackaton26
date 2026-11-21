extends Node2D

@onready var grass_layer: TileMapLayer = $Ground
@onready var tree_layer: TileMapLayer = $Ground/Trees


@export var noise_scale: float = 1.25
@export var seed_value: int = 2137

var DEBUG = true

var noise := FastNoiseLite.new()
#zero dopaminy: 0
#normalnie 1.5
#duzo to 10

func _ready():
	generate_map()

func debug(info: String):
	if(DEBUG):
		print(info)

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		noise_scale += 0.1
		print(noise_scale)
		generate_map()

	if Input.is_action_pressed("ui_down"):
		noise_scale -= 0.1
		print(noise_scale)
		generate_map()


func generate_map():
	noise.seed = seed_value
	noise.frequency = noise_scale
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX

	grass_layer.clear()
	tree_layer.clear()

	for x in range(Globals.map_width):
		for y in range(Globals.map_height):
			
			var random_for_tree = randi_range(0, 5)
			if (random_for_tree == 0 ):
				tree_layer.set_cell(
					Vector2i(x, y), 
					0, 
					Vector2i(randi_range(0, 2), 2)
				)
			elif (random_for_tree == 1):
				var arrayX = [8, 10, 12, 14, 0, 2, 4, 6, 0, 4, 8, 12]
				var arrayY = [0, 0, 0, 0, 2, 2, 2, 2, 5, 5, 5, 5]
				var ranarr = randi_range(0, 11)
				tree_layer.set_cell(
					Vector2i(x, y),
					1,
					Vector2i(arrayX[ranarr], arrayY[ranarr])
				)
				
		
			var noise_value = noise.get_noise_2d(x, y) * noise_scale
		
			var sprite_index = int(remap(
				noise_value, -1.0, 1.0, 1.0, 8.0
			))
		
			sprite_index = clampi(sprite_index, 1, 8)
		
			var atlas_coords = Vector2i(sprite_index, 0)
		
			grass_layer.set_cell(
				Vector2i(x, y),
				0,
				atlas_coords
			)
