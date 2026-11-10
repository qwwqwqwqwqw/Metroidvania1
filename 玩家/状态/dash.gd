class_name PlayerstateDash  extends PlayerState

const DASH_AUDIO = preload("uid://bke8mc3gwtsdf")

@export var duration: float = 0.25
@export var speed: float = 300.0
@export var effect_delay: float = 0.05
@onready var damage_area: DamageArea = %DamageArea


var dir: float = 1.0
var time: float = 0.0
var effect_time: float = 0.0



func init() -> void:
	#print("init!idle")
	pass
	
#当进入状态是会发生什么	
func enter()-> void:
	#print("enter!idle")
	time = duration
	effect_time = 0.0
	get_dash_dir()
	player.animation_player.play("dash")
	damage_area.make_invulnerable(duration)
	Audio.play_spatial_sound(DASH_AUDIO, player.global_position);
	
	player.sprite_2d.tween_color()
	pass
	
#当退出状态时会发生什么	
func exit()-> void:
	if player.dash_charges < player.MAX_DASH_CHARGES \
			and player.dash_recharge_remaining <= 0.0:
		player.dash_recharge_remaining = player.dash_recharge_time
	pass


#处理输入发生的事件
func handle_input(event: InputEvent)-> PlayerState:
	if event.is_action_pressed("attack"):
		return attack
	if event.is_action_pressed("jump") and player.jumpTimes > 0:
		return jump
	return null
	
	

#状态过程中发生的事
func process(_delta: float)-> PlayerState:
	effect_time -= _delta
	if effect_time <= 0.0:
		player.sprite_2d.spawn_dash_afterimage(duration)
		effect_time = effect_delay

	if time > 0:
		time -= _delta
	else:
		return idle
	
	return null
	
#每次物理过程更新时会发生的事情	
func physics_process(_delta: float)-> PlayerState:
	player.velocity.x = speed * dir

	return nextState


func get_dash_dir() -> void:
	dir = 1.0
	if player.sprite_2d.flip_h:
		dir = -1.0
	pass
