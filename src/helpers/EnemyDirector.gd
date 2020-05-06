extends Node2D

signal enemy_spawned
signal scared_by_noise

const ENEMY_LEEWAY = Vector2(700,0)
onready var enemy_resource = preload("res://src/characters/Enemy.tscn")
onready var aggression_timer = $AggressionTimer
var scream_audios = []
var growl_audios = []
 
var tolerance = 4
var player
var enemy

func _ready():
	Global.is_enemy_spawned = false
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
	if get_aggression() >= tolerance and not Global.is_enemy_spawned:
		spawn_enemy()
		Global.is_enemy_spawned = true
		
func increase_aggression():
	Global.enemy_aggression += 1
	
func get_aggression():
	return Global.enemy_aggression
	
func noise_made():
	increase_aggression()
	if Global.is_enemy_spawned:
		enemy.boost()

func _on_AggressionTimer_timeout():
	if true:
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
	enemy = enemy_resource.instance()
	enemy.global_position = player.get_global_position() - ENEMY_LEEWAY
	enemy.setup(player)
	add_child(enemy)
	emit_signal("enemy_spawned", enemy.global_position)

func _on_Branches_stepped_on():
	print("branches stepped on")
	$SteppedOnTimer.start()

func _on_SteppedOnTimer_timeout():
	if true:#Global.is_enemy_spawned:
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
