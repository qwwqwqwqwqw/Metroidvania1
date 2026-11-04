#玩家血量条
extends CanvasLayer


@onready var hp_margin_container: MarginContainer = %HPMarginContainer
@onready var h_pbar: TextureProgressBar = %HPbar
@onready var delayed_hp_bar: TextureProgressBar = %DelayedHPbar

var _delayed_bar_tween: Tween

func _ready() -> void:
	#连接消息总线
	Messages.player_healed_changed.connect(update_health_bar)
	delayed_hp_bar.max_value = h_pbar.max_value
	delayed_hp_bar.value = h_pbar.value
	delayed_hp_bar.modulate.a = 0.55
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
