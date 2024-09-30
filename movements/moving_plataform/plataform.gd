extends Node3D







var last_pos := Vector3.ZERO
var bodys : Array[CharacterBody3D]

func _process(delta: float) -> void:
	$AnimationPlayer.play("move_up_down")
	for b in bodys:
		b.position += $MeshInstance3D.position - last_pos
		b.position.y -= 1 * delta
		
	last_pos = $MeshInstance3D.position

func _on_area_3d_body_entered(body: Node3D) -> void:
	bodys.push_back(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	bodys.erase(body)
