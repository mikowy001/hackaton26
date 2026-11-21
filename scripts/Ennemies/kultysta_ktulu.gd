extends AnimatedSprite2D

@onready var player = get_node_or_null("../Player");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function bodys.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = position.x - player.get_player_pos().x * delta;
	position.y = position.y - player.get_player_pos().y * delta;
