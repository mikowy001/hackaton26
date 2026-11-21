extends Area2D

@export var dopamine_bar_path: NodePath = ^"../DopamineBar"
@onready var dopamineBar: Node = get_node_or_null(dopamine_bar_path);

var cirColor = Color(0.0, 0.565, 0.694, 0.5);
var intensity = 1.0;

var reallness = 0.1;

var isThisPlayerInside = false;

func reroll():
	intensity = 1.0;

func _on_body_entered(body: Node2D):
	if(body.name == "Player"):
		isThisPlayerInside = true;
		print_debug("Player entered this very very interesting spot");

func _on_body_exited(body: Node2D):
	if(body.name == "Player"):
		isThisPlayerInside = false;
		print_debug("Player exited this very very interesting spot :(");

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if(isThisPlayerInside):
		intensity -= delta * reallness;
		queue_redraw();
		if(Input.is_action_just_pressed("spacja", true) && dopamineBar != null):
			dopamineBar.add_dopamine(3);

func _draw() -> void:
	# Color(cirColor, cirColor.a * intensity) jest kurka rurka wow, co to jest godot :0
	draw_circle(Vector2.ZERO, 10.0, Color(cirColor, cirColor.a * intensity));
