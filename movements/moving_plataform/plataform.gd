extends Node3D





func _process(delta: float) -> void:
	$AnimationPlayer.play("move_up_down")


var block_adoption : bool = false
func _on_area_3d_body_entered(body: Node3D) -> void:
	
	var gpos := body.global_position
	
	for c in $MeshInstance3D.get_children():
		if c == body:
			return
	
	body.get_parent().remove_child(body)
	$MeshInstance3D.add_child(body)
	body.global_position = gpos
	block_adoption = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if not block_adoption:
		var gpos := body.global_position
		
		for c in get_tree().get_root().get_children():
			if c == body:
				return
		
		body.get_parent().remove_child(body)
		get_tree().get_root().add_child(body)
		body.global_position = gpos
	else:
		block_adoption = false
