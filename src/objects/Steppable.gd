extends Node2D

signal stepped_on

#onready var heartbeat = get_tree().get_root().get_node("SoundHandlers").get_node("Heartbeat")
onready var parent = get_parent()
onready var audio = $AudioStreamPlayer2D

func _ready():
	#connect("stepped_on", heartbeat,"increase_heart_rate")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		audio.play()	
		emit_signal("stepped_on")
