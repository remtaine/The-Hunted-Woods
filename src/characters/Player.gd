extends Character

enum STATES {
	IDLE,
	WALK,
	RUN,
	RESTING,
	HURT,
	DEAD,
	FROZEN
}

enum EVENTS {
	INVALID=-1,
	STOP,
	WALK,
	RUN,
	REST,
	HURT,
	FREEZE,
	DIE
}

const SPEEDS = {
	STATES.IDLE: 0,
	STATES.WALK: 150,
	STATES.RUN: 250,
	STATES.DEAD: 0,
	STATES.FROZEN: 0
}

const ANIM_SPEEDS = {
	STATES.IDLE: 0,
	STATES.WALK: 1,
	STATES.RUN: 1.5
}

var DIR = {
	NONE = Vector2(0, 0),
	UP = Vector2(0, -1),
	RIGHT = Vector2(1, 0),
	DOWN = Vector2(0, 1),
	LEFT = Vector2(-1, 0),
	UPPER_LEFT = Vector2(-1, -1),
	UPPER_RIGHT = Vector2(1, -1),
	LOWER_RIGHT = Vector2(1, 1),
	LOWER_LEFT = Vector2(-1, 1)
}

var FOV_LIMITS = {
	DIR.UP: [-120, -60],
	DIR.RIGHT: [-30, 30],
	DIR.DOWN: [60, 120],
	DIR.LEFT: [150, 210]
}

var DIR_LIMITS = {
	DIR.UP: [-135, -45],
	DIR.RIGHT: [-45, 45],
	DIR.DOWN: [45, 135],
	DIR.LEFT: [135, 225],	
	DIR.UPPER_LEFT: [135, 225],
	DIR.UPPER_RIGHT: [-45, 45],	
	DIR.LOWER_LEFT: [135, 225],
	DIR.LOWER_RIGHT: [-45, 45],	
}

var last_pressed = "none"

onready var color = $Sprite.get_self_modulate()
onready var flashlight = $Flashlight
var _speed
var _anim_speed
var _velocity
var _dir = DIR.NONE
onready var hp = $Health.hp

signal hp_updated

var inputs

onready var animation_player = $AnimationPlayer

func _init():
	_state = STATES.IDLE
	_speed = SPEEDS[_state]
	_anim_speed = ANIM_SPEEDS[_state]
	
	_transitions = {
		[STATES.IDLE, EVENTS.WALK]: STATES.WALK,
		[STATES.IDLE, EVENTS.RUN]: STATES.RUN,
		[STATES.WALK, EVENTS.STOP]: STATES.IDLE,
		[STATES.WALK, EVENTS.RUN]: STATES.RUN,
		[STATES.RUN, EVENTS.STOP]: STATES.IDLE,
		[STATES.RUN, EVENTS.WALK]: STATES.WALK,
		[STATES.IDLE, EVENTS.DIE]: STATES.DEAD,
		[STATES.WALK, EVENTS.DIE]: STATES.DEAD,
		[STATES.RUN, EVENTS.DIE]: STATES.DEAD,
		[STATES.IDLE, EVENTS.FREEZE]: STATES.FROZEN,
		[STATES.WALK, EVENTS.FREEZE]: STATES.FROZEN,
		[STATES.RUN, EVENTS.FREEZE]: STATES.FROZEN,
		[STATES.FROZEN, EVENTS.RUN]: STATES.RUN,
		[STATES.FROZEN, EVENTS.STOP]: STATES.IDLE,
		[STATES.FROZEN, EVENTS.WALK]: STATES.WALK,
		[STATES.RESTING, EVENTS.STOP]: STATES.IDLE,

	}

func rest(val = true):
	if val:
		change_state(EVENTS.REST)
		$Sprite.set_self_modulate(Color(color.r + 3,color.g,color.b,color.a))
	else:
		change_state(EVENTS.STOP)
		$Sprite.set_self_modulate(color)

func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	animation_player.play("idle_down")
#	note:try to change pos of player so origin at middle
	
func _physics_process(_delta):
	if _state != STATES.DEAD and _state != STATES.FROZEN:
		inputs = get_raw_input()
		var event = get_event(inputs)
		change_state(event)
		
		match _state:
			STATES.WALK, STATES.RUN:
				if _state == STATES.RUN:
					$StaminaUI.change_stamina($StaminaUI.stamina_usage_speed)
					if _dir != inputs.dir:
						rotate_arc_light(inputs.dir)
						
				match _dir:
					DIR.DOWN:
						animation_player.play("walk_down")
					DIR.LEFT, DIR.UPPER_LEFT, DIR.LOWER_LEFT:
						animation_player.play("walk_left")
					DIR.RIGHT, DIR.UPPER_RIGHT, DIR.LOWER_RIGHT:
						animation_player.play("walk_right")
					DIR.UP:
						animation_player.play("walk_up")
	
				self._dir = inputs.dir
				_velocity = _dir * _speed
				_velocity = move_and_slide(_velocity, DIR.UP)
				continue
			STATES.RUN:
				rotate_arc_light(inputs.dir)
	else:
		animation_player.play("idle_down")
		if (_state == STATES.FROZEN):
			rotate_arc_light()

func update_hp(val = -1):
	hp += val
	$Health.update_hp_ui()
	$HurtAnimation.play("hurt")
	emit_signal("hp_updated")

