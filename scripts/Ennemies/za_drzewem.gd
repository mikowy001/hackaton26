extends Sprite2D

@onready var dopamine = get_node_or_null("../Player/Camera2D/TextureRect/DopamineBar");
@onready var plpos = get_node_or_null("../Player");

@export var scene_to_instantiate: PackedScene;
var rng = RandomNumberGenerator.new();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var kat = rng.randf_range(0, 6.28);
	position = plpos.position + Vector2(500, 0).rotated(kat);
	
	if dopamine.get_dopamine() > 50:
		texture.resource_path = "res://Huberto's Assets/deep_elf_high_priest.png"; #place holder za triple t
	else:
		texture.resource_path = "res://Huberto's Assets/deep_elf_high_priest.png"; #place holder za kultyste
	await get_tree().create_timer(10.0).timeout;
	queue_free();
