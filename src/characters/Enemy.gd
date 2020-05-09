extends Character

var player
var player_wr
var _velocity
var _dir
var _speed = 45
const BOOST_MULTIPLIER = 1.5

var attack_dist = 30
var killer_dist = 200
var sprint_dist = 500
var run_dist = 700
var walk_dist = 750

onready var chase_audio = [$ChaseAudioHandler/ChaseAudio1, $ChaseAudioHandler/ChaseAudio2, $ChaseAudioHandler/ChaseAudio3, $ChaseAudioHandler/ChaseAudio4]
var is_chase_song_playing = [true, false, false,false]
onready var attackCDTimer = $AttackCDTimer

func _ready():
#	set_physics_process(false)
	for i in range (1,4):
		chase_audio[i].set_volume_db(-100)
	
func _physics_process(delta):
	if (player_wr.get_ref()):
#		look_at(player.get_global_position())
		if attackCDTimer.is_stopped():
			var p_pos = player.get_global_position()
			var dist = p_pos.distance_to(global_position)
			var v = p_pos - global_position
			
			if v.x > 0:
				$AnimatedSprite.play("walk_right")
			elif v.x <0:
				$AnimatedSprite.play("walk_left")
			elif v.y > 0:
				$AnimatedSprite.play("walk_down")
			elif v.y < 0:
				$AnimatedSprite.play("walk_up")
			else:
				$AnimatedSprite.play("idle")
				
			if dist < attack_dist:
				attack()
				player.increase_heart_rate()
				$AttackAudio.play()
				Global.enemy_aggression /= 2
				attackCDTimer.start()
			elif dist < killer_dist:
				chase_audio[3].set_volume_db(0)
				chase_audio[2].set_volume_db(0)
				chase_audio[1].set_volume_db(0)
				is_chase_song_playing[1] = true
				chase(p_pos, 1.9)
			elif dist < sprint_dist:
				chase_audio[3].set_volume_db(-100)
				chase_audio[2].set_volume_db(0)
				chase_audio[1].set_volume_db(0)
				is_chase_song_playing[1] = true
				chase(p_pos, 1.7)
			elif dist < run_dist:
				chase_audio[3].set_volume_db(-100)
				chase_audio[2].set_volume_db(-100)
				chase_audio[1].set_volume_db(0)
				chase(p_pos, 1.5)
			elif dist < walk_dist:
				chase_audio[3].set_volume_db(-100)
				chase_audio[2].set_volume_db(-100)
				chase_audio[1].set_volume_db(-100)
				chase(p_pos, 1.3)
			else:
				chase(p_pos)
		else:
			$AnimatedSprite.play("idle")

func growl():
	$GrowlAudio.play()
	
func chase(p_pos, severity = 1):
	_dir = (p_pos - global_position).normalized()
	_velocity = _speed * _dir * (1 + (Global.enemy_aggression * 0.01)) * severity
	_velocity = move_and_slide(_velocity)

func setup(p):
	player = p
	player_wr = weakref(p)
	print("FINISHED ENEMY SETUP", p)
#	set_physics_process(true)
	
func attack():
	player.update_hp(-1)
		
func boost():
	if $BoostTimer.is_stopped():
		$BoostTimer.start()
		print("Speed boosted to ", _speed)
		_speed *= BOOST_MULTIPLIER

func _on_AgressionTimer_timeout():
	Global.enemy_aggression += 1.0
	$AgressionTimer.start()

func _on_BoostTimer_timeout():
	print("Speed reduced to ", _speed)
	_speed /= BOOST_MULTIPLIER
