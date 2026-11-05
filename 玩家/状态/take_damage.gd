class_name PlayerstateTakeDamage  extends PlayerState

@export var move_speed: float = 100
@export var invulnerable_duration: float = 0.5
var time: float = 0.0
var dir :float = 1.0
@onready var damage_area: DamageArea = %DamageArea
@onready var hurt_audio: AudioStreamPlayer2D = %HurtAudio


func init() -> void:
	#print("init!idle")
	damage_area.damage_taken.connect(_on_damage_taken)
	pass
	
#当进入状态是会发生什么	
func enter()-> void:
	player.animation_player.play("take_damage")
	time = player.animation_player.current_animation_length
	damage_area.make_invulnerable(invulnerable_duration)
	player.start_invulnerability_flash(invulnerable_duration)
	hurt_audio.play()
	player.jumpTimes = 0
	VisualEffects.camera_shake()
	pass
	
#当退出状态时会发生什么	
func exit()-> void:
	#print("exit!idle")
	pass


#处理输入发生的事件
func handle_input(event: InputEvent)-> PlayerState:
	return null
	
	

#状态过程中发生的事
func process(_delta: float)-> PlayerState:
	time -= _delta
	if time <= 0:
		if player.hp <= 0:
			return death
		return idle
	return null
	
#每次物理过程更新时会发生的事情	
func physics_process(_delta: float)-> PlayerState:
	player.velocity.x = move_speed * dir

	return null


func _on_damage_taken(attack_area: AttackArea) -> void:
	if player.currentState == death:
		return
	player.change_state(self)
	if attack_area.global_position.x < player.global_position.x:
		dir = 1.0
	else:
		dir = -1.0
	pass
