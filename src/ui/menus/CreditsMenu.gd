extends "res://src/ui/menus/Menu.gd"

var main_menu_dest = "res://src/ui/menus/MainMenu.tscn"

func _on_MainMenuButton_pressed():
	$LoadingLabel.visible = true
	SceneChanger.change_scene(main_menu_dest)
