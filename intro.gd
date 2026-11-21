extends Node2D

@onready var a = $"1"
@onready var b = $"2"
@onready var c = $"3"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	a.visible = true
	b.visible = false
	c.visible = false
	await get_tree().create_timer(2).timeout
	b.visible = true
	await get_tree().create_timer(2).timeout
	c.visible = true
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/Main_Menu.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
