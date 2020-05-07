extends Label

var dialogues_branch = [
	"hope nobody heard that",
	"did they hear me?",
	"I should be quiet"
]

var dialogues_scream = [
	"I'm coming for you!",
	"I'll save you!",
	"I hope she's safe"
]

var dialogues_enemy = [
	"what's that sound",
	"what was that",	
]

var TALKS = {
	"branch": dialogues_branch,
	"scream": dialogues_scream,
}

func talk(context):
	match context:
		"branch":
			pass
		"scream":
			pass
		"random":
			pass

func show_dialogue():
	$AnimationPlayer.play("show_dialogue")
