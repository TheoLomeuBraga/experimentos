extends CharacterBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/camera_base.global_position = global_position
	$Control/camera_base.rotation = rotation
	pass


func manage_camera(delta: float) -> void:
	$Control/camera_base.global_position = lerp($Control/camera_base.global_position,global_position,delta * 10)

var state := 0
#0 = floor
#1 = air
#2 = ledge

@export var floor_speed := 600.0
var fall_time := 1.0
func floor_state(delta: float) -> void:
	
	fall_time = 1
	
	var direction : Vector3
	direction.x = Input.get_axis("ui_right","ui_left")
	
	if $RayCastFloor.is_colliding():
		direction = direction.slide($RayCastFloor.get_collision_normal()).normalized()
	elif $ShapeCastFloor.is_colliding():
		direction = direction.slide($ShapeCastFloor.get_collision_normal(0)).normalized()
	
	velocity = direction * floor_speed * delta
	
	if direction.x > 0:
		$display_model.rotation_degrees.y = 180
	elif direction.x < 0:
		$display_model.rotation_degrees.y = 0
	
	velocity.y -= 100 * delta
	
	if not $RayCastFloor.is_colliding() or not $ShapeCastFloor.is_colliding():
		state = 1
		fall_time = 0.5
	
	if Input.is_action_just_pressed("ui_up"):
		fall_time = 0
		state = 1


@export var fall_speed := 1200.0
@export var fall_curve : Curve
var jumping := false
func air_state(delta: float) -> void:
	fall_time += delta
	velocity.y = fall_curve.sample(fall_time) * delta * fall_speed
	
	velocity.x = Input.get_axis("ui_right","ui_left") * floor_speed * delta
	
	
	if fall_curve.sample(fall_time) < 0 and $RayCastFloor.is_colliding() and $ShapeCastFloor.is_colliding():
		state = 0
	
	var on_ledge := false
	if velocity.x > 0:
		$display_model.rotation_degrees.y = 180
		on_ledge = $ledje_detector/L.is_colliding()
	elif velocity.x < 0:
		$display_model.rotation_degrees.y = 0
		on_ledge = $ledje_detector/R.is_colliding()
	
	
	if fall_curve.sample(fall_time) < 0 and on_ledge:
		state = 2
		velocity = Vector3.ZERO
	
	if $ShapeCastCealing.is_colliding() and fall_time < 0.5:
		fall_time = 0.5

func ledge_state(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_up"):
		fall_time = 0
		state = 1

func _physics_process(delta: float) -> void:
	manage_camera(delta)
	
	
	
	
	if state == 0:
		floor_state(delta)
	elif state == 1:
		air_state(delta)
	elif state == 2:
		ledge_state(delta)
	
	move_and_slide()
