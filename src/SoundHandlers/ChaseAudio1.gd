extends AudioStreamPlayer

var seen = false

func _ready():
	pass
	
func _physics_process(delta):
	if seen:
		play()
