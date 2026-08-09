class_name PlayerstateIdle  extends PlayerState

@export var idle_deceleration_rate: float=5.0

func init() -> void:
	print("init!idle")
	pass
	
#当进入状态是会发生什么	
func enter()-> void:
	print("enter!idle")
	player.animation_player.play("idle")
	player.jumpTimes = 2
	pass
	
#当退出状态时会发生什么	
func exit()-> void:
	print("exit!idle")
	pass


#处理输入发生的事件
func handle_input(event: InputEvent)-> PlayerState:
	if event.is_action_pressed("jump"):
		return jump
	return null
	
	

#状态过程中发生的事
func process(_delta: float)-> PlayerState:
	#print("process:",name,_delta)
	if player.direction.x!=0:
		return run
	elif player.direction.y > 0.5:
		return crouch
	return null
	
#每次物理过程更新时会发生的事情	
func physics_process(_delta: float)-> PlayerState:
	#print("pp:",name)
	if !player.is_on_floor():
		return fall
	player.velocity.x -= idle_deceleration_rate * _delta * player.velocity.x

	return null
