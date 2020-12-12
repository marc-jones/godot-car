extends Node2D

# Wheel rotation limit
var max_steering_rotation = 30.0
# Wheel movement speed
var steering_rotation_speed = 100.0
# Distance between the two axis
var axis_diff = 130.0
# Speed limits
var max_forward_speed = 800.0
var max_reverse_speed = 300.0
# Acceleration
var forward_acceleration = 1000.0
var reverse_acceleration = 1000.0
# Drag when no buttons are pressed
var drag = 500.0

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
	position += (Vector2(0, -1).rotated(rotation)
		* speed * delta)
	rotation += asin(speed * delta *
		sin(steering_rotation* PI / 180.0) / axis_diff)

func update_tyre_rotation():
	$TyreL.set_rotation(steering_rotation * PI / 180)
	$TyreR.set_rotation(steering_rotation * PI / 180)
