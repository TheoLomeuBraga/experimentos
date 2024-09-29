extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = "X: " + str($VirtualJoystick.get_joystick_input().x) + "\n Y: " + str($VirtualJoystick.get_joystick_input().y)


func _on_touch_screen_button_pressed() -> void:
	print("A")


func _on_touch_screen_button_2_pressed() -> void:
	print("B")
