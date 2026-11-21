extends Button

func _on_pressed() -> void:
	Globals.current_score = 0;
	get_tree().change_scene_to_file("res://world.tscn")
