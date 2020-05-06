extends CanvasModulate

var default_color = Color(50,50,130,255)
var damaged_color = Color(255,50,50,255)

func _ready():
	default_color = get_color()

func hurt():
	$AnimationPlayer.play("hurt")
