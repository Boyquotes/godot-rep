extends CharacterBody3D

var direction = Vector3()

var speed = 10
var acceleration = 5

var default_animation = 'default down'
var animation = 'down'
var flip = false

var sprite

func get_mouse_degrees(v1, v2):
	var dep = 0
	if v1.x * abs(v2.y) + abs(v2.x) * v1.y > 0:
		pass
	elif v1.x * abs(v2.y) + abs(v2.x) * v1.y < 0:
		v1.x = -v1.x
		v1.y = -v1.y
		dep = 180
	var deg = (v1.x * v2.x + v1.y * v2.y) / (sqrt(v1.x * v1.x + v1.y * v1.y) * sqrt(v2.x * v2.x + v2.y * v2.y))
	deg = rad_to_deg(acos(deg))
	deg += dep
	return round(deg)


func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		var deg = get_mouse_degrees({'x':574 - event.position.x, 'y': 302 - event.position.y}, {'x':-574, 'y':302})
		print(deg)
		if deg > 290 and deg < 360:
			default_animation = "default side"
			flip = false
		elif deg > -1 and deg < 37:
			default_animation = "default sideup"
			flip = false
		elif deg > 36 and deg < 110:
			default_animation = "default up"
			flip = false
		elif deg > 106 and deg < 130:
			default_animation = "default sideup"
			flip = true
		elif deg > 129 and deg < 189:
			default_animation = "default side"
			flip = true
		elif deg > 190 and deg < 290:
			default_animation = "default down"
			flip = true
			

func _process(delta):
	sprite = get_child(2)
	direction = Vector3()
	sprite.set_flip_h(flip)
	if !Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
		sprite.set_animation(default_animation)
	else:
		sprite.set_animation(animation)
		if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
			direction -= transform.basis.x
			direction -= transform.basis.z
		elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
			direction += transform.basis.x
			direction -= transform.basis.z
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
			direction -= transform.basis.x
			direction += transform.basis.z
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
			direction += transform.basis.x
			direction += transform.basis.z
		else:
			if Input.is_action_pressed("ui_down"):
				direction += transform.basis.z
			if Input.is_action_pressed("ui_up"):
				direction -= transform.basis.z
			if Input.is_action_pressed("ui_left"):
				direction -= transform.basis.x
			if Input.is_action_pressed("ui_right"):
				direction += transform.basis.x
	direction = direction.normalized()
	velocity = direction * speed
	velocity.lerp(velocity, acceleration * delta)
	set_velocity(velocity)
	set_up_direction(Vector3.UP)
	move_and_slide()
