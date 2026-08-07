class_name LightFlicker extends PointLight2D

@export var flicker_intensity: float = 0.1
@export var flicker_frequency: float = 0.2
var og_energy: float = 0.65

func _ready() -> void:
	energy = og_energy
	flicker()
	pass

func flicker() -> void:
	while true:
		var new_value: float = randf_range( -1, 1 ) * flicker_intensity
		energy = og_energy + new_value
		await get_tree().create_timer(flicker_frequency + randf_range(flicker_frequency * -0.3, flicker_frequency * 0.3)).timeout
	pass
