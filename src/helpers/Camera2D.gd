extends Camera2D

var scene_1_limits = [0, 0, 960, 1000]
var scene_3_limits = [10,-200,2350,2150]

func _ready():
	var name = (get_tree().current_scene.name)
	match name:
		"Level1":
			pass
		"Level3":
			 set_limit(MARGIN_LEFT, scene_3_limits[0])
			 set_limit(MARGIN_TOP, scene_3_limits[1])
			 set_limit(MARGIN_RIGHT, scene_3_limits[2])
			 set_limit(MARGIN_BOTTOM, scene_3_limits[3])
	
