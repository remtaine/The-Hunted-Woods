extends "res://src/levels/Level.gd"

onready var director = $Helpers/EnemyDirector
onready var canvas = $Helpers/ForestCanvasModulate
onready var heartbeat = $Player/Sounds/Heartbeat
#onready va
#TODO fix problem of moving player to ysort
func _ready():
	connect("noise_made", $Helpers/EnemyDirector, "_on_noise_made")
	director.setup(player)
	connecting_branches()
	director.connect("scared_by_noise", heartbeat, "got_scared")

func _on_Player_hp_updated():
	canvas.hurt()

func connecting_branches():
	for branch in $Objects/BranchesHolder.get_children():
		branch.connect("stepped_on", $Helpers/EnemyDirector, "_on_Branches_stepped_on")
