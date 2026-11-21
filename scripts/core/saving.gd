extends Node


const filePath = "user://save.dat"; # przy zmianie zmień też res://scenes/Wyświetlacz_Czasu.gd

func save(seconds: int):
	var file = FileAccess.open(filePath, FileAccess.WRITE);
	file.store_string(str(seconds));
	print_debug("Saved the save's points to: ", seconds);

#func load():
#	if !FileAccess.file_exists(filePath):
#		return "0";
#	
#	var file = FileAccess.open(filePath, FileAccess.READ);
#	var data = file.get_as_text();
#	print_debug("Loaded the save, got ", data, " points");
#	
#	return data;

#pacz res://scenes/Wyświetlacz_Czasu.gd
