extends Node2D

# Wheel rotation limit
var max_steering_rotation = 30.0
# Wheel movement speed
var steering_rotation_speed = 100.0
# How much the speed affects turning
var speed_rotation_factor = 0.01
# Speed limits
var max_forward_speed = 10.0
var max_reverse_speed = 5.0
# Acceleration
var forward_acceleration = 10.0
var reverse_acceleration = 10.0
# Drag when no buttons are pressed
var drag = 5.0

var speed = 0.0
var steering_rotation = 0.0

func _ready():
	pass

func _process(delta):
	var steering_rotation_change = 0.0
	if (Input.is_action_pressed("ui_left") and
		not Input.is_action_pressed("ui_right")):
		steering_rotation_change = -steering_rotation_speed
	elif (Input.is_action_pressed("ui_right") and
		not Input.is_action_pressed("ui_left")):
		steering_rotation_change = steering_rotation_speed
	steering_rotation = clamp(
		steering_rotation+steering_rotation_change*delta,
		-max_steering_rotation, max_steering_rotation)
	update_tyre_rotation()
	if (Input.is_action_pressed("ui_up") and
		not Input.is_action_pressed("ui_down")):
		speed += forward_acceleration * delta
		speed = min(speed, max_forward_speed)
	elif (Input.is_action_pressed("ui_down") and
		not Input.is_action_pressed("ui_up")):
		speed -= reverse_acceleration * delta
		speed = max(speed, -max_reverse_speed)
	else:
		speed += -1 * sign(speed) * drag * delta
	position += Vector2(0, -1).rotated(rotation) * speed
	rotation += (speed_rotation_factor * steering_rotation
		* PI * speed / 180.0)

func update_tyre_rotation():
	$TyreL.set_rotation(steering_rotation * PI / 180)
	$TyreR.set_rotation(steering_rotation * PI / 180)
