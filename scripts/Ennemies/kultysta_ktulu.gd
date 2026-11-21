extends AnimatedSprite2D

@onready var dopamine = get_node_or_null("../Player/Camera2D/TextureRect/DopamineBar");
@onready var player = get_node_or_null("../Player");

@export var scene_to_instantiate: PackedScene;
var rng = RandomNumberGenerator.new();
const speed = 100;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var kat = rng.randf_range(0, 6.28);
	position = player.position + Vector2(500, 0).rotated(kat);
	await get_tree().create_timer(30.0).timeout;
	queue_free();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= ((position.x - player.get_player_pos().x)/abs(position.x - player.get_player_pos().x))*speed*delta;
	position.y -= ((position.y - player.get_player_pos().y)/abs(position.y - player.get_player_pos().y))*speed*delta;
	print_debug("test życia ktulu");
	print_debug(position);
	print_debug(player.get_player_pos());


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		dopamine.dopamine -= 10;
		queue_free();
