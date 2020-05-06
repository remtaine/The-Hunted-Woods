extends CanvasLayer

signal menu_started

func _ready():
	Input.set_custom_mouse_cursor(Global.cursor_knife)
	$LoadingLabel.visible = false
	MenuMusic.on_menu_started()
