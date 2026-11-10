class_name PlayerSprite extends Sprite2D

var tween: Tween
var _afterimage_tween: Tween

func _ready() -> void:
	pass


func tween_color(duration: float = 0.5, color: Color = Color(0.0, 1.5, 0.95)) -> void:
	
	if tween:
		tween.kill()
	modulate = color
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, duration)
	pass


func spawn_dash_afterimage(duration: float = 0.2) -> void:
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
	ghost.z_index = z_index + 1
	ghost.modulate = Color(1.0, 0.2, 0.2, 0.8)

	player_node.add_child(ghost)
	ghost.global_position = global_position
	ghost.global_rotation = global_rotation
	ghost.top_level = true

	var fade_tween := ghost.create_tween()
	fade_tween.tween_property(ghost, "modulate:a", 0.0, duration)
	fade_tween.tween_callback(ghost.queue_free)
	pass
