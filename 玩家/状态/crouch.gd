class_name PlayerstateCrouch extends PlayerState

@export var deceleration_rate: float = 10

func init() -> void:
	#print("init!crouch")
	pass
	
#当进入状态是会发生什么	
func enter()-> void:
	#print("enter!crouch")
	player.animation_player.play("crouch")
	player.collision_stand.disabled=true
	player.collision_crouch.disabled=false
	player.jumpTimes = 2
	pass
	
#当退出状态时会发生什么	
func exit()-> void:
	#print("exit!crouch")
	player.collision_stand.disabled=false
	player.collision_crouch.disabled=true

	pass


#处理输入发生的事件
func handle_input(event: InputEvent)-> PlayerState:
	if event.is_action_pressed("attack"):

		return attack
	if event.is_action_pressed("jump"):
		player.one_way_plat_form_shapecast.force_shapecast_update()
		if player.one_way_plat_form_shapecast.is_colliding():
			player.position.y+=4
			return fall
		return jump
	return null
	
	

#状态过程中发生的事
func process(_delta: float)-> PlayerState:
	#print("process:",name,_delta)
	if player.direction.y <= 0.5:
		return idle
	return null
	
#每次物理过程更新时会发生的事情	
func physics_process(_delta: float)-> PlayerState:
	player.velocity.x-= deceleration_rate * _delta * player.velocity.x
	return null
