extends ColorRect

const SPEED_RANGE = Vector2(-200, 200)  # Velocidade aleatória
var velocity = Vector2()

func _ready():
	velocity = Vector2(randf_range(-35,35), 35)
	# Autodestrói após 2 segundos
	await get_tree().create_timer(0.8).timeout
	queue_free()

func _process(delta):
	position.y += velocity.y * delta
	position.x += velocity.x * delta
	modulate.a -= 1.5 * delta;
