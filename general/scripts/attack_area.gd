@icon("res://general/ions/attack_area.svg")
class_name AttackArea extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var damage: float = 1.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_body_entered)
	visible = false
	monitorable = false
	monitoring = false
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is DamageArea:
		body.take_damage(self)
		var pos: Vector2 = global_position
		var attack_half_width := _get_shape_half_width(collision_shape_2d.shape)
		var target_half_width := _get_shape_half_width(body.collision_shape_2d_2.shape)
		pos.x = clampf(
			global_position.x + scale.x * (collision_shape_2d.position.x + attack_half_width),
			body.global_position.x - target_half_width,
			body.global_position.x + target_half_width
		)
		VisualEffects.hit_dust(pos)
		
		pass
	
	pass


func _get_shape_half_width(shape: Shape2D) -> float:
	# 不同目标可能使用不同形状，这里按类型取横向半宽，避免访问不存在的 size 属性。
	if shape is RectangleShape2D:
		return shape.size.x * 0.5
	if shape is CapsuleShape2D:
		return shape.radius
	if shape is CircleShape2D:
		return shape.radius
	if shape is ConvexPolygonShape2D:
		var half_width := 0.0
		for point in shape.points:
			half_width = maxf(half_width, absf(point.x))
		return half_width
	return 0.0


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
