extends Control

@onready var vat: TextureRect = $TextureRect;

@export_dir var dir: String = "res://assets/popups";
const FALLBACK_DIR: String = "res://assets";

func get_random_texture(directory: String, extension: String):
	var directory_access = DirAccess.open(directory);
	
	if(directory_access == null): return null;
	
	var files = [];
	directory_access.list_dir_begin();
	
	var file = directory_access.get_next();
	while(file != ""):
		if(!directory_access.current_is_dir() && file.get_extension() == extension):
			files.append(file);
			
		file = directory_access.get_next();
		
	directory_access.list_dir_end();
	
	if(files.is_empty()): return null;

	return directory.path_join(files.pick_random())

func _ready() -> void:
	var pather = get_random_texture(dir, "png");
	if(!pather):
		pather = get_random_texture(FALLBACK_DIR, "png");
	if(!pather): return;
	
	var texture = load(pather);
	if(texture == null): return;
	vat.texture = texture;
	
	var popup_size = size;
	var viewport_size = get_viewport_rect().size;
	
	position.x = randf_range(0.0, maxf(0.0, viewport_size.x - popup_size.x));
	position.y = randf_range(0.0, maxf(0.0, viewport_size.y - popup_size.y));
