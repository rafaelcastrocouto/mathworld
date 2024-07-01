extends MiniGame

var lane : Node2D = preload("res://minigames/generics/run_hill/lane.tscn").instantiate()
var alternatives := []
var start_value := 0
var music : AudioStream = preload("res://minigames/generics/assets/highway-167255.mp3")


func _add_generics() -> void:
	
	assert(lane.finished.connect(_on_lane_finished) == 0)
	
	var background := Sprite2D.new()
	background.texture = preload("res://minigames/generics/run_hill/assets/background.png")
	add_child(background)
	background.scale = Vector2(1.8, 1.8)
	background.centered = false
	
	for i in range(4):
		var alternative = preload("res://minigames/generics/run_hill/alternative.tscn").instantiate()
		alternatives.push_back(alternative)
		add_child(alternative)

func _add_specifics():
	world_part = "counting"
	id = "run_hill"
	minigame_type = NUMBER_LINE
	
	_add_status_bar()
	status_bar.position.y -= 300
	
	lane.tick_hit.connect(_on_obstacle_hit)
	
	
	var ints := [1, 2, 3, 4, 5, 6, 7, 8, 9]
	for i in range(alternatives.size()):
		assert(alternatives[i].chosen.connect(_alternative_chosen) == 0)
				
	add_child(lane)
	_mk_alternatives()
	music_player.stream = music


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(lane):
		if lane.moving:
			lane.position.x -= lane.speed/1.4*delta


func _mk_alternatives() -> void:
	var ints = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	var indexes = [0, 1, 2, 3]
	
	randomize()
	indexes.shuffle()
	
	var i = indexes.pop_front()
	alternatives[i].position = Vector2(300 + i*200, 100)
	alternatives[i].value = lane.current_obstacle.value
	alternatives[i].get_node("Text").text = str(alternatives[i].value)
	
	ints.remove_at(lane.current_obstacle.value % 10 - 1)
	ints.shuffle()
	
	for j in indexes:
		alternatives[j].position = Vector2(300 + j*200, 100)
		alternatives[j].value = start_value + ints.pop_back()
		alternatives[j].get_node("Text").text = str(alternatives[j].value)
	start_value += 10
		
	

func _alternative_chosen(_name : String) -> void:
	lane.moving = true
	var obstacle: Area2D = lane.current_obstacle
	var alt = get_node(_name)
	if alt.value == obstacle.value:
		obstacle.matches_alternative = true
		
	for alternative in alternatives:
			if alternative != get_node(_name):
				alternative.hide()
			else:
				alternative.disabled = false
	

func _mk_new_alternatives() -> void:
	for alternative in alternatives:
		alternative.disabled = false
		alternative.show()
	_mk_alternatives()


func _on_obstacle_hit(_obstacle: Area2D) -> void:
	if _obstacle.next_obstacle:
		lane.current_obstacle = _obstacle.next_obstacle
		_mk_new_alternatives()
	
	if not _obstacle.matches_alternative:
		if status_bar.frame == 0:
			call_deferred("_end_game_with_failure")
			lane.moving = false
			lane.queue_free()
		else:
			status_bar.frame -= 1


func _on_lane_finished() -> void:
	_end_game()
