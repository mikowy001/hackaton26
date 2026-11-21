extends CanvasModulate

@onready var bar: Node = $"../Camera2D/DopamineBar"

const MIN_BRIGHTNESS := 0.08   # "near 0" instead of pitch black
const MAX_DOPAMINE := 100.0    # matches the bar's default max

func _process(_delta: float) -> void:
	var ratio := clampf(bar.get_dopamine() / MAX_DOPAMINE, 0.0, 1.0)
	var brightness := MIN_BRIGHTNESS + (1.0 - MIN_BRIGHTNESS) * ratio
	color = Color(brightness, brightness, brightness)
