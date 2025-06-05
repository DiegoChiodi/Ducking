extends Sprite2D

func _ready():
	await get_tree().create_timer(0.25).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modulate.a -= 5 * delta;
