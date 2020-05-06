extends "res://src/ui/menus/Menu.gd"

var level3_dest = "res://src/levels/Level3.tscn"
var main_menu_dest = "res://src/ui/menus/MainMenu.tscn"

func _on_RestartButton_pressed():
	$LoadingLabel.visible = true
	SceneChanger.change_scene(level3_dest)

func _on_MainMenuButton_pressed():
	$LoadingLabel.visible = true
	SceneChanger.change_scene(main_menu_dest)
