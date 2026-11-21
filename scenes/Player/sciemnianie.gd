extends CanvasModulate

@onready var bar = $"../Camera2D/DopamineBar"
@onready var canva = $"../CanvasModulate"

const MAX_DOPAMINE := 100.0
const MIN_BRIGHTNESS := 0.08


func _process(_delta: float) -> void:
	var ratio := clampf(bar.get_dopamine() / MAX_DOPAMINE, 0.0, 1.0)

	var brightness := MIN_BRIGHTNESS + (1.0 - MIN_BRIGHTNESS) * ratio
	color = Color(brightness, brightness, brightness)
	canva.color = color
