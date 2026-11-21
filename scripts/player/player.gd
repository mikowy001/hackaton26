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

# Anti-softlock: if the player keeps pushing but barely moves, probe nearby
# directions and give them a short nudge toward the most open one.
@export var unstuck_delay: float = 0.35
@export var unstuck_probe_distance: float = 64.0

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

var stuck_time: float = 0.0
var last_input_dir := Vector2.ZERO

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
		
		if boost_cooldown_left <= 0.0 and not inside_hotspot:
			
			boost_velocity = Vector2.RIGHT.rotated(orbit_angle) * boost_speed
			boost_cooldown_left = boost_cooldown
			Sound_Dash.play()

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

	var pos_before := global_position
	move_and_slide()
	boost_velocity *= exp(-boost_decay * delta)

	_update_stuck(delta, direction, pos_before)

func _update_stuck(delta: float, direction: Vector2, pos_before: Vector2) -> void:
	if direction == Vector2.ZERO:
		stuck_time = 0.0
		return

	last_input_dir = direction
	var moved := global_position.distance_to(pos_before)
	var expected := direction.length() * speed * delta

	if moved < maxf(expected * 0.2, 0.5):
		stuck_time += delta
	else:
		stuck_time = 0.0

	if stuck_time >= unstuck_delay:
		_nudge_unstuck()
		stuck_time = 0.0

func _nudge_unstuck() -> void:
	var space := get_world_2d().direct_space_state
	var preferred := last_input_dir.normalized()
	var candidates: Array[Vector2] = [
		Vector2.RIGHT,
		Vector2.LEFT,
		Vector2.DOWN,
		Vector2.UP,
		Vector2(1, 1).normalized(),
		Vector2(1, -1).normalized(),
		Vector2(-1, 1).normalized(),
		Vector2(-1, -1).normalized()
	]

	var best_dir := preferred if preferred != Vector2.ZERO else Vector2.UP
	var best_score := -1000000.0

	for dir in candidates:
		var query := PhysicsRayQueryParameters2D.create(
			global_position,
			global_position + dir * unstuck_probe_distance,
			collision_mask,
			[get_rid()]
		)

		var hit := space.intersect_ray(query)
		var free_dist := unstuck_probe_distance
		if not hit.is_empty():
			free_dist = global_position.distance_to(hit.position)

		# Prefer open space, then directions close to where the player wants to go.
		var score: float = free_dist + dir.dot(preferred) * 12.0
		if score > best_score:
			best_score = score
			best_dir = dir

	boost_velocity = best_dir * boost_speed * 0.8

func get_player_pos():
	return position;
