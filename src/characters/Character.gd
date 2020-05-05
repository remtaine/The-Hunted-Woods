extends KinematicBody2D

class_name Character

signal state_changed(state)

var _state = 0
var _transitions = {}

func _ready():
	pass
	#connect("state_changed", $StateLabel, "_on_Character_state_changed")

func enter_state():
	pass

func change_state(event):
	var transition = [_state, event]
	if not transition in _transitions:
		return
	
	_state = _transitions[transition]
	enter_state()
	emit_signal("state_changed", _state)
