extends CharacterBody2D

var gravity = 5
var speed = 100
func _process(delta):
	if !is_on_floor():
		velocity.y += gravity
		
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed

	move_and_slide()
