extends AudioStreamPlayer

var scene_name

func on_level_started():
		stop()

func on_menu_started():
	scene_name = (get_tree().current_scene.name)
	if scene_name != "DeathMenu" and not playing:
		play()
