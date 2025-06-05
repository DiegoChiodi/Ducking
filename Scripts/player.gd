extends CharacterBody2D

#MOVIMENTAÇÃO X ------
const SPEED = 200.0
var time_passed := 0.0  # Tempo acumulado para gerar o efeito senoidal
#MOVIMENTAÇÃO Y -----
const JUMP_VELOCITY = -300.0
const JUMPS_MAX = 1;
var jumps = JUMPS_MAX;
var per_grav = true
#Dash -----
var dash = true
var inDash = false
const DASH_DURING = 0.3
var cowdow_dash = 0.0
#Cenas
var cenShadow = preload('res://Scenes/shadow.tscn')
#Shadow
const shadowsCreate = 3

func _physics_process(delta: float) -> void:
	# Input horizontal
	var direction_x := Input.get_axis("move_left", "move_right")
	var direction_y := Input.get_axis("move_up", "move_down")
	var space = Input.is_action_just_pressed("move_space")#se espaço foi apertado 1x
	
	var ground = is_on_floor()	#se estou no chão
	
	if space && dash:
		inDash = true
		dash = false
		cowdow_dash = 0
		velocity.y = direction_y * SPEED * 1.25
		velocity.x = direction_x * SPEED * 1.25
		per_grav = false
		$aniDuck.scale = Vector2(1.1,0.9) #efeito visual
		$timShadow.start()
	if inDash:
		cowdow_dash += 1 * delta
		
		if cowdow_dash >= DASH_DURING:
			inDash = false
			per_grav = true
			$timShadow.stop()
			scenShadowCreate()
		
	else:
		if direction_x:
			# Movimento horizontal
			velocity.x = direction_x * SPEED
			$aniDuck.play("run")
			# Efeito de balanço senoidal
			time_passed += delta * 8.0  # Velocidade do balanço
			var angle := sin(time_passed) * 8.0  # Oscila entre -10 e +10 graus
			$aniDuck.rotation_degrees = angle

			# Flip horizontal
			$aniDuck.flip_h = direction_x < 0
			$aniDuck.scale = Vector2.ONE  # Volta ao tamanho
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$aniDuck.frame = 2
			$aniDuck.stop()
		# Reset ao parar
			time_passed = 0.0
			$aniDuck.rotation_degrees = 0.0
			$aniDuck.scale = Vector2.ONE  # Volta ao tamanho
	
	if ground:
		dash = true
		jumps = JUMPS_MAX
		
	if per_grav:
		if not ground:
			if velocity.y > 0:
				velocity += get_gravity() * delta * 1.75
			else:
				velocity += get_gravity() * delta
		# Handle jump.
	if Input.is_action_just_pressed("move_up") and jumps > 0:
		velocity.y = JUMP_VELOCITY
		jumps -= 1
	move_and_slide()

func _on_tim_shadow_timeout() -> void:
	scenShadowCreate()
	
func scenShadowCreate():
	var insShadow = cenShadow.instantiate()
	var anim = $aniDuck.animation
	var frame = $aniDuck.frame
	var frame_size = $aniDuck.sprite_frames.get_frame_texture(anim, frame).get_size()

	insShadow.position = position + frame_size

	insShadow.scale.x = scale.x * (1 - int($aniDuck.flip_h) * 2)
	insShadow.scale.y = scale.y
	get_tree().current_scene.add_child(insShadow)
