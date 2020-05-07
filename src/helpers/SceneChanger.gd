extends CanvasLayer

signal scene_changed

onready var animation_player = $AnimationPlayer
onready var black = $Control/BlackColorRect
onready var delay_timer = $DelayTimer

func change_scene(path, delay = 0.2):
	delay_timer.start(delay)
	yield(delay_timer, "timeout")
	
	animation_player.play("fade")
	yield(animation_player, "animation_finished")

	get_tree().change_scene(path)

	animation_player.play_backwards("fade")
	yield(animation_player, "animation_finished")

	emit_signal("scene_changed")
