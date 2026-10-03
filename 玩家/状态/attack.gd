class_name PlayerStateAttack extends PlayerState

const ATTACK = preload("uid://b7g1vx404jurq")
@export var combo_time_window: float = 0.2
@export var speed: float = 150
@export var attack_deceleration_rate: float=5.0
var timer: float = 0
var combo: int = 0

@onready var attack_sprite_2d: Sprite2D = %AttackSprite2D




func init() -> void:
	#print("init!idle")
	attack_sprite_2d.visible = false
	pass
	
#当进入状态是会发生什么	
func enter()-> void:
	
	do_attack()
	player.animation_player.animation_finished.connect(_on_animation_finished)
	pass
	
#当退出状态时会发生什么	
func exit()-> void:
	#print("exit!idle")
	timer = 0
	combo = 0
	player.animation_player.animation_finished.disconnect(_on_animation_finished)
	nextState = null
	attack_sprite_2d.visible = false
	pass


#处理输入发生的事件
func handle_input(event: InputEvent)-> PlayerState:
	if player.jumpTimes > 0 and event.is_action_pressed("jump"):
		return jump
	if event.is_action_pressed("attack"):
		timer = combo_time_window
	

	return null
	
	

#状态过程中发生的事
func process(_delta: float)-> PlayerState:
	timer -= _delta
	return nextState
	
#每次物理过程更新时会发生的事情	
func physics_process(_delta: float)-> PlayerState:
	#print("pp:",name)
	#if !player.is_on_floor():
		#return fall
	player.velocity.x = player.move_speed * player.direction.x
	

	return null

func do_attack() -> void:
	match combo:
		0:player.animation_player.play("attack")
		1:player.animation_player.play("attack_2")
	player.attack_area.activate()
	Audio.play_spatial_sound(ATTACK, player.global_position)
	
	pass


func _on_animation_finished(_anim_name: String) -> void:
	_end_attack()
	pass

func _end_attack() ->void:
	if timer > 0:
		combo = wrapi(combo + 1, 0, 2)
		do_attack()
	elif player.is_on_floor():
		nextState = idle
	else:
		nextState = fall
	pass
