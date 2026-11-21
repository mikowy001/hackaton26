extends Node;

const filePath = "user://save.dat";# przy zmanie zobacz zmień też res://scripts/core/saving.gd

func load() -> String:
	var file = FileAccess.open(filePath, FileAccess.READ);
	var data: String = file.get_as_text();
	print_debug("Loaded the save, got ", data, " points");
	
	return data;

func _on_label_2_ready() -> void:
	if  FileAccess.open(filePath, FileAccess.READ) == null:
		get_parent().text = "Czas: 0:00";
	else:
		var temp = load(filePath);
		temp = "0"+temp;
		var czas = temp.to_int();
		get_parent().text = "Czas: " + (czas - czas%60)/60 + ":" + czas%60;
	
