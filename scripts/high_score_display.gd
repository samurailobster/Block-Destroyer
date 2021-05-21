extends RichTextLabel

func display_high_score(score_entry):
	var _result = append_bbcode("[center][rainbow]%s[/rainbow][/center]" % str(score_entry))
