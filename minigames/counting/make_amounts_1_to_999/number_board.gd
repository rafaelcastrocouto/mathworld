extends Area2D

const MovableShape = preload("res://minigames/generics/puzzles/movable_shape.gd")
var movable_shape := MovableShape.new()
var value : int 
var texture_size : Vector2
var digit_place : int
var original_position : Vector2
var placed := false

# Called when the node enters the scene tree for the first time.
func _ready():
	movable_shape.self_modulate = Color(0,0,0,0)
	movable_shape.set_txture_normal($Numbers.sprite_frames.get_frame_texture("default", 0))
	add_child(movable_shape)
	texture_size = movable_shape.texture_normal.get_size()
	$CollisionShape2D.shape.size = texture_size
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if movable_shape.active:
		position = get_global_mouse_position() + movable_shape.mouse_offset + movable_shape.texture_size_div2
	elif not placed:
		position = original_position
