extends AudioStreamPlayer

var scene_name
var invalid_scenes = ["DeathMenu", "WinMenu"]
func on_level_started():
		stop()

func on_menu_started():
	scene_name = (get_tree().current_scene.name)
	if not invalid_scenes.has(scene_name) and not playing:
		play()
