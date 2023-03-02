extends CharacterBody3D

var direction = Vector3()

var speed = 10
var acceleration = 5

var default_animation = 'default down'

var sprite

func get_mouse_degrees(v1, v2):
	var deg = (v1.x * v2.x + v1.y * v2.y) / (sqrt(v1.x * v1.x + v1.y * v1.y) * sqrt(v2.x * v2.x + v2.y * v2.y))
	return rad_to_deg(acos(deg))


func _ready():
	pass

func _input(event):
	sprite = get_child(2)
	if event is InputEventMouseMotion:
		print(get_mouse_degrees({'x':509 - event.position.x, 'y': 301 - event.position.y}, {'x':-509, 'y':301}))


func _process(delta):
	sprite = get_child(2)
	direction = Vector3()
	if !Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
		sprite.set_animation(default_animation)
	else:
		if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
			direction -= transform.basis.x
			direction -= transform.basis.z
			sprite.set_animation("sideup")
			default_animation = 'default sideup'
		elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
			direction += transform.basis.x
			direction -= transform.basis.z
			sprite.set_animation("sideup")
			default_animation = 'default sideup'
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
			direction -= transform.basis.x
			direction += transform.basis.z
			sprite.set_animation("down")
			default_animation = 'default down'
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
			direction += transform.basis.x
			direction += transform.basis.z
			sprite.set_animation("down")
			default_animation = 'default down'
		else:
			if Input.is_action_pressed("ui_down"):
				direction += transform.basis.z
				sprite.set_animation("down")
				default_animation = 'default down'
			if Input.is_action_pressed("ui_up"):
				direction -= transform.basis.z
				sprite.set_animation("up")
				default_animation = 'default up'
			if Input.is_action_pressed("ui_left"):
				direction -= transform.basis.x
				sprite.set_animation("side")
				default_animation = 'default side'
			if Input.is_action_pressed("ui_right"):
				direction += transform.basis.x
				sprite.set_animation("side")
				default_animation = 'default side'
	direction = direction.normalized()
	velocity = direction * speed
	velocity.lerp(velocity, acceleration * delta)
	set_velocity(velocity)
	set_up_direction(Vector3.UP)
	move_and_slide()
