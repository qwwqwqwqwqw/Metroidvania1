class_name PlayerSprite extends Sprite2D

var tween: Tween
var _afterimage_tween: Tween

func _ready() -> void:
	pass


func tween_color(duration: float = 0.5, color: Color = Color(0.15, 0.85, 1.0, 1.0)) -> void:
	
	if tween:
		tween.kill()
	modulate = color
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, duration)
	pass


func reset_color() -> void:
	if tween:
		tween.kill()
	modulate = Color.WHITE
	pass


func spawn_afterimage(
	duration: float = 0.2,
	color: Color = Color(0.35, 0.8, 1.0, 0.65)
) -> void:
	if duration <= 0.0 or texture == null:
		return

	var player_node := get_parent() as Node2D
	if player_node == null:
		return

	var ghost := Sprite2D.new()
	ghost.texture = texture
	ghost.hframes = hframes
	ghost.vframes = vframes
	ghost.frame = frame
	ghost.flip_h = flip_h
	ghost.flip_v = flip_v
	ghost.centered = centered
	ghost.offset = offset
	ghost.z_index = z_index + 1
	ghost.modulate = color

	player_node.add_child(ghost)
	ghost.top_level = true
	ghost.global_transform = global_transform

	var fade_tween := ghost.create_tween()
	fade_tween.tween_property(ghost, "modulate:a", 0.0, duration)
	fade_tween.tween_callback(ghost.queue_free)
	pass


func spawn_dash_afterimage(duration: float = 0.2) -> void:
	spawn_afterimage(duration, Color(0.35, 0.8, 1.0, 0.65))
