class_name PlayerstateJump  extends PlayerState



func init() -> void:
	print("init!jump")
	pass
	
#当进入状态是会发生什么	
func enter()-> void:
	print("enter!jump")
	player.animation_player.play("jump")
	player.animation_player.pause()
	#player.add_debug_indicator(Color.AQUAMARINE)
	player.jumpTimes-=1
	player.velocity.y = -player.jump_speed
	pass
	
#当退出状态时会发生什么	
func exit()-> void:
	print("exit!jump")
	#player.add_debug_indicator(Color.LAWN_GREEN)
	pass


#处理输入发生的事件
func handle_input(event: InputEvent)-> PlayerState:
	if event.is_action_released("jump"):
		player.velocity.y *= 0.5
		return fall
	return null
	

#状态过程中发生的事
func process(_delta: float)-> PlayerState:
	#print("process:",name,_delta)
	set_jump_frame()
	return null
	
#每次物理过程更新时会发生的事情	
func physics_process(_delta: float)-> PlayerState:
	#print("pp:",name)
	if player.is_on_floor():
		return idle
	if player.velocity.y >= 0:
		return fall
	player.velocity.x=player.direction.x * player.move_speed
	return null


func set_jump_frame() -> void:
	var frame: float = remap(player.velocity.y, -player.jump_speed, 0.0, 0.0, 0.5)
	player.animation_player.seek(frame, true)
	pass
