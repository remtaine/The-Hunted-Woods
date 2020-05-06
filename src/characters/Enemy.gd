extends Character

var player
var player_wr
var _velocity
var _dir
var _speed = 50
var aggression = 1.0

var attack_dist = 30
var sprint_dist = 150
var run_dist = 250
var walk_dist = 350

onready var attackCDTimer = $AttackCDTimer

func _ready():
#	set_physics_process(false)
	pass
	
func _physics_process(delta):
	print("ENEMY AT", global_position)
	if (player_wr.get_ref()):
#		look_at(player.get_global_position())
		var p_pos = player.get_global_position()
		var dist = p_pos.distance_to(global_position)
		
		if attackCDTimer.is_stopped():
			if dist < attack_dist:
				attack()
				attackCDTimer.start()
			elif dist < sprint_dist:
				chase(p_pos, 1.5)
			elif dist < run_dist:
				chase(p_pos, 1.3)
			elif dist < walk_dist:
				chase(p_pos, 1.1)
			else:
				chase(p_pos)

func chase(p_pos, severity = 1):
	_dir = (p_pos - global_position).normalized()
	_velocity = _speed * _dir * (1 + (aggression * 0.01)) * severity
	_velocity = move_and_slide(_velocity)

func setup(p):
	player = p
	player_wr = weakref(p)
	print("FINISHED ENEMY SETUP", p)
#	set_physics_process(true)
	
func attack():
	player.update_hp(-1)
		
func _on_AgressionTimer_timeout():
	aggression += 1.0
	$AgressionTimer.start()
