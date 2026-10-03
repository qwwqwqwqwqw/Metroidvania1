class_name PlayerstateRun  extends PlayerState


func init() -> void:
	#print("init!run")
	pass
	
#当进入状态是会发生什么	
func enter()-> void:
	#print("enter!run")
	player.animation_player.play("run")
	player.jumpTimes = 2
	pass
	
#当退出状态时会发生什么	
func exit()-> void:
	#print("exit!run")
	pass


#处理输入发生的事件
func handle_input(event: InputEvent)-> PlayerState:
	if event.is_action_pressed("attack"):

		return attack
	if event.is_action_pressed("jump"):
		return jump
	
	
	return null
	

#状态过程中发生的事
func process(_delta: float)-> PlayerState:
	#print("process:",name,_delta)
	if player.direction.x == 0:
		return idle
	elif player.direction.y > 0.5:
		return crouch
	return null
	
#每次物理过程更新时会发生的事情	
func physics_process(_delta: float)-> PlayerState:
	#print("pp:",name)
	if player.direction.x != 0:
		player.velocity.x=player.direction.x * player.move_speed
		
	if !player.is_on_floor():
		return fall
	return null
