extends Node2D

enum HEART_LEVELS {
	NONE,
	SLOW,
	MEDIUM,
	FAST,
	VERY_FAST,
	ERRATIC
}

var heart_level = 0
onready var slow_heartbeat = $SlowHRAudioStreamPlayer2D
onready var medium_heartbeat = $MediumHRAudioStreamPlayer2D
onready var fast_heartbeat = $FastHRAudioStreamPlayer2D
onready var very_fast_heartbeat = $VeryFastHRAudioStreamPlayer2D
onready var CDTimer = $CooldownTimer

func _ready():
	pass
	
func play_heart_sound():
	match heart_level:
		HEART_LEVELS.SLOW:
			print("SLOW")
			slow_heartbeat.play()
		HEART_LEVELS.MEDIUM:
			print("MEDIUM")
			medium_heartbeat.play()
		HEART_LEVELS.FAST:
			print("FAST")			
			fast_heartbeat.play()
		HEART_LEVELS.VERY_FAST:
			print("VERY_FAST")			
			very_fast_heartbeat.play()

func stop_heart_sound():
	match heart_level:
		HEART_LEVELS.SLOW:
			slow_heartbeat.stop()
		HEART_LEVELS.MEDIUM:
			medium_heartbeat.stop()
		HEART_LEVELS.FAST:
			fast_heartbeat.stop()
		HEART_LEVELS.VERY_FAST:
			very_fast_heartbeat.stop()
		
func increase_heart_rate():
	if heart_level >= HEART_LEVELS.VERY_FAST:
		return
	stop_heart_sound()
	heart_level += 1
	play_heart_sound()
	CDTimer.start()

func decrease_heart_rate():
	if heart_level <= HEART_LEVELS.NONE:
		return
	stop_heart_sound()
	heart_level -= 1
	play_heart_sound()

func _on_CooldownTimer_timeout():
	print("COOLED DOWN")
	decrease_heart_rate()
	if heart_level > HEART_LEVELS.NONE:
		CDTimer.start()
