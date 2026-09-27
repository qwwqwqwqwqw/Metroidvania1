#玩家血量条
extends CanvasLayer


@onready var hp_margin_container: MarginContainer = %HPMarginContainer
@onready var h_pbar: TextureProgressBar = %HPbar


func _ready() -> void:
	#连接消息总线
	Messages.player_healed_changed.connect(update_health_bar)
	pass


func update_health_bar(hp: float, max_hp: float) -> void:
	var value: float = 100 * hp / max_hp
	h_pbar.value = value
	hp_margin_container.size.x = max_hp + 22
	pass
