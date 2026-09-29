class_name PauseMenu extends CanvasLayer
#region
@onready var pause_screen: Control = %PauseScreen
@onready var system: Control = %System
@onready var system_menu_button: Button = %SystemMenuButton
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var ui_slider: HSlider = %UISlider
@onready var back_to_map: Button = %BackToMap
@onready var back_to_tile: Button = %BackToTile
@onready var v_box_container: VBoxContainer = $Control/System/VBoxContainer

#endregion



var player: Player

func _ready() -> void:
	#暂停玩家
	show_pause_screen()
	system_menu_button.pressed.connect(show_system_menu)
	Audio.setup_button_audio(self)
	#显示地图
	set_systems_menu()
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()
	if pause_screen.visible:
		if event.is_action_pressed("right") or event.is_action_pressed("left"):
			system_menu_button.grab_focus()
	pass

func show_pause_screen() -> void:
	pause_screen.visible = true;
	system.visible = false;
	
	pass

func show_system_menu() -> void:
	pause_screen.visible = false;
	system.visible = true;
	back_to_map.grab_focus()
	pass


func set_systems_menu() -> void:
	back_to_tile.pressed.connect(_on_back_to_title_pressed)
	back_to_map.pressed.connect(show_pause_screen)
	pass


func _on_back_to_title_pressed() -> void:
	#释放玩家
	SceneManager.transition_scene("res://title_scream/title_scream.tscn","",Vector2.ZERO,"up")
	get_tree().paused = false
	Messages.back_to_title_screen.emit()
	queue_free()
	pass
