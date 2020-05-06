extends Node2D

signal enemy_spawned
signal scared_by_noise

const ENEMY_LEEWAY = Vector2(700,0)
onready var enemy_resource = preload("res://src/characters/Enemy.tscn")
onready var aggression_timer = $AggressionTimer
var scream_audios = []
var growl_audios = []
 
var current_aggression = 0
var tolerance = 0
var has_spawned_enemy = false
var player

func _ready():
	scream_audios.append($Screams/ScreamAudio1)
	scream_audios.append($Screams/ScreamAudio2)
	scream_audios.append($Screams/ScreamAudio3)
	scream_audios.append($Screams/ScreamAudio4)

	growl_audios.append($Growls/GrowlAudio1)
	growl_audios.append($Growls/GrowlAudio2)
	growl_audios.append($Growls/GrowlAudio3)

func setup(p):
	print("SETUP PLAYER")
	player = p
	print("PLAYER is", player)
	print("P is", p)

func _physics_process(delta):
	if current_aggression >= tolerance and not has_spawned_enemy:
		print("OOH IM ANGRY NOW")
		spawn_enemy()
		has_spawned_enemy = true
		
func noise_made():
	current_aggression += 1

func _on_AggressionTimer_timeout():
	if not has_spawned_enemy:
		randomize()
		var r = randi() % 100
		if r < 25:
			scream_audios[0].play()
		elif r < 50:
			scream_audios[1].play()
		elif r < 75:
			scream_audios[2].play()
		else:
			scream_audios[3].play()
		aggression_timer.start()
		noise_made()	
		emit_signal("scared_by_noise")
	
func spawn_enemy():
	print("ENEMY SPAWNED")
	var enemy = enemy_resource.instance()
	enemy.global_position = player.get_global_position() - ENEMY_LEEWAY
	enemy.setup(player)
	add_child(enemy)
	emit_signal("enemy_spawned", enemy.global_position)

func _on_Branches_stepped_on():
	$SteppedOnTimer.start()
	print("stepped on something!")

func _on_SteppedOnTimer_timeout():
#	pass # Replace with function body.
	print("Ive reached the timeout!")
	if true:#not has_spawned_enemy:
		randomize()
		var r = randi() % 100
		print("played with r of ", r)
		if r < 33:
			growl_audios[0].play()
		elif r < 66:
			growl_audios[1].play()
		else:
			growl_audios[2].play()
		$HeartrateDelayTimer.start()
		noise_made()
		
func _on_HeartrateDelayTimer_timeout():
	emit_signal("scared_by_noise")
