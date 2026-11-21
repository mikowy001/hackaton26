extends Node

@onready var theBar = $TextureProgressBar



var czasmiędzyzadrzewem= 0;
@export var dopamine = 100.0;
var zadrzewem = load("res://scenes/Ennemies/ZaDrzewem.tscn");

var paused = false;
var drain_rate = 2;



func get_dopamine():
	return dopamine;

func set_dopamine(value: float):
	if(value > theBar.get_max()): theBar.set_value(theBar.get_max()); return;
	elif(value < theBar.get_min()): theBar.set_value(theBar.get_min()); return;
	theBar.set_value(value);
	dopamine = value;

func get_drain_rate():
	return drain_rate;

func set_drain_rate(value: float):
	drain_rate = value;

func drain_dopamine(value: float):
	set_dopamine(dopamine - value);

func add_dopamine(value: float):
	set_dopamine(dopamine + value);

func isPaused():
	return paused;

func pause():
	paused = true;

func resume():
	paused = false;

func _ready() -> void:
	theBar.set_value(theBar.get_max());

func _process(delta: float) -> void:
	if(!paused): drain_dopamine(drain_rate * delta);
	
	if czasmiędzyzadrzewem > 3:
		var zd = zadrzewem.instantiate();
		get_tree().current_scene.add_child(zd);
		czasmiędzyzadrzewem = 0;
	else:
		czasmiędzyzadrzewem += delta;
	
	
	# TODO: Wysyłanie do death screena jak będzie
