extends Node3D


func _ready() -> void:
	$template_psx_charter/AnimationTree.set("parameters/walk/blend_position",0.5)


func _process(delta: float) -> void:
	pass
