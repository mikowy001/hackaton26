extends Node

@onready var theBar = $TextureProgressBar

var dopamine = 100.0;
var paused = false;
var drain_rate = 1.0;

func get_dopamine():
	return dopamine;

func set_dopamine(value: float):
	theBar.set_value(value);
	dopamine = value;

func get_drain_rate():
	return drain_rate;

func set_drain_rate(value: float):
	drain_rate = value;

func drain_dopamine(value: float):
	set_dopamine(dopamine - value);

func isPaused():
	return paused;

func pause():
	paused = true;

func resume():
	paused = false;

func _ready() -> void:
	theBar.set_value(100.0);

func _process(delta: float) -> void:
	if(!paused): drain_dopamine(drain_rate * delta);
	# TODO: Wysyłanie do death screena jak będzie
