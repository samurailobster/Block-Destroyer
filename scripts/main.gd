extends Node

onready var center_containter := $CenterContainer/MarginContainer/VBoxContainer
onready var blocks_container := $background_blocks
onready var special_fx := $special_fx
onready var fx_timer := $fx_timer
onready var user_name_entry := $initials
onready var options_panel := $options
onready var info_label := $info_label
onready var animation := $anim
onready var game_music := $main_music

export (PackedScene) var current_level
export (PackedScene) var high_score_display

func _ready():
	if Global.game_music:
		game_music.play()
	else:
		game_music.stop()
	display_high_scores()
	fx_timer.start()
	setup_info_label()

func setup_info_label():
	var today = OS.get_datetime()
	var today_string = "Prototype: Bravo Delta: %s/%s/%s"
	info_label.text = today_string % [str(today.month), str(today.day), str(today.year)]
	animation.play("rainbow")

func assign_random_rotation():
	randomize()
	for _each in blocks_container.get_children():
		_each.rotation_degrees = rand_range(0, 180)
	fx_timer.start()

func rotate_blocks():
	var blocks_array := blocks_container.get_children()
	for _each in blocks_array:
		spin_block(_each)

func spin_block(_block):
	randomize()
	var random_rotation := rand_range(-360, 360)
	special_fx.interpolate_property(_block, "rotation_degrees", _block.rotation_degrees, _block.rotation_degrees + random_rotation, 2, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	special_fx.start()
	
func display_high_scores():
	for _each_key in Global.score_data:
		var h = high_score_display.instance()
		center_containter.add_child(h)
		h.append_bbcode("[center][rainbow]%s : %s[/rainbow][/center]" % [str(_each_key), str(Global.score_data[_each_key])])

func _on_start_button_pressed():
	if Global.current_user == "":
		user_name_entry.popup_centered()
		user_name_entry.show()
	else:
		begin_game()

func _on_fx_timer_timeout():
	rotate_blocks()

func _on_LineEdit_text_entered(new_text):
	if new_text == "":
		Global.current_user = Global.UNKNOWN_PLAYER
	else:
		Global.current_user = new_text
	begin_game()

func begin_game():
	get_tree().change_scene_to(current_level)

func _on_options_button_pressed():
	options_panel.popup_centered()
	options_panel.show()
	$options/MarginContainer/VBoxContainer/mute_music.pressed = Global.game_music

func _on_CheckBox_toggled(button_pressed : bool):
	if button_pressed:
		print(button_pressed)
		print(Global.game_music)
		game_music.stop()
		Global.game_music = false
	else:
		print(button_pressed)
		print(Global.game_music)
		game_music.play()
		Global.game_music = true
	Global.save_config()

func _on_clear_high_scores_toggled(button_pressed):
	Global.wipe_high_scorefile()
	#clears the high score objects from the main menu
	for _each in center_containter.get_children():
		var _eachtype = _each.get_class()
		if _eachtype == "RichTextLabel":
			_each.queue_free()
