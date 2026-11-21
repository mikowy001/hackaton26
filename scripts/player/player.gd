extends CharacterBody2D

@export var speed: float = 166.0

@export var orbit_radius: float = 19.0
@export var orbit_speed: float = 2.0  
@export var fish_facing_offset: float = PI  

@export var boost_speed: float = 400.0
@export var boost_decay: float = 6.0  
@export var boost_cooldown: float = 0.25
@export var min_dash_dopamine: float = 25.0 
@export var dash_dopamine_cost: float = 2.0

@export var hotspot_path: NodePath = ^"../Hotspot"

@onready var Sound_Dash = $DashAudioPlayer
@onready var animated_sprite = $AnimatedSprite2D
@onready var ryba = $ryba
@onready var hotspot = get_node_or_null(hotspot_path)
@onready var dopamine_bar = get_node_or_null("Camera2D/TextureRect/DopamineBar")

var last_direction = "walkDown"
var orbit_angle: float = -3 * PI  
var boost_velocity := Vector2.ZERO
var boost_requested := false
var boost_cooldown_left: float = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("spacja"):
		boost_requested = true

func _process(delta: float) -> void:
	orbit_angle += orbit_speed * delta
	ryba.position = Vector2.RIGHT.rotated(orbit_angle) * orbit_radius - ryba.size * 0.5
	ryba.pivot_offset = ryba.size * 0.5
	ryba.rotation = orbit_angle + fish_facing_offset

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = direction * speed

	boost_cooldown_left = maxf(boost_cooldown_left - delta, 0.0)
	if boost_requested:
		boost_requested = false
		var inside_hotspot: bool = hotspot != null and bool(hotspot.isThisPlayerInside)
		var has_enough_dopamine: bool = dopamine_bar != null and float(dopamine_bar.get_dopamine()) >= min_dash_dopamine
		if boost_cooldown_left <= 0.0 and not inside_hotspot and has_enough_dopamine:
			
			boost_velocity = Vector2.RIGHT.rotated(orbit_angle) * boost_speed
			boost_cooldown_left = boost_cooldown
			Sound_Dash.play()
			dopamine_bar.drain_dopamine(dash_dopamine_cost)

	velocity += boost_velocity

	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				last_direction = "walkRight"
			else:
				last_direction = "walkLeft"
		else:
			if direction.y > 0:
				last_direction = "walkDown"
			else:
				last_direction = "walkUp"

		animated_sprite.play(last_direction)
	else:
		animated_sprite.stop()
		
		

	move_and_slide()
	boost_velocity *= exp(-boost_decay * delta)

func get_player_pos():
	return position;
