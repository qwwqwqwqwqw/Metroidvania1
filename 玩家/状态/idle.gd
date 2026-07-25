class_name PlayerstateIdle  extends PlayerState

func init() -> void:
	print("init!idle")
	pass
	
#当进入状态是会发生什么	
func enter()-> void:
	print("enter!idle")
	pass
	
#当退出状态时会发生什么	
func exit()-> void:
	print("exit!idle")
	pass


#处理输入发生的事件
func handle_input(_envent: InputEvent)-> PlayerState:
	if _envent.is_action_pressed("left")||_envent.is_action_pressed("right"):
		return $"../run"
	
	return null
	

#状态过程中发生的事
func process(_delta: float)-> PlayerState:
	#print("process:",name,_delta)
	return null
	
#每次物理过程更新时会发生的事情	
func physics_process(_delta: float)-> PlayerState:
	#print("pp:",name)
	return null
