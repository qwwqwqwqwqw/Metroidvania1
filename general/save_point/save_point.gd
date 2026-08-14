@icon("res://general/ions/save_point.svg")
class_name SavePoint extends Node2D


@onready var animation_player: AnimationPlayer = $Node2D/AnimationPlayer
@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	area_2d.body_entered.connect(_on_player_entered)
	area_2d.body_exited.connect(_on_player_exited)
	pass


func _on_player_entered(_n: Node2D) -> void:
	Messages.player_interacted.connect(_on_player_interacted)
	Messages.input_hint_changed.emit("interact")
	pass


func _on_player_exited(_n: Node2D) -> void:
	Messages.player_interacted.disconnect(_on_player_interacted)
	Messages.input_hint_changed.emit("")
	pass


func _on_player_interacted(player: Player) -> void:
	print("玩家交互了")
	#保存游戏
	var scene_path = owner.scene_file_path
	SaveManager.save_game()
	#治愈玩家
	Messages.player_healed.emit(999)
	#播放动画
	animation_player.play("game_saved")
	animation_player.seek( 0 )
	#播放音频
	pass
