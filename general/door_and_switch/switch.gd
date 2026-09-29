@icon("res://general/ions/switch.svg")
class_name Switch extends Node2D


signal activated(is_open: bool)

const DOOR_SWITCH_AUDIO = preload("uid://cg5abwk3g2nu5")

var is_open: bool = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D
@onready var door: Door = get_parent() as Door

func _ready() -> void:
	if door == null:
		push_error("Switch 必须作为 Door 的子节点")
		return

	area_2d.body_entered.connect(_on_player_entered)
	area_2d.body_exited.connect(_on_player_exited)

func _on_player_entered(_n: Node2D) -> void:
	Messages.input_hint_changed.emit("interact")
	if not Messages.player_interacted.is_connected(_on_player_interacted):
		Messages.player_interacted.connect(_on_player_interacted)


func _on_player_interacted(_player: Node2D) -> void:
	set_open(!is_open)
	activated.emit(is_open)

func set_open(value: bool) -> void:
	is_open = value
	sprite_2d.flip_h = is_open

func _on_player_exited(_n: Node2D) -> void:
	Messages.input_hint_changed.emit("")
	if Messages.player_interacted.is_connected(_on_player_interacted):
		Messages.player_interacted.disconnect(_on_player_interacted)
