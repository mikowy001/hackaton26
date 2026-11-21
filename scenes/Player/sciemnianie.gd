extends CanvasModulate

const MIN_BRIGHTNESS := 0.08   # "near 0" instead of pitch black
const MAX_DOPAMINE := 100.0    # matches the bar's default max

@onready var bar = get_node_or_null("../Camera2D/TextureRect/DopamineBar")
@onready var mono_overlay = get_node_or_null("../MonoOverlay")

func _process(_delta: float) -> void:
	if bar == null:
		return

	var ratio := clampf(float(bar.get_dopamine()) / MAX_DOPAMINE, 0.0, 1.0)
	var brightness := MIN_BRIGHTNESS + (1.0 - MIN_BRIGHTNESS) * ratio

	# CanvasModulate stays white; the overlay shader handles both effects,
	# so the darkening is not applied twice.
	if mono_overlay != null and mono_overlay.material != null:
		mono_overlay.material.set_shader_parameter("brightness", brightness)
		mono_overlay.material.set_shader_parameter("mono", 1.0 - ratio)
