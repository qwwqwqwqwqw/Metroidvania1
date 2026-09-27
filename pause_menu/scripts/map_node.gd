@tool
@icon("res://general/ions/map_node.svg")
class_name MapNode extends Control

const SCALE_FACTOR: float = 10

@export_file("*.tscn") var linked_scene: String: set = _on_scene_set
@export_tool_button("update") var update_node_action = update_node
@export var entrances_top: Array[float] = []
@export var entrances_bottom: Array[float] = []
@export var entrances_right: Array[float] = []
@export var entrances_left: Array[float] = []

#指示器
@export var indicator_offset: Vector2 = Vector2.ZERO

@onready var label: Label = $Label
@onready var transition_blocks: Control = %TransitionBlocks


func _ready() -> void:
	if Engine.is_editor_hint():
		pass
	else:
		label.queue_free()
		#创建过渡效果区块
		create_transition_blocks()
		#检查是否已经探索到了地图
		if not SaveManager.is_area_discovered(linked_scene):
			self.visible = false
		elif SceneManager.current_scene_uid == linked_scene:
			display_player_location()
	pass

func _on_scene_set(value: String) -> void:
	if linked_scene != value:
		linked_scene = value
		if Engine.is_editor_hint():
			update_node()
	pass


func update_node() -> void:
	#地图框大小
	var new_size: Vector2 = Vector2(480,270)
	#地图过渡区块数组
	var transitions: Array[LevelTransition] = []
	
	if ResourceLoader.exists(linked_scene):
		var packed_scene: PackedScene = ResourceLoader.load(linked_scene) as PackedScene
		if packed_scene:
			var instance = packed_scene.instantiate()
			if instance:
				update_node_lable(instance)
				for c in instance.get_children():
					if c is LevelBounds:
						new_size = Vector2(c.width,c.height)
						indicator_offset = c.position
						pass
					elif c is LevelTransition:
						transitions.append(c)
						pass
					instance.queue_free()
	size = new_size / SCALE_FACTOR
	size = size.round()
	create_entrance_data(transitions)
	create_transition_blocks()
	pass


func update_node_lable(scene: Node) -> void:
	if not label:
		label = $Label
	var t: String = scene.scene_file_path
	t = t.replace("res//levels/","")
	t = t.replace(".tscn","")
	label.text = t
		
	pass


func create_entrance_data(transitions: Array[LevelTransition]) -> void:
	entrances_bottom.clear()
	entrances_left.clear()
	entrances_right.clear()
	entrances_top.clear()
	for t in transitions:
		var pos: Vector2 = (t.position - indicator_offset)/SCALE_FACTOR
		if t.location == LevelTransition.SIDE.LEFT:
			var offset: float = clampf(
				pos.y - 1,
				10,self.size.y - 20
			)
			entrances_left.append(offset)
		elif t.location == LevelTransition.SIDE.RIGHT:
			var offset: float = clampf(
				pos.y - 1,
				10,self.size.y - 20
			)
			entrances_right.append(offset)
		elif t.location == LevelTransition.SIDE.TOP:
			var offset: float = clampf(
				pos.x,
				10,self.size.x - 20
			)
			entrances_top.append(offset)
		elif t.location == LevelTransition.SIDE.BOTTOM:
			var offset: float = clampf(
				pos.x,
				10,self.size.x - 20
			)
			entrances_bottom.append(offset)
	pass

func create_transition_blocks() -> void:
	if not transition_blocks:
		transition_blocks = %TransitionBlocks
	for c in transition_blocks.get_children():
		c.queue_free()
	
	for t in entrances_left:
		var block: ColorRect = add_block()
		block.size.y = 15
		block.position = Vector2(0,t)
	for t in entrances_right:
		var block: ColorRect = add_block()
		block.size.y = 15
		block.position = Vector2(self.size.x - 5,t)
	for t in entrances_top:
		var block: ColorRect = add_block()
		block.size.x = 15
		block.position = Vector2(t,0)
	for t in entrances_bottom:
		var block: ColorRect = add_block()
		block.size.x = 15
		block.position = Vector2(t,self.size.y - 5)
	pass


func add_block() -> ColorRect:
	var block: ColorRect = ColorRect.new()
	transition_blocks.add_child(block)
	block.custom_minimum_size = Vector2(5.0,5.0)
	return block

func display_player_location() -> void:
	#获得玩家位置
	var player: Player = get_tree().get_first_node_in_group("Player")
	var i: Control = get_parent().get_node_or_null("PlayerIndicator") as Control
	#添加玩家指示器
	var map_scale := scale
	var map_display_size := size * map_scale
	var world_offset := player.global_position - indicator_offset
	var target := position + (world_offset / SCALE_FACTOR) * map_scale
	var marker := i.get_node_or_null("TextureRect") as Control
	var marker_half_size := marker.size * 0.5 if marker else Vector2.ZERO

	target.x = clampf(
		target.x,
		position.x + marker_half_size.x,
		position.x + map_display_size.x - marker_half_size.x
	)
	target.y = clampf(
		target.y,
		position.y + marker_half_size.y,
		position.y + map_display_size.y - marker_half_size.y
	)

	i.position = target
	#显示玩家指示器
	pass
