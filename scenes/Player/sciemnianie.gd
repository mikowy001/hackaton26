extends CanvasModulate

const MIN_BRIGHTNESS := 0.2   # "near 0" instead of pitch black
const MAX_DOPAMINE := 100.0    # matches the bar's default max
const MIN_VOLUME := 0.0001     # ~ -80 dB, avoids linear_to_db(0)

@export var fade_speed: float = 1.5  # how quickly the two tracks chase the target mix

@onready var bar = get_node_or_null("../Camera2D/TextureRect/DopamineBar")
@onready var high_music = get_node_or_null("../HighDopamineMusic")
@onready var low_music = get_node_or_null("../LowDopamineMusic")

var high_volume: float = 0.0
var low_volume: float = 0.0

func _ready() -> void:
	if high_music != null:
		high_music.volume_db = linear_to_db(MIN_VOLUME)
		high_music.play()
	if low_music != null:
		low_music.volume_db = linear_to_db(MIN_VOLUME)
		low_music.play()

func _process(delta: float) -> void:
	if bar == null:
		return

	var ratio := clampf(float(bar.get_dopamine()) / MAX_DOPAMINE, 0.0, 1.0)
	var brightness := MIN_BRIGHTNESS + (1.0 - MIN_BRIGHTNESS) * ratio
	color = Color(brightness, brightness, brightness)

	# High track dominates when dopamine is full, low track when it is empty.
	var high_target := ratio
	var low_target := 1.0 - ratio
	var t := 1.0 - exp(-fade_speed * delta)
	high_volume = lerpf(high_volume, high_target, t)
	low_volume = lerpf(low_volume, low_target, t)

	if high_music != null:
		high_music.volume_db = linear_to_db(maxf(high_volume, MIN_VOLUME))
	if low_music != null:
		low_music.volume_db = linear_to_db(maxf(low_volume, MIN_VOLUME))
