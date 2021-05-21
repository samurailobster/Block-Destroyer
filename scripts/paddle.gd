extends KinematicBody2D

onready var anchor := $anchor
onready var audio := $audio
onready var audio_timer := $audio_timer

export var run_speed = 1000

var audio_playing := false
var velocity = Vector2(0,0)

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)

func play_sound():
	if audio_playing == true:
		return
	audio_playing = true
	audio.play()
	audio_timer.start()

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('right')
	var left = Input.is_action_pressed('left')
	if right:
		velocity.x += run_speed
	if left:
		velocity.x -= run_speed
	velocity.y = 0


func _on_audio_timer_timeout():
	audio_playing = false
