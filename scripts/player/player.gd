extends CharacterBody2D

@export var speed: float = 166.0

@onready var animated_sprite = $AnimatedSprite2D

var last_direction = "walkDown"

func _physics_process(_delta):
	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	
	velocity = direction * speed
	
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

func get_player_pos():
	return position;
