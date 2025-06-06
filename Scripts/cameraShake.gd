extends Camera2D

# Parâmetros do tremor
var shake_amount = 0.0
var shake_decay = 1.0  # Velocidade com que o tremor diminui
var original_offset = Vector2.ZERO

func _ready():
	original_offset = offset  # Armazena a posição original da câmera

func _process(delta):
	if shake_amount > 0:
		# Aplica uma posição aleatória
		offset = original_offset + Vector2(
			randf_range(-1, 1),
			randf_range(-1, 1)
		) * shake_amount
		
		# Reduz a intensidade ao longo do tempo
		shake_amount = max(shake_amount - shake_decay * delta, 0)
	else:
		# Restaura a posição original
		offset = original_offset

func start_shake(intensity: float, decay: float = 1.0):
	shake_amount = intensity
	shake_decay = decay
