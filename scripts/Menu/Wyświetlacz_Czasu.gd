extends Node;

const Saving = preload("res://scripts/core/saving.gd")

@onready var saving = Saving.new()

func _on_label_2_ready() -> void:
		var czas = saving.load_data()
		var czasint = int(str(czas));
		get_parent().text = "Time: %d:%02d" % [czasint / 60, czasint % 60];
