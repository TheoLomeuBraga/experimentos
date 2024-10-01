extends CharacterBody3D



func _ready() -> void:
	pass # Replace with function body.

var state := 0


@export var floor_speed := 600.0
@export var rotation_speed := 50.0

var fall_time := 1.0
func floor_state(delta: float) -> void:
	var input_dir := Vector3(0.0,0.0,Input.get_axis("ui_down","ui_up"))
	input_dir = (basis.x * input_dir.x) + (basis.z * input_dir.z)
	
	if $RayCastFloor.is_colliding():
		input_dir = input_dir.slide($RayCastFloor.get_collision_normal()).normalized()
	elif $ShapeCastFloor.is_colliding():
		input_dir = input_dir.slide($ShapeCastFloor.get_collision_normal(0)).normalized()
	
	velocity = -input_dir * delta * floor_speed
	
	rotation_degrees.y += Input.get_axis("ui_right","ui_left") * rotation_speed * delta
	
	if Input.is_action_just_pressed("ui_accept"):
		fall_time = 0.0
		state = 1
	
	if not $ShapeCastFloor.is_colliding() and not $RayCastFloor.is_colliding():
		fall_time = 0.5
		state = 1
	
	velocity.y -= 100 * delta

@export var fall_speed := 1200.0
@export var fall_curve : Curve
func air_state(delta: float) -> void:
	
	var input_dir := Vector3(Input.get_axis("ui_right","ui_left"),0.0,Input.get_axis("ui_down","ui_up"))
	input_dir = (basis.x * input_dir.x) + (basis.z * input_dir.z)
	velocity = -input_dir * delta * floor_speed
	
	velocity.y = fall_curve.sample(fall_time) * fall_speed * delta
	#rotation_degrees.y += Input.get_axis("ui_right","ui_left") * rotation_speed * delta
	
	if $ShapeCastFloor.is_colliding() and $RayCastFloor.is_colliding() and fall_curve.sample(fall_time) < 0:
		state = 0
	
	if $ShapeCastCealing.is_colliding() and fall_time < 0.5:
		fall_time = 0.5
	
	fall_time += delta

func _physics_process(delta: float) -> void:
	
	if state == 0:
		floor_state(delta)
	elif state == 1:
		air_state(delta)
	elif state == 2:
		pass
	
	move_and_slide()


func _on_drone_camera_pressed() -> void:
	$OS/drone_camera_window.visible = not $OS/drone_camera_window.visible


func _on_drone_camera_close_requested() -> void:
	$OS/drone_camera_window.visible = false


func _on_drone_status_window_close_requested() -> void:
	$OS/drone_status_window.visible = false


func _on_drone_status_pressed() -> void:
	$OS/drone_status_window.visible = not $OS/drone_status_window.visible
