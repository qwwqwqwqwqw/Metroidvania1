@tool
@icon("res://general/ions/level_bounds.svg")
class_name  LevelBounds extends Node2D

@export_range(480, 8192, 32, "suffix: px") var width: int=480 : set = _on_width_changed
@export_range(270, 8192, 32, "suffix: px") var height: int=270 : set = _on_height_changed

func _ready() -> void:
	#处理Z轴索引
	z_index=256
	
	if Engine.is_editor_hint():
		return
	
	var carmera: Camera2D = null
	
	while not carmera:
		await  get_tree().process_frame
		carmera = get_viewport().get_camera_2d()
	
	carmera.limit_left=int(global_position.x)
	carmera.limit_top=int(global_position.y)
	carmera.limit_right=int(global_position.x) + width
	carmera.limit_bottom=int(global_position.y) + height
	#查找并获得对摄像机的引用
	
	
	
	#更新摄像机啊的范围
	pass



func _draw() -> void:
	if Engine.is_editor_hint():
		#画一个框
		var r: Rect2=Rect2(Vector2.ZERO,Vector2(width, height))
		draw_rect(r, Color(0.0,0.45,1.0), false, 3)
	pass


func _on_width_changed(new_width : int) -> void:
	width = new_width
	queue_redraw()
	pass


func _on_height_changed(new_height : int) -> void:
	height = new_height
	queue_redraw()
	pass
