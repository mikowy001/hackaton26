extends Area2D

@export var dopamine_bar_path: NodePath = ^"../DopamineBar"
@onready var dopamineBar: Node = get_node_or_null(dopamine_bar_path);

var popups_scene = preload("res://scenes/ui/popup.tscn");
var popups = [];
var popup_layer: CanvasLayer = null;

var cirColor = Color(0.0, 0.565, 0.694, 0.5);
var intensity = 1.0;

var reallness = 0.2;

@export var isThisPlayerInside = false;

func _clear_popups() -> void:
	for popup in popups:
		if(is_instance_valid(popup)):
			popup.queue_free();
	popups.clear();

func _on_body_entered(body: Node2D):
	if(body.name == "Player"):
		isThisPlayerInside = true;
		print_debug("Player entered this very very interesting spot");

func _on_body_exited(body: Node2D):
	if(body.name == "Player"):
		isThisPlayerInside = false;
		print_debug("Player exited this very very interesting spot :(");
		
		_clear_popups();

func _ready() -> void:
	popup_layer = CanvasLayer.new();
	popup_layer.layer = 10;
	add_child(popup_layer);
	position.x = (Globals.map_width * Globals.tile_size) * randf();
	position.y = (Globals.map_height * Globals.tile_size) * randf();
	print_debug("Starting hot pos is ", position.x, " ", position.y);

func _process(delta: float) -> void:
	if(isThisPlayerInside):
		intensity -= delta * reallness;
		queue_redraw();
		if(Input.is_action_just_pressed("spacja") && dopamineBar != null):
			dopamineBar.add_dopamine(1);
			var popup = popups_scene.instantiate();
			popup_layer.add_child(popup);
			popups.append(popup);
	
	if(intensity <= 0):
		intensity = 1.0;
		isThisPlayerInside = false;
		_clear_popups();
		position.x = (Globals.map_width * Globals.tile_size) * randf();
		position.y = (Globals.map_height * Globals.tile_size) * randf();
		print_debug("New hot pos is ", position.x, " ", position.y);

func _draw() -> void:
	# Color(cirColor, cirColor.a * intensity) jest kurka rurka wow, co to jest godot :0
	draw_circle(Vector2.ZERO, 10.0, Color(cirColor, cirColor.a * intensity));
