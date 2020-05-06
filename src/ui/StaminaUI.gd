extends CanvasLayer

var stamina = 100 setget set_stamina
var stamina_refill_speed = 0.1
var stamina_usage_speed = -0.8
var max_stamina = 100
var current_color

onready var timer = $StaminaTimer
onready var bar = $StaminaBar

func _ready():
	current_color = bar.get_tint_under()
	
func _physics_process(delta):
	change_stamina(stamina_refill_speed)

func change_stamina(val = 0):
	if val != 0:
		self.stamina += val	
	bar.set_value(stamina)
	if stamina == 0:
		timer.start()
		bar.set_tint_under(Color(255,0,0,current_color.a))
		#change_tint
	
func set_stamina(new_val):
	stamina = new_val
	stamina = clamp(stamina, 0, max_stamina)

func _on_StaminaTimer_timeout():
	bar.set_tint_under(current_color)
	pass # Replace with function body.
