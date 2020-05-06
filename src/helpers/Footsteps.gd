extends Node

func play():
	randomize()
	var i = randi() % 100
	
	if i < 30:
		$FootstepsAudio1.play() 
	elif i < 55:
		$FootstepsAudio2.play() 
	elif i < 80:
		$FootstepsAudio3.play() 
	else:#if i < 80:
		$FootstepsAudio4.play() 
#	else:
#		$FootstepsAudio5.play() 
