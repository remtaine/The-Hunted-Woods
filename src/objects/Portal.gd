extends Area2D

export var destination = "res://src/levels/Level3.tscn"

func _on_Portal_body_entered(body):
	if (body.has_method("freeze")):
		body.freeze()
		SceneChanger.change_scene(destination)
