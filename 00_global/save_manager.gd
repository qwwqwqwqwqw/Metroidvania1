#保存管理器脚本
extends Node

const SLOTS: Array[String] = [
	"save_01","save_02","save_03"
]

var currrent_slot: int = 0 #存档编号
var save_data: Dictionary
var discovered_areas: Array=[] #探索过的区域
var persistent_data: Dictionary={} #持久性数据


func _ready() -> void:
	await get_tree().process_frame
	#load_game()
	pass

func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_F5:
			save_game(currrent_slot)
		elif event.keycode == KEY_F7:
			load_game(currrent_slot)
		elif event.keycode == KEY_1:
			currrent_slot = 0
		elif event.keycode == KEY_2:
			currrent_slot = 1
		elif event.keycode == KEY_3:
			currrent_slot = 2
	
	pass


func creat_new_game_save(slot: int) -> void:
	change_current_slot(slot)
	var new_game_scene: String = "uid://d1iv3nnkeq0w"
	discovered_areas.append(new_game_scene)
	save_data = {
		"scene_path" : new_game_scene,
		"x" : 148,
		"y" : 250,
		"hp" : 20,
		"max_hp" : 20,
		"double_jump" : false,
		"dash" : false,
		"ground_slam" : false,
		"morph_roll" : false,
		"discovered_areas" : discovered_areas,
		"persistent_data" : persistent_data,
		}
	#保存数据
	var save_file = FileAccess.open(get_file_name(slot),FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	print("存档成功")
	pass

func save_game(slot: int) -> void:
	change_current_slot(slot)
	var player: Player = get_tree().get_first_node_in_group("Player")
	save_data = {
		"scene_path" : SceneManager.current_scene_uid,
		"x" : player.global_position.x,
		"y" : player.global_position.y,
		"hp" : player.hp,
		"max_hp" : player.max_hp,
		"double_jump" : player.double_jump,
		"dash" : player.dash,
		"ground_slam" : player.ground_slam,
		"morph_roll" : player.morph_roll,
		"discovered_areas" : discovered_areas,
		"persistent_data" : persistent_data,
		}
	var save_file = FileAccess.open(get_file_name(slot),FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	print("保存存档成功")
	pass



func load_game(slot: int) -> void:
	change_current_slot(slot)
	if not FileAccess.file_exists(get_file_name(slot)):
		return
	var save_file = FileAccess.open(get_file_name(slot), FileAccess.READ)
	save_data = JSON.parse_string( save_file.get_line() )
	
	persistent_data = save_data.get( "persistent_data", {} )
	discovered_areas = save_data.get( "discovered_areas",[] )
	var scene_path: String = save_data.get( "scene_path", "uid://d1iv3nnkeq0w")
	print(scene_path)
	SceneManager.transition_scene(scene_path, "", Vector2.ZERO, "up")
	await SceneManager.new_scene_ready
	setup_player()
	print("加载存档成功")
	pass


func setup_player() -> void:
	var player: Player = get_tree().get_first_node_in_group("Player")
	# 玩家通过 call_deferred("reparent") 添加到根节点，延迟一帧后必定可用
	if not player:
		await get_tree().process_frame
		player = get_tree().get_first_node_in_group("Player")
	player.hp = save_data.get("hp",20)
	player.max_hp = save_data.get("max_hp",20)
	
	player.global_position = Vector2(
		save_data.get("x", 0),
		save_data.get("y", 0)
	)
	
	player.double_jump = save_data.get("double_jump", false)
	player.ground_slam = save_data.get("ground_slam", false)
	player.dash = save_data.get("dash", false)
	player.morph_roll = save_data.get("morph_roll", false)
	pass


func get_file_name(slot: int) -> String:
	return "user://" + SLOTS[slot] + ".sav"


func save_file_exists(slot: int) -> bool:
	return FileAccess.file_exists(get_file_name(slot))
	
func change_current_slot(slot: int) -> void:
	currrent_slot = slot
	pass


func is_area_discovered(scene_uid: String) -> bool:
	
	return discovered_areas.has(scene_uid)
