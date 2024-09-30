extends CharacterBody3D



func _ready() -> void:
	$Control/camera_base.global_position = global_position
	$Control/camera_base.rotation_degrees = rotation_degrees + Vector3(0,90,0)
	pass


func manage_camera(delta: float) -> void:
	$Control/camera_base.global_position = lerp($Control/camera_base.global_position,global_position,delta * 10)

var state := 0
#0 = floor
#1 = air
#2 = ledge

@export var floor_speed := 600.0
@export var rotation_speed := 5.0

var fall_time := 1.0

func floor_state(delta: float) -> void:
	var input_dir := Vector3(Input.get_axis("ui_down","ui_up"),0.0,Input.get_axis("ui_left","ui_right"))
	input_dir = ($Control/camera_base.basis.x * input_dir.x) + ($Control/camera_base.basis.z * input_dir.z)
	
	if $RayCastFloor.is_colliding():
		input_dir = input_dir.slide($RayCastFloor.get_collision_normal()).normalized()
	elif $ShapeCastFloor.is_colliding():
		input_dir = input_dir.slide($ShapeCastFloor.get_collision_normal(0)).normalized()
	
	velocity = -input_dir * delta * floor_speed
	
	if input_dir != Vector3.ZERO:
		var chande_rotation_degrees_y := rotation_degrees.y
		
		
		var dir := input_dir
		dir.y = 0
		look_at(global_position + dir)
		rotation_degrees.y += 90
		
		chande_rotation_degrees_y = chande_rotation_degrees_y - rotation_degrees.y
		
	
	if Input.is_action_just_pressed("ui_accept"):
		fall_time = 0.0
		state = 1
	
	if not $ShapeCastFloor.is_colliding() and not $RayCastFloor.is_colliding() :
		fall_time = 0.5
		state = 1
	
	velocity.y -= 100 * delta

@export var fall_speed := 1200.0
@export var fall_curve : Curve
func air_state(delta: float) -> void:
	velocity.y = fall_curve.sample(fall_time) * fall_speed * delta
	fall_time += delta
	if $ShapeCastFloor.is_colliding() and $RayCastFloor.is_colliding() and fall_curve.sample(fall_time) < 0:
		state = 0
	
	var input_dir := Vector3(Input.get_axis("ui_down","ui_up"),0.0,Input.get_axis("ui_left","ui_right"))
	input_dir = ($Control/camera_base.basis.x * input_dir.x) + ($Control/camera_base.basis.z * input_dir.z)
	velocity.x = -input_dir.x * delta * floor_speed 
	velocity.z = -input_dir.z * delta * floor_speed

func _process(delta: float) -> void:
	manage_camera(delta)
	
	if state == 0:
		floor_state(delta)
	elif state == 1:
		air_state(delta)
	elif state == 2:
		pass
	
	move_and_slide()
