class_name PlayerstateFall  extends PlayerState


 
func init() -> void:
	print("init!fall")
	pass
	
#当进入状态是会发生什么	
func enter()-> void:
	print("enter!fall")
	player.animation_player.play("jump")
	player.animation_player.pause()
	pass
	
#当退出状态时会发生什么	
func exit()-> void:
	print("exit!fall")
	pass


#处理输入发生的事件
func handle_input(event: InputEvent)-> PlayerState:
	if !player.is_on_floor() and player.jumpTimes > 0 and event.is_action_pressed("jump"):
		return jump
		
		
	
	
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
		#player.add_debug_indicator(Color.RED)
		return idle
	player.velocity.x = player.direction.x * player.move_speed
	return null
	
func set_jump_frame() -> void:
	var frame: float = remap(player.velocity.y, 0.0, player.max_fall_speed, 0.5, 1.0)
	player.animation_player.seek(frame, true)
	pass