func die():
	change_state(EVENTS.DIE)

func pause_movement(reason):
	change_state(EVENTS.FREEZE)
	$PauseMovementTimer.start()
	
func get_raw_input():
	return {
		dir = get_input_direction(),
		is_running = Input.is_action_pressed("run"),
		is_shooting = false #Input.is_action_just_pressed("shoot")
	}
	
func get_event(input):
	if not $PauseMovementTimer.is_stopped():
		return EVENTS.FREEZE
	if input.is_shooting:
		return EVENTS.SHOOT
	elif input.dir != Vector2.ZERO:
		if input.is_running and $StaminaUI/StaminaTimer.is_stopped():
			return EVENTS.RUN
		else:
			return EVENTS.WALK
	else:
		return EVENTS.STOP

func get_normalized_angle(angle):
	if angle > -135 and angle <225:
		return angle
	if angle < -135:
		while (angle < -135):
			angle += 360
		return angle
	if angle > 225:
		while (angle > 225):
			angle -= 360
		return angle
		 
func enter_state():
	match _state:
		STATES.DEAD, STATES.FROZEN:
			_speed = SPEEDS[_state]
			change_facing_dir(_dir)
		STATES.RUN:
			Input.set_custom_mouse_cursor(Global.cursor_crossed)
			_speed = SPEEDS[_state]
			_anim_speed = ANIM_SPEEDS[_state]
			$Sounds/Footsteps.change_volume(0)
		STATES.WALK:
			Input.set_custom_mouse_cursor(Global.cursor)
			_speed = SPEEDS[_state]
			_anim_speed = ANIM_SPEEDS[_state]
			$Sounds/Footsteps.change_volume(-10)
		STATES.IDLE:
			Input.set_custom_mouse_cursor(Global.cursor)
			_speed = SPEEDS[_state]
			_anim_speed = ANIM_SPEEDS[_state]
			_dir = inputs.dir
			match _dir:
				DIR.DOWN:
					animation_player.play("idle_down")
				DIR.LEFT:
					animation_player.play("idle_left")
				DIR.RIGHT:
					animation_player.play("idle_right")
				DIR.UP:
					animation_player.play("idle_up")
				DIR.NONE:
					animation_player.play("idle")
	animation_player.set_speed_scale(_anim_speed)

func change_facing_dir(dir = _dir):
	_dir = dir
	match dir:
		DIR.DOWN:
			animation_player.play("idle_down")
		DIR.LEFT:
			animation_player.play("idle_left")
		DIR.RIGHT:
			animation_player.play("idle_right")
		DIR.UP:
			animation_player.play("idle_up")
		DIR.NONE:
			animation_player.play("idle")

func get_input_direction():
	var x = float(Input.is_action_pressed("move_right")) - float(Input.is_action_pressed("move_left"))
	var y = float(Input.is_action_pressed("move_down")) - float(Input.is_action_pressed("move_up"))
	return Vector2(x,y)
	
func setup_camera_pos(dir):
	match dir:
		DIR.DOWN:
			flashlight.rotation_degrees = 90
			pass
		DIR.UP:
			flashlight.rotation_degrees = -90
			pass
		DIR.LEFT:
			flashlight.rotation_degrees = 180
			pass
		DIR.RIGHT:
			flashlight.rotation_degrees = 0
			pass

func rotate_arc_light(new_dir = Vector2.ZERO):
	if new_dir == Vector2.ZERO:
		var mouse_pos = get_global_mouse_position()
		$ArcLightPosition.look_at(mouse_pos)
		return $ArcLightPosition.rotation_degrees

	$ArcLightPosition.rotation_degrees = (DIR_LIMITS[new_dir][0] + DIR_LIMITS[new_dir][1])/2 

func increase_heart_rate():
	$Sounds/Heartbeat.increase_heart_rate()

func _input(event):
	if event is InputEventMouseMotion:
		match _state:
			STATES.IDLE, STATES.WALK:
				var angle = rotate_arc_light()	
				angle = get_normalized_angle(angle)
				if _state == STATES.IDLE:
					if angle > DIR_LIMITS[DIR.RIGHT][0] and angle < DIR_LIMITS[DIR.RIGHT][1]:
						change_facing_dir(DIR.RIGHT)
					elif angle > DIR_LIMITS[DIR.DOWN][0] and angle < DIR_LIMITS[DIR.DOWN][1]:
						change_facing_dir(DIR.DOWN)
					elif angle > DIR_LIMITS[DIR.LEFT][0] and angle < DIR_LIMITS[DIR.LEFT][1]:
						change_facing_dir(DIR.LEFT)
					elif angle > DIR_LIMITS[DIR.UP][0] and angle < DIR_LIMITS[DIR.UP][1]:
						change_facing_dir(DIR.UP)
				
#			STATES.WALK:
#				var mouse_pos = get_global_mouse_position()
#				$ArcLightPosition.look_at(mouse_pos)
#				var angle = $ArcLightPosition.rotation_degrees
#				angle = get_normalized_angle(angle)
#				$ArcLightPosition.rotation_degrees = clamp(angle,FOV_LIMITS[_dir][0], FOV_LIMITS[_dir][1])


func _on_PauseMovementTimer_timeout():
	change_state(EVENTS.STOP)
