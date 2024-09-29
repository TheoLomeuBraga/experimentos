extends Node3D

enum input_devices {
	keyboard = 0,
	joystick_1 = 1,
	joystick_2 = 2,
}
@export var input_device : input_devices

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	rotation_degrees.y += Input.get_axis("look_right_" + str(input_device),"look_left_" + str(input_device)) * delta * 60
