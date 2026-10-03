@icon("res://general/ions/attack_area.svg")
class_name AttackArea extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var damage: float = 1.0


func _ready() -> void:
	#body_entered.connect(_on_body_entered)
	area_entered.connect(_on_body_entered)
	visible = false
	monitorable = false
	monitoring = false
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is DamageArea:
		body.take_damage(self)
		var pos: Vector2 = global_position
		pos.x = clampf(global_position.x + scale.x * collision_shape_2d.shape.size.x, body.global_position.x - body.collision_shape_2d_2.shape.size.x/2, body.global_position.x + body.collision_shape_2d_2.shape.size.x/2)
		VisualEffects.hit_dust(pos)
		pass
	
	pass


func activate(duration: float = 0.1) -> void:
	set_active()
	await get_tree().create_timer(duration).timeout
	set_active(false)
	pass


func set_active(value: bool = true) -> void:
	visible = value
	monitoring = value
	pass


func flip(direction_x: float) -> void:
	if direction_x > 0:
		scale.x = 1
	elif direction_x < 0:
		scale.x = -1
	
	pass
