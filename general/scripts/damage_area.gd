@icon("res://general/ions/damage_area.svg")
class_name DamageArea extends Area2D

@export var particle_settings: HitParticleSettings
signal  damage_taken(attack_area)
@onready var collision_shape_2d_2: CollisionShape2D = _find_collision_shape()

@export var audio: AudioStream


func _find_collision_shape() -> CollisionShape2D:
	# 不同道具场景的碰撞节点命名不统一，这里按类型查找，避免依赖具体节点名。
	for child in get_children():
		if child is CollisionShape2D:
			return child
	return null

func take_damage(attack_area: AttackArea) -> void:
	damage_taken.emit(attack_area)
	if audio:
		Audio.play_spatial_sound(audio,global_position)
	var pos: Vector2 = global_position
	pass



func make_invulnerable(duration: float = 1.0) -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	await  get_tree().create_timer(duration).timeout
	process_mode = Node.PROCESS_MODE_INHERIT
	pass
