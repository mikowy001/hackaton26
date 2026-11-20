extends Node

const filePath = "user://save.dat";

func save(seconds: int):
	var file = FileAccess.open(filePath, FileAccess.WRITE);
	file.store_string(str(seconds));
	print_debug("Saved the save's points to: ", seconds);

func load():
	var file = FileAccess.open(filePath, FileAccess.READ);
	var data = file.get_as_text();
	print_debug("Loaded the save, got ", data, " points");
	
	return data;
