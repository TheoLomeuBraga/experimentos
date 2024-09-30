extends BasicMovement



func _ready() -> void:
	$Control/camera_base.global_position = global_position
	$Control/camera_base.rotation.y = rotation.y
	speed = 6.0
	jump_power = 12.0

@export var camera_speed : float = 20
func manage_camera(delta : float) -> void:
	$Control/camera_base.global_position = lerp($Control/camera_base.global_position,global_position,delta * camera_speed)


func movement_plugin(delta : float) -> void:
	manage_camera(delta)
	
	
	move_direction.x = Input.get_axis("ui_right","ui_left")
	
	if move_direction.x > 0:
		$MeshInstance3D.rotation_degrees.y = 180
	if move_direction.x < 0:
		$MeshInstance3D.rotation_degrees.y = 0
	
	if Input.is_action_just_pressed("ui_up") and in_floor:
		jump()
	
	if Input.is_action_just_pressed("ui_down") and not in_floor:
		linear_velocity.y = -25
