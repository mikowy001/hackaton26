extends Node

@onready var theBar = $TextureProgressBarl;

var dopamine = 100.0;
var pause = false;
var drain_rate = 100;

func set_dopamine(value: float):
	theBar.set_value(dopamine);

func drain_dopamine(value: float):
	set_dopamine(dopamine - value);

func pause_dopamine():
	pause = true;

func resume_dopamine():
	pause = false;

func _ready() -> void:
	theBar.set_value(100);

func _process(delta: float) -> void:
	if(pause): drain_dopamine(drain_rate * delta);
