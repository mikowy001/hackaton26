extends Node

const filePath = "user://save.dat"; # przy zmianie zmień też res://scenes/Wyświetlacz_Czasu.gd

func save_data(seconds: int):
	var file = FileAccess.open(filePath, FileAccess.WRITE);
	file.store_string(str(seconds));
	print_debug("Saved the save's points to: ", seconds);

func load_data():
	if(!FileAccess.file_exists(filePath)): save_data(0);
	
	var file = FileAccess.open(filePath, FileAccess.READ);
	var data = file.get_as_text();
	print_debug("Loaded the save, got ", data, " points");
	
	if data.is_empty(): return 0;
	
	return data;
