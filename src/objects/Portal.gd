extends Area2D

export var destination = "res://src/levels/Level3.tscn"

func _on_Portal_body_entered(body):
	if (body.is_in_group("player")):
		Global.godmode = true
		SceneChanger.change_scene(destination)
