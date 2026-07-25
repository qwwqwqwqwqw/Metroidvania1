class_name  Player extends CharacterBody2D


#代码区域：状态机所需要的值
var states: Array[PlayerState]
var currentState: PlayerState:
	get: return states.front()
var previousState: PlayerState:
	get: return states[1]
#代码区域结束

#代码区域：标准变量
var direction: Vector2=Vector2.ZERO
var gravity: float=980
#代码区域结束

func _ready() -> void:
	
	#初始化状态
	init_states()
	
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	
	change_state(currentState.handle_input(event))
	
	pass


func _process(_delta: float) -> void:
	
	change_state(currentState.process(_delta))
	
	pass

func _physics_process(_delta: float) -> void:
	
	velocity.y+=gravity*_delta
	move_and_slide()
	change_state(currentState.physics_process(_delta))
	
	
	
	pass


func init_states()-> void:
	
	states=[]
	#收集所有的状态
	for s in $States.get_children():
		if s is PlayerState:
			s.player=self
			states.append(s)

		pass
	print(states)
	
	if states.size()==0:
		return
	
	#初始化所有状态
	for state in states:
		state.init()
		
	
	
	#设置我们的第一个状态
	change_state(currentState)
	currentState.enter()
	
	pass
	
	
func change_state(new_state: PlayerState)->void:
	if new_state==null:
		return
	elif new_state==currentState:
		return
	if currentState:
		currentState.exit()
	
	states.push_front(new_state)
	currentState.enter()
	states.resize(3)
	
	pass
	
	
func update_direction()->void:
	direction=Input.get_vector("left","right","down","up")
	pass
