extends Node

const CONFIG_FILE := "user://config.cfg"

const HIGH_SCORE_FILE := "user://high_scores.txt"
const HIGH_SCORE_LIMIT := 5
const UNKNOWN_PLAYER := "UNKN"

var current_user := ""
var score := 0
var high_score := 0
var score_data := {}

#game options
var game_music := true

func _ready():
	load_config()
	load_high_scores()

func load_config():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err == OK:
		game_music = config.get_value("audio", "game_music", true)
	else:
		print("No config file found.")

func save_config():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err == OK:
		if not config.has_section_key("audio", "game_music"):
			config.set_value("audio", "game_music", game_music)
		config.save(CONFIG_FILE)
	else:
		print("No config file found.")

func load_high_scores():
	var high_score_file = File.new()
	if !high_score_file.file_exists(HIGH_SCORE_FILE):
		return
	high_score_file.open(HIGH_SCORE_FILE, File.READ)
	if high_score_file.get_len() == 0:
		return
	score_data = parse_json(high_score_file.get_line())
	high_score_file.close()

func save_high_score():
	if score_data.has(current_user):
		if high_score > score_data[current_user]:
			score_data[current_user] = high_score
	else:
		score_data[current_user] = score
	var save_score = File.new()
	save_score.open(HIGH_SCORE_FILE, File.WRITE)
	save_score.store_line(to_json(score_data))
	save_score.close()

func wipe_high_scorefile():
	score_data.clear()
	var high_score_file = File.new()
	if !high_score_file.file_exists(HIGH_SCORE_FILE):
		return
	else:
		high_score_file.open(HIGH_SCORE_FILE, File.WRITE)
		high_score_file.store_string("")
		high_score_file.close()
