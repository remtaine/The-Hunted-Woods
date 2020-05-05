extends TileMap

export var is_on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not is_on:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
