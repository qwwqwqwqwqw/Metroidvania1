@icon("res://玩家/状态/state.svg")
class_name PlayerState extends Node

var player: Player
var nextState: PlayerState

#代码区域： 状态引用
@onready var idle:PlayerstateIdle=%idle
@onready var run:PlayerstateRun=%run
@onready var jump:PlayerstateJump=%jump
@onready var fall:PlayerstateFall=%fall
@onready var crouch: PlayerstateCrouch = %crouch

#代码区域

#当状态被初始化是会发生什么
func init() -> void:
	print("init!",name)
	pass
	
#当进入状态是会发生什么	
func enter()-> void:
	print("enter!",name)
	pass
	
#当退出状态时会发生什么	
func exit()-> void:
	print("exit!",name)
	pass


#处理输入发生的事件
func handle_input(_envent: InputEvent)-> PlayerState:
	
	
	
	return null
	

#状态过程中发生的事
func process(_delta: float)-> PlayerState:
	#print("process:",name,_delta)
	return null
	
#每次物理过程更新时会发生的事情	
func physics_process(_delta: float)-> PlayerState:
	#print("pp:",name)
	return null
