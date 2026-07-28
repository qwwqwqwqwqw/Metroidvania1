class_name  Player extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://ca5yc4awm2ua3")


#代码区域：准备就绪
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var one_way_plat_form_shapecast: ShapeCast2D = $OneWayPlatFormShapecast
#代码区域结束




var jumpTimes:int = 1

@export var move_speed: float=150.0
@export var jump_speed: float=450.0
@export var max_fall_speed: float=600.0
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
	self.call_deferred("reparent", get_tree().root)
	
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	
	change_state(currentState.handle_input(event))
	
	pass


func _process(_delta: float) -> void:
	
	change_state(currentState.process(_delta))
	update_direction()
	
	pass

func _physics_process(_delta: float) -> void:
	
	
	if !self.is_on_floor():
		velocity.y+=gravity*_delta
		velocity.y = clamp(velocity.y, -1000.0, max_fall_speed)
	else:
		jumpTimes=1
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
	$Label.text=currentState.name
	
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
	$Label.text=currentState.name
	pass
	
	
func update_direction()->void:
	
	var pre_direction:Vector2 =direction
	
	var x_axis=Input.get_axis("left","right")
	var y_axis=Input.get_axis("up","down")
	direction=Vector2(x_axis,y_axis)
	
	if pre_direction != direction:
		if direction.x < 0:
			sprite_2d.flip_h = true
		elif direction.x > 0:
			sprite_2d.flip_h = false
	
	pass
	


func add_debug_indicator(color: Color=Color.RED)-> void:
	
	var d:Node2D=DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child(d)
	d.global_position = global_position
	d.modulate=color
	await  get_tree().create_timer(3.0).timeout
	d.queue_free() 
	
	pass
