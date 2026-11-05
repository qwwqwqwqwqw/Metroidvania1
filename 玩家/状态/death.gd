class_name PlayerstateDeath  extends PlayerState

const DEATH = preload("uid://c8br3eujm6fih")


func init() -> void:
	#print("init!idle")
	pass
	
#当进入状态是会发生什么	
func enter()-> void:
	#print("enter!idle")
	player.animation_player.play("death")
	Audio.play_spatial_sound(DEATH, player.global_position)
	Audio.play_music(null)
	await player.animation_player.animation_finished
	Messages.player_die.emit()
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
	#print("process:",name,_delta)
	return null
	
#每次物理过程更新时会发生的事情	
func physics_process(_delta: float)-> PlayerState:
	#print("pp:",name)
	player.velocity.x = 0
	return null
