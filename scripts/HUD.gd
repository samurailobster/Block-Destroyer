extends CanvasLayer

onready var score_display := $UI/HBoxContainer/score
onready var user_display := $UI/HBoxContainer/user

func _ready():
	user_display.text = Global.current_user
	score_display.text = "0"

func change_score(value : int):
	Global.score += value
	score_display.text = str(Global.score)
