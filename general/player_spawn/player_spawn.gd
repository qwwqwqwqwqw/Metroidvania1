@icon( "res://general/ions/player_spawn.svg" )
class_name PlayerSpawn extends Node2D


func _ready() -> void:
	visible = false
	await get_tree().process_frame
	
	#检查是否存在玩家
	#如果有玩家，无操作
	#如果没有玩家，创建新的玩家实例放在关卡场景的适当位置
	if get_tree().get_first_node_in_group( "Player" ):
		print("玩家存在")
	else:
		print("未找到玩家")
		var player: Player = load("uid://bjtqsoalxyjih").instantiate()
		get_tree().root.add_child(player)
		
		player.global_position = self.global_position
	
	
	
	pass
