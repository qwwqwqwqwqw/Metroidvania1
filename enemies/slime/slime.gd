@icon("res://general/ions/enemy.svg")
class_name Slime extends CharacterBody2D

@export var health: float = 3
@export var move_speed: float = 30
@export var face_left_on_start: bool = false
@export var death_sound: AudioStream

var dir: float = 1.0
var move_tween: Tween

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hazard_area: HazardArea = $HazardArea
@onready var damage_area: DamageArea = $DamageArea
@onready var edge_detector: EdgeDetector = $EdgeDetector


func _ready() -> void:
	animation_player.play("walk")
	edge_detector.edge_detected.connect(_on_edge_detected)
	pass


func _physics_process(delta: float) -> void:
	
	
	if is_on_wall():
		change_direction(-dir)
	velocity += get_gravity() * delta
	velocity.x = dir * move_speed
	move_and_slide()
	pass


func change_direction(new_dir: float) -> void:
	dir = new_dir
	if dir < 0:
		sprite_2d.flip_h = true
	elif dir > 0:
		sprite_2d.flip_h = false
	pass

func _on_edge_detected() -> void:
	change_direction(-dir)
	pass
