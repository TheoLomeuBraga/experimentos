extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control.visible = OS.get_name() == "Android" or OS.get_name() == "iOS"
	pass


var rotate_dir : float = 0.0


func _process(delta: float) -> void:
	if not (OS.get_name() == "Android" or OS.get_name() == "iOS"):
		if Input.is_action_pressed("ui_left"):
			rotate_dir = -1
		elif Input.is_action_pressed("ui_right"):
			rotate_dir = 1
		else:
			rotate_dir = 0
	$base_camera.rotation.y += rotate_dir * delta 
	



func _on_l_button_down() -> void:
	rotate_dir = -1

func _on_l_button_up() -> void:
	rotate_dir = 0

func _on_r_button_down() -> void:
	rotate_dir = 1

func _on_r_button_up() -> void:
	rotate_dir = 0


var analog_folowing : bool = false






func _on_button_button_down() -> void:
	analog_folowing = true


func _on_button_button_up() -> void:
	analog_folowing = false
