extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	Input.#set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_select"):
		get_tree().reload_current_scene()

#func _input(event):
#	if event is InputEventMouseMotion:
#		var mouse_pos = event.relative
#		$Player.move_arc_light(mouse_pos)
