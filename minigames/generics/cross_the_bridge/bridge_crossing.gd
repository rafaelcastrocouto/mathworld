extends MiniGame

var x_scale : float = 500.0
var dy : float = 40.0


var max_int : int = 2
var max_length : float = max_int*x_scale
var number_line_pos : Vector2 = Vector2(600, 100)
var varying_objects : Array 
var number_line : NumberLine

var max_score : int
var score : int
var correct_sound : AudioStream = preload("res://minigames/generics/cross_the_bridge/assets/correct.mp3")
var incorrect_sound : AudioStream = preload("res://minigames/generics/cross_the_bridge/assets/whip.mp3")
var finished_sound : AudioStream = preload("res://minigames/generics/cross_the_bridge/assets/success.mp3")
var creature_start_pos : Vector2 = Vector2(80,750)

var number : CharacterBody2D = preload("res://minigames/generics/cross_the_bridge/number.tscn").instantiate()
var creature : CharacterBody2D = preload("res://minigames/generics/cross_the_bridge/creature.tscn").instantiate()
var send_number_button := TextureButton.new()
var send_number_texture : Texture2D = preload("res://minigames/generics/cross_the_bridge/assets/go_button_a.svg")
var send_number_pressed : Texture2D = preload("res://minigames/generics/cross_the_bridge/assets/go_button_b.svg")
var new_task_timer := Timer.new()
var sound_effect := AudioStreamPlayer2D.new()
var pickable_object := Sprite2D.new()
var number_line_varies := false

var plus_texture : Texture2D = preload("res://minigames/generics/cross_the_bridge/assets/right_button.png")
var min_texture : Texture2D = preload("res://minigames/generics/cross_the_bridge/assets/left_button.png")
var plus_pressed_texture : Texture2D = preload("res://minigames/generics/cross_the_bridge/assets/right_dark_button.png")
var min_pressed_texture : Texture2D = preload("res://minigames/generics/cross_the_bridge/assets/left_dark_button.png")
var creature_animation : AnimatedSprite2D

func _add_generics() -> void:
	
	assert(creature.connect("move_completed", _on_creature_arrival) == 0)	
	assert(send_number_button.connect("pressed", _send_number) == 0)
	assert(number.connect("move_completed", _on_number_arrival) == 0)
	assert(new_task_timer.connect("timeout", _on_timeout) == 0)
	
	new_task_timer.one_shot = true
	
	new_task_timer.wait_time = 0.4
	var score_sprite := Sprite2D.new()	

	
	send_number_button.texture_normal = send_number_texture
	send_number_button.texture_pressed = send_number_pressed
	
	sound_effect.stream = incorrect_sound
	
	creature.position = creature_start_pos
	pickable_object.position = creature_start_pos + Vector2(1700, 0)
	
	add_child(send_number_button)
	add_child(creature)
	add_child(number)
	add_child(sound_effect)
	add_child(new_task_timer)
	add_child(pickable_object)
	

func _add_specifics() -> void:
	pass	

func _prepare_task() -> void:
	pass

func _mk_task() -> void:
	for i in range(varying_objects.size()):
		varying_objects[i].queue_free()
	varying_objects = []
	
	creature.show()
	pickable_object.show()
	
	_prepare_task()
	_mk_num_line()
	
func _mk_num_line() -> void:
	pass


func _on_creature_arrival() -> void:
	new_task_timer.start()
	creature.hide()
	pickable_object.hide()
	creature.moving = false
	creature.position = creature_start_pos
	

func _correct_answer() -> bool:
	return false

func _number_arrival_specifics() -> void:
	pass

func _on_number_arrival() -> void:	
	_number_arrival_specifics()
	if _correct_answer():
		score += 1
		sound_effect.stream = correct_sound
		creature_animation.animation = "moving"
		await get_tree().create_timer(0.5).timeout
		creature.moving = true
	else:
		if status_bar.frame == 0:
			_end_game_with_failure()
			return
		status_bar.frame -= 1
		sound_effect.stream = incorrect_sound
		_mk_task()
	
	sound_effect.play()
	if score == max_score:
		sound_effect.stream = finished_sound
		sound_effect.play()
		_end_game()
	
	
	
func _on_timeout() -> void:
	creature_animation.animation = "idle"
	_mk_task()
	

func _send_number() -> void:
	number.moving = true
	
