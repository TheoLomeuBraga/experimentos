extends RigidBody3D
class_name BasicMovement

var sliding_time := 0.0

var in_floor_last_frame : bool = false
var in_floor : bool = false

@export var speed := 3.0

var move_direction_last_frame : Vector3 = Vector3.ZERO
@export var move_direction : Vector3 = Vector3.ZERO

@export var jump_power := 3.0

@export var air_control := false

var juping := false
@export var gravity_control : bool = false
@export var gravity_control_curve : Curve
var juping_progresion := 0.0

func jump() -> void:
	if not gravity_control:
		linear_velocity.y = jump_power
	juping = true
	juping_progresion = 0.0

func move(delta) -> void:
	
	
	
	var new_move_direction : Vector3 = move_direction
	
	in_floor = $floorChekerRay.is_colliding() or $floorChekerShape.is_colliding()
	if in_floor and move_direction != Vector3.ZERO:
		
		if  $floorChekerRay.is_colliding():
			new_move_direction = move_direction.slide($floorChekerRay.get_collision_normal()).normalized()
		elif $floorChekerShape.is_colliding():
			new_move_direction = move_direction.slide($floorChekerShape.get_collision_normal(0)).normalized()
		else:
			new_move_direction = move_direction
	
	if new_move_direction == Vector3.ZERO:
		new_move_direction = move_direction
	
	if air_control and move_direction == Vector3.ZERO:
		linear_velocity.x = 0
		linear_velocity.z = 0
	
	if new_move_direction != Vector3.ZERO:
		new_move_direction = new_move_direction.normalized()
		if sliding_time > 0 or not in_floor:
			if air_control:
				var new_velocity = new_move_direction * speed  * 100 * delta
				new_velocity = new_velocity.normalized() * min(new_velocity.length(), speed)
				linear_velocity.x = new_velocity.x
				linear_velocity.z = new_velocity.z
				physics_material_override.friction = 0
			else:
				var new_velocity = new_move_direction * speed * delta
				new_velocity = new_velocity.normalized() * min(new_velocity.length(), speed)
				apply_impulse(new_velocity)
				physics_material_override.friction = 0
		else:
			var new_velocity = new_move_direction * speed  * 100 * delta
			new_velocity = new_velocity.normalized() * min(new_velocity.length(), speed)
			
			linear_velocity.x = new_velocity.x
			if new_velocity.y < 0 and not juping:
				linear_velocity.y = new_velocity.y - delta
			linear_velocity.z = new_velocity.z
	
	
	if move_direction_last_frame != Vector3.ZERO and move_direction == Vector3.ZERO and not (sliding_time > 0 or not in_floor):
		linear_velocity = Vector3.ZERO
	
	if gravity_control:
		if juping:
			gravity_scale = 0
			juping_progresion += delta
			linear_velocity.y = gravity_control_curve.sample(juping_progresion) * jump_power
		else:
			gravity_scale = 1
	
	
	
	if linear_velocity.y <=0 and in_floor:
		juping = false

	if in_floor:
		sliding_time -= delta
	
	move_direction_last_frame = move_direction
	in_floor_last_frame = in_floor

func _on_body_entered(body) -> void:
	if body is RigidBody3D:
		if body.linear_velocity.length() > 50:
			sliding_time = 1
			physics_material_override.friction = 0
			linear_velocity += (body.linear_velocity * body.mass) / mass



func movement_plugin(delta) -> void:
	pass

func _physics_process(delta) -> void:
	movement_plugin(delta)
	move(delta)
