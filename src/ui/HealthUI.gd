extends CanvasLayer

var hp = 3

var hearts = [0,0,0]
onready var player = get_parent()
var death_destination = "res://src/ui/menus/DeathMenu.tscn"

func _ready():
	hearts[0] = $heart1
	hearts[1] = $heart2
	hearts[2] = $heart3
	
	var name = (get_tree().current_scene.name)
	match name:
		"Level1":
			for heart in hearts:
				heart.visible = false
		"Level3":
			pass
	
func update_hp_ui():
	hp -= 1
	if hp >= 0:
		hearts[hp].visible = false
	if hp <= 0:
		$DeadAudio.play()
		player.die()
		SceneChanger.change_scene(death_destination)
	else:
		$HurtAudio.play()
