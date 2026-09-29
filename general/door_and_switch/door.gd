@tool
@icon("res://general/ions/door.svg")
class_name Door extends Node2D

const DOOR_CRASH_AUDIO = preload("uid://4y0lgvace3u3")

@export var unique_name: String = ""

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if unique_name.is_empty():
		_generate_unique_name()

	var saved_state: String = SaveManager.persistent_data.get_or_add(unique_name, "closed")
	var start_open: bool = saved_state == "open"
	_set_door_pose(start_open)

	for c in get_children():
		if c is Switch:
			c.set_open(saved_state == "open")
			c.activated.connect(_on_switch_activated)
pass

func _on_switch_activated(is_open: bool) -> void:
	SaveManager.persistent_data[unique_name] = "open" if is_open else "closed"
	_play_transition(is_open)

func _play_transition(is_open: bool) -> void:
	var speed: float = 1.0 if is_open else -1.0
	animation_player.speed_scale = 1.0
	animation_player.play(&"open", -1.0, speed, not is_open)

func _set_door_pose(is_open: bool) -> void:
	animation_player.speed_scale = 1.0
	animation_player.play(&"open")
	animation_player.seek(animation_player.current_animation_length if is_open else 0.0, true)
	animation_player.pause()

func _generate_unique_name() -> void:
	var scene_root: Node = owner if owner else get_tree().current_scene
	if scene_root and not scene_root.scene_file_path.is_empty():
		unique_name = scene_root.scene_file_path + "/" + str(scene_root.get_path_to(self))
	else:
		unique_name = str(get_path())

func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_switch() == false:
		return ["需要一个开关节点"]
	return []

func _check_for_switch() -> bool:
	for c in get_children():
		if c is Switch:
			return true
	return false
