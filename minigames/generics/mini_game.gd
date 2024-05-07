extends Control

class_name MiniGame

enum {AMOUNT, NUMBER_LINE}

# every child must set these three variables
# in the _add_specifics function
var world_part : String
var id : String
var minigame_type : int

signal game_ended(success: bool)

var MenuBarScene : PackedScene = load("res://minigames/generics/MenuBar.tscn")
var status_bar_scene : PackedScene = load("res://minigames/generics/status_bar.tscn")
var menu_bar : CanvasLayer = MenuBarScene.instantiate()
var cheat_button := Button.new()
var status_bar : AnimatedSprite2D
var music_player := AudioStreamPlayer2D.new()


func _ready():
	
	assert(menu_bar.get_node("HBoxContainer/MusicButton").toggled.connect(_on_music_button_toggled) == 0)
	GlobalVariables.current_game_path = get_scene_file_path()
		
	_add_generics()
	_add_specifics()
	
	add_child(menu_bar);
	add_child(music_player)
	music_player.playing = true
	
	cheat_button.text = "cheat"
	cheat_button.position = Vector2(1800, 1000)
	cheat_button.pressed.connect(_end_game)
	add_child(cheat_button)
	
func _add_generics() -> void:
	pass


func _add_specifics() -> void:
	pass


func _game_completed() -> void:
	if GlobalVariables.world_parts.has(world_part):
		var game_dict: Dictionary = GlobalVariables.world_parts[world_part][id]
		game_dict["status"] = GlobalVariables.COMPLETED
		if id not in PlayerVariables.save_dict["minigames"][world_part]:
			PlayerVariables.save_dict["minigames"][world_part].push_back(id) 
			PlayerVariables.save_dict["minigames"]["lastCompletedMinigame"] = id
			PlayerVariables.save_dict["minigames"]["effectPlayed"] = false
		var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
		var json_string = JSON.stringify(PlayerVariables.save_dict)
		save_game.store_line(json_string)
		if status_bar:
			game_dict["score"] = status_bar.frame
		else:
			game_dict["score"] = 1
		
		if status_bar:
			await status_bar.target_reached
			await get_tree().create_timer(0.8).timeout
		var development_board = load("res://worlds/counting/development_board.tscn").instantiate()
		development_board.scale = Vector2(0.5,0.5)
		development_board.position = Vector2(300, 300)
		add_child(development_board)	
				
func _add_status_bar() -> void:
	status_bar = status_bar_scene.instantiate()
	status_bar.position = Vector2(1800, 500)
	add_child(status_bar)
	
func _end_game_condition() -> bool:
	return false
	

func _end_game_message():
	return "Mini game completed!"

func _end_game() -> void:
	#call_deferred("set_physics_process", false)
	set_physics_process(false)
	_game_completed()
	if status_bar:
		status_bar.moving = true
	emit_signal("game_ended", true)
	

func _end_game_with_failure():
	call_deferred("set_physics_process", false)
	emit_signal("game_ended", false)


func _on_music_button_toggled(_button_pressed : bool) -> void:
	music_player.playing = not _button_pressed
