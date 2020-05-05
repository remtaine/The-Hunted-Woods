extends Character

enum STATES {
	IDLE,
	WALK,
	RUN,
	BUMP,
	HURT,
	DEAD,
	SHOOTING,
	FROZEN
}

enum EVENTS {
	INVALID=-1,
	STOP,
	WALK,
	RUN,
	BUMP,
	HURT,
	SHOOT,
	DIE
}

const SPEEDS = {
	STATES.IDLE: 0,
	STATES.WALK: 150,
	STATES.RUN: 500
}

const ANIM_SPEEDS = {
	STATES.IDLE: 0,
	STATES.WALK: 1,
	STATES.RUN: 1.2
}

var DIR = {
	NONE = Vector2(0, 0),
	UP = Vector2(0, -1),
	DOWN = Vector2(0, 1),
	LEFT = Vector2(-1, 0),
	RIGHT = Vector2(1, 0)
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
	DIR.LEFT: [135, 225]	
}
var last_pressed = "none"

onready var flashlight = $Flashlight
var _speed
var _anim_speed
var _velocity
var _dir = DIR.NONE
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
		[STATES.IDLE, EVENTS.SHOOT]: STATES.SHOOTING,
		[STATES.WALK, EVENTS.SHOOT]: STATES.SHOOTING,
		[STATES.RUN, EVENTS.SHOOT]: STATES.SHOOTING,
	}
	
func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	animation_player.play("idle")



func _physics_process(delta):
	var inputs = get_raw_input()
	var event = get_event(inputs)
	change_state(event)
	
	match _state:
		STATES.WALK, STATES.RUN:
			match _dir:
				DIR.DOWN:
					animation_player.play("walk_down")
					print("CURRENT ANIMATION SPEED IS", animation_player.get_playing_speed())
				DIR.LEFT:
					animation_player.play("walk_left")
				DIR.RIGHT:
					animation_player.play("walk_right")
				DIR.UP:
					animation_player.play("walk_up")

			self._dir = inputs.dir
			_velocity = _dir * _speed
			_velocity = move_and_slide(_velocity, DIR.UP)

func get_raw_input():
	return {
		dir = get_input_direction(),
		is_running = Input.is_action_pressed("run"),
		is_shooting = Input.is_action_just_pressed("shoot")
	}
	
func get_event(input):
	if input.is_shooting:
		return EVENTS.SHOOT
	elif input.dir != Vector2.ZERO:
		if input.is_running:
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
	print("ENTERING STATE ", _state)
	match _state:
		STATES.RUN, STATES.WALK:
			_speed = SPEEDS[_state]
			_anim_speed = ANIM_SPEEDS[_state]
			rotate_arc_light(_dir)
		STATES.IDLE:
			_speed = SPEEDS[_state]
			_anim_speed = ANIM_SPEEDS[_state]
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

func change_facing_dir(dir):
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
	if Input.is_action_pressed("move_up") and (last_pressed == "move_up" or not Input.is_action_pressed(last_pressed)):
		last_pressed = "move_up"
		return DIR.UP
	elif Input.is_action_pressed("move_down") and (last_pressed == "move_down" or not Input.is_action_pressed(last_pressed)):
		last_pressed = "move_down"
		return DIR.DOWN
	elif Input.is_action_pressed("move_left") and (last_pressed == "move_left" or not Input.is_action_pressed(last_pressed)):
		last_pressed = "move_left"
		return DIR.LEFT
	elif Input.is_action_pressed("move_right") and (last_pressed == "move_right" or not Input.is_action_pressed(last_pressed)):
		last_pressed = "move_right"
		return DIR.RIGHT
	else:
		return DIR.NONE
	
	
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

func _on_Branches_stepped_on():
	$Sounds/Heartbeat.increase_heart_rate()

func freeze():
	change_state(STATES.FROZEN)

func rotate_arc_light(new_dir = Vector2.ZERO):
	if new_dir == Vector2.ZERO:
		var mouse_pos = get_global_mouse_position()
		$ArcLightPosition.look_at(mouse_pos)
		return $ArcLightPosition.rotation_degrees
	$ArcLightPosition.rotation_degrees = (FOV_LIMITS[new_dir][0] + FOV_LIMITS[new_dir][1])/2 

func _input(event):
	if event is InputEventMouseMotion:
		match _state:
			STATES.IDLE:
				var angle = rotate_arc_light()	
				if angle > DIR_LIMITS[DIR.RIGHT][0] and angle < DIR_LIMITS[DIR.RIGHT][1]:
					change_facing_dir(DIR.RIGHT)
				elif angle > DIR_LIMITS[DIR.DOWN][0] and angle < DIR_LIMITS[DIR.DOWN][1]:
					change_facing_dir(DIR.DOWN)
				elif angle > DIR_LIMITS[DIR.LEFT][0] and angle < DIR_LIMITS[DIR.LEFT][1]:
					change_facing_dir(DIR.LEFT)
				elif angle > DIR_LIMITS[DIR.UP][0] and angle < DIR_LIMITS[DIR.UP][1]:
					change_facing_dir(DIR.UP)
				
				
			STATES.WALK:
				var mouse_pos = get_global_mouse_position()
				$ArcLightPosition.look_at(mouse_pos)
				var angle = $ArcLightPosition.rotation_degrees
				angle = get_normalized_angle(angle)
				$ArcLightPosition.rotation_degrees = clamp(angle,FOV_LIMITS[_dir][0], FOV_LIMITS[_dir][1])

#func move_arc_light(mouse_pos):
#	$ArcLightPosition.rotation = (mouse_pos - $ArcLightPosition.position).angle()
