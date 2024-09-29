extends TouchScreenButton

var center_point : Vector2 = Vector2.ZERO
@export var range : float = 16.0

func _ready() -> void:
	if texture_normal != null:
		center_point = global_position + ((texture_normal.get_size() / 2) * scale)
	shape = CircleShape2D.new()
	shape.radius = range
	$point.visibility_mode = visibility_mode

func get_joystick_input() -> Vector2:
	return $point.position.normalized() * ($point.position / range)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		if center_point.distance_to(event.position) < range * (scale.x):
			$point.global_position = event.position - ((texture_normal.get_size() / 2) * scale)
		

func _on_released() -> void:
	$point.position = Vector2.ZERO
