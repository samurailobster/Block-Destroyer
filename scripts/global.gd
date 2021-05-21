extends Node

const HIGH_SCORE_FILE = "user://high_scores.txt"
const HIGH_SCORE_LIMIT = 5
const UNKNOWN_PLAYER = "UNKN"

var current_user := ""
var score := 0
var high_score := 0
var score_data := {}

func _ready():
	load_high_scores()

func load_high_scores():
	var high_score_file = File.new()
	if !high_score_file.file_exists(HIGH_SCORE_FILE):
		return
	high_score_file.open(HIGH_SCORE_FILE, File.READ)
	score_data = parse_json(high_score_file.get_line())
	high_score_file.close()

func save_high_score():
	if score_data.has(current_user):
		if high_score > score_data[current_user]:
			score_data[current_user] = high_score
	var save_score = File.new()
	save_score.open(HIGH_SCORE_FILE, File.WRITE)
	save_score.store_line(to_json(score_data))
	save_score.close()
