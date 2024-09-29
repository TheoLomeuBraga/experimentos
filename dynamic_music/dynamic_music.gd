extends Node


@export var audio_players : Array[AudioStreamPlayer]
func _ready() -> void:
	for c in audio_players:
		c.play()



func _process(delta: float) -> void:
	pass
	
	
 


func _on_h_slider_value_changed(value: float) -> void:
	var i : int = 0
	for c in audio_players:
		if value > i:
			c.volume_db = 0
		else:
			c.volume_db = -80
		i+=1
	
