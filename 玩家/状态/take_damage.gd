class_name PlayerstateTakeDamage  extends PlayerState

@export var move_speed: float = 100
@export var invulnerable_duration: float = 0.5


func init() -> void:
	#print("init!idle")
	pass
	
#当进入状态是会发生什么	
func enter()-> void:
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
	return null
	
#每次物理过程更新时会发生的事情	
func physics_process(_delta: float)-> PlayerState:

	return null
