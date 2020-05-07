extends Node2D

signal stepped_on

var _level

#onready var heartbeat = get_tree().get_root().get_node("SoundHandlers").get_node("Heartbeat")
onready var parent = get_parent()
onready var audio = $AudioStreamPlayer2D

func _ready():
	pass

func setup(level):
	_level = level
	connect("noise_given",level, "_on_getting_noise")	

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.pause_movement()
		#TODO trigger dialogue
		audio.play()	
		emit_signal("stepped_on")
