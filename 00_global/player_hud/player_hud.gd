#玩家血量条
extends CanvasLayer


@onready var hp_margin_container: MarginContainer = %HPMarginContainer
@onready var h_pbar: TextureProgressBar = %HPbar
@onready var delayed_hp_bar: TextureProgressBar = %DelayedHPbar
@onready var game_over: Control = %GameOver
@onready var load_button: Button = %LoadButton
@onready var quit_button: Button = %QuitButton


var _delayed_bar_tween: Tween

func _ready() -> void:
	#连接消息总线
	Messages.player_healed_changed.connect(update_health_bar)
	delayed_hp_bar.max_value = h_pbar.max_value
	delayed_hp_bar.value = h_pbar.value
	delayed_hp_bar.modulate.a = 0.55
	game_over.visible = false
	load_button.pressed.connect(_on_load_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	Messages.player_die.connect(show_game_over)
	pass


func update_health_bar(hp: float, max_hp: float) -> void:
	if max_hp <= 0.0:
		return

	var value: float = clampf(100.0 * hp / max_hp, 0.0, 100.0)
	h_pbar.value = value
	if value >= delayed_hp_bar.value:
		_stop_delayed_bar_tween()
		delayed_hp_bar.value = value
	else:
		_tween_delayed_health(value)
	hp_margin_container.size.x = max_hp
	pass


func _tween_delayed_health(target_value: float) -> void:
	_stop_delayed_bar_tween()
	_delayed_bar_tween = create_tween()
	_delayed_bar_tween.tween_interval(0.12)
	_delayed_bar_tween.tween_property(delayed_hp_bar, "value", target_value, 0.45) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)


func _stop_delayed_bar_tween() -> void:
	if _delayed_bar_tween and _delayed_bar_tween.is_valid():
		_delayed_bar_tween.kill()

func show_game_over() -> void:
	get_tree().paused = true
	load_button.visible = false
	quit_button.visible = false

	game_over.modulate.a = 0
	game_over.visible = true
	var tween: Tween = create_tween()
	tween.tween_property(game_over, "modulate", Color.WHITE, 3.0)
	await  tween.finished

	load_button.visible = true
	quit_button.visible = true

	load_button.grab_focus()
	pass


func clear_game_over() -> void:
	load_button.visible = false
	quit_button.visible = false
	var player: Player = get_tree().get_first_node_in_group("Player")
	player.queue_free()
	await SceneManager.load_scene_finishied
	
	game_over.visible = false
	
	get_tree().paused = false


func _on_load_pressed() -> void:
	SaveManager.load_game(SaveManager.currrent_slot)
	clear_game_over()
	pass


func _on_quit_pressed() -> void:
	SceneManager.transition_scene("res://title_scream/title_scream.tscn", "",  Vector2.ZERO, "up")
	clear_game_over()
	pass
