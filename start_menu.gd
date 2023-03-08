extends Node2D

var mini_game_button_scene = preload("res://mini_game_choice.tscn")

func _mk_button(scene : String, game : String, pos : Vector2i) -> void: 
	var dx : int = 90
	var dy : int = 100
	var start_pos = Vector2(50,50)
	
	var button : Button = mini_game_button_scene.instantiate()
	button.scene = scene
	button.text = game
	button.position = start_pos + Vector2((button.size.x + dx)*pos.x, dy*pos.y)
	add_child(button)

func _ready() -> void:
	
	_mk_button("uid://trwqfap7xx15", "fraction bridge", Vector2i(0,0))
	_mk_button("uid://bg0qhhfmqp68r", "fraction laser", Vector2i(1,0))
	_mk_button("uid://b756fj2codywv", "Pytagoras puzzle", Vector2i(2,0))	
	_mk_button("uid://cgwefokkpwqw0", "Ordering", Vector2i(3,0))	
