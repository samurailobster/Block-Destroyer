extends StaticBody2D 


signal score
signal check_blocks

onready var sprite := $Sprite
onready var tween := $Tween
onready var collision_shape := $collision
onready var audio := $audio

var block_textures = ["res://assets/art/element_blue_square_glossy.png",
						"res://assets/art/element_green_square_glossy.png",
						"res://assets/art/element_grey_square_glossy.png",
						"res://assets/art/element_purple_cube_glossy.png",
						"res://assets/art/element_red_square_glossy.png",
						"res://assets/art/element_yellow_square_glossy.png"]

var block_values = {0:30, 1:25, 2:20, 3:15, 4:10, 5:5}

var block_value

func start(block_color):
	block_value = block_values[block_color]
	sprite.texture = load(block_textures[block_color])

func destroy():
	emit_signal("score", block_value)
	audio.play()
	disappear()

func disappear():
	tween.interpolate_property(self, "scale", scale, Vector2.ZERO, .3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _on_Tween_tween_completed(_object, _key):
	emit_signal("check_blocks")
	queue_free()
