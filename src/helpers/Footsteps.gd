extends Node

onready var audio = [$FootstepsAudio1, $FootstepsAudio2, $FootstepsAudio3, $FootstepsAudio4]

func play():
	randomize()
	var i = randi() % 100
	
	if i < 30:
		audio[0].play() 
	elif i < 55:
		audio[1].play() 
	elif i < 80:
		audio[2].play() 
	else:#if i < 80:
		audio[3].play() 

func change_volume(vol):
	for audio in get_children():
		audio.set_volume_db(vol)
