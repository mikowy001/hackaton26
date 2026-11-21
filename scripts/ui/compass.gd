extends Control;

@onready var ziemia: TextureRect = $ZIME;
@onready var satelita: TextureRect = $ZIME/Elita;

@export var player_path: NodePath = ^"/root/World/Player";
@onready var player: Node2D = get_node_or_null(player_path) as Node2D;

@export var hotspot_path: NodePath = ^"/root/World/Hotspot";
@onready var hotspot: Node2D = get_node_or_null(hotspot_path) as Node2D;

@export var orbit_spacing: float = 10.0;

func _process(_delta: float) -> void:
	if(!player || !hotspot): return;
	
	var direction := hotspot.global_position - player.global_position;
	if(direction.length_squared() < 0.0001): return;
	direction = direction.normalized();
	
	var center := ziemia.size * 0.5;
	var radius := maxf(ziemia.size.x, ziemia.size.y) * 0.5 + orbit_spacing + maxf(satelita.size.x, satelita.size.y) * 0.5;
	satelita.position = center + direction * radius - satelita.size * 0.5;
