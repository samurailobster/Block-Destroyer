extends Node2D

onready var block_holder := $block_holder
onready var hud := $HUD
onready var timer := $timer

export (PackedScene) var block
export (PackedScene) var paddle
export (PackedScene) var ball

var screen_size
var starting_x_pos = 32
var starting_y_pos = 128
var last_pos = null
var increment_x = 0
var increment_y = 0

var columns = 30
var rows = 6
var block_space = 1
var block_size_mod = 0

var block_matrix = []
var block_scale = Vector2(1,1)

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	create_block_matrix()
	create_paddle()
	create_ball()
	flush_scores()

func flush_scores():
	Global.high_score = 0
	Global.score = 0

func create_block_matrix():
	for y in rows:
		for x in columns:
			var new_block = block.instance()
			block_holder.add_child(new_block)
			block_matrix.append(new_block)
			new_block.start(y)
			new_block.connect("score", self, "update_score")
			new_block.connect("check_blocks", self, "whats_left")
			new_block.position = Vector2(starting_x_pos + increment_x, starting_y_pos + increment_y)
			increment_x += 32 + block_space
		increment_x = 0
		increment_y += 32 + block_space

func create_paddle():
	var new_paddle = paddle.instance()
	add_child(new_paddle)
	new_paddle.position = Vector2(screen_size.x / 2, 870)

func create_ball():
	var new_ball = ball.instance()
	add_child(new_ball)
	new_ball.connect("game_over", self, "_on_game_over")
	new_ball.position = Vector2(screen_size.x / 2, 325)

func update_score(value : int):
	hud.change_score(value)
	check_high_score()

func check_high_score():
	if Global.score > Global.high_score:
		Global.high_score = Global.score

func _on_game_over():
	Global.save_high_score()
	timer.wait_time = 3.0
	timer.start()
	get_tree().change_scene("res://scenes/main.tscn")

func whats_left():
	if block_matrix.size() == 0:
		$winner.text = "You win!"
		_on_game_over()

