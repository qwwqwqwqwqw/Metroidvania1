extends Node

enum REVERB_TYPE {NONE, SMALL, MEDIUM, LARGE}

@export var ui_focus_audio: AudioStream
@export var ui_select_audio: AudioStream
@export var ui_cancel_audio: AudioStream
@export var ui_success_audio: AudioStream
@export var ui_error_audio: AudioStream


var current_track: int = 0
var music_tweens: Array[Tween]
var ui_audio_player: AudioStreamPlaybackPolyphonic

@onready var music_1: AudioStreamPlayer = %Music1
@onready var music_2: AudioStreamPlayer = %Music2
@onready var ui: AudioStreamPlayer = %UI

func _ready() -> void:
	ui.play()
	ui_audio_player = ui.get_stream_playback()
	pass


func play_ui_audio(audio: AudioStream, volume_db: float = 0.0) -> void:
	if ui_audio_player:
		ui_audio_player.play_stream(audio, 0.0, volume_db)
	pass

func setup_button_audio(node: Node) -> void:
	for c in node.find_children("*","Button"):
		c.pressed.connect(ui_select_play)
		c.focus_entered.connect(ui_focus_play)
		
	pass

func play_music(audio: AudioStream) -> void:
	#获取当前音乐播放器
	var current_player: AudioStreamPlayer = get_music_player(current_track)
	if current_player.stream == audio:
		return
	#定义下一音乐播放器
	var next_tracker: int = wrapi(current_track + 1, 0, 2)
	var next_player: AudioStreamPlayer = get_music_player(next_tracker)
	#设置下一音乐播放器
	next_player.stream = audio
	next_player.play()
	#处理音乐淡入淡出效果
	for t in music_tweens:
		t.kill()
	music_tweens.clear()
	fade_track_out(current_player)
	fade_track_in(next_player)
	#存储当前音乐轨道
	current_track = next_tracker
	pass

func get_music_player( i : int) -> AudioStreamPlayer:
	if i == 0:
		return music_1
	else:
		return music_2

func fade_track_in(player: AudioStreamPlayer) -> void:
	var tween: Tween = create_tween()
	music_tweens.append(tween)
	tween.tween_property(player, "volume_linear", 1.0, 1.0)
	pass

func fade_track_out(player: AudioStreamPlayer) -> void:
	var tween: Tween = create_tween()
	music_tweens.append(tween)
	tween.tween_property(player, "volume_linear", 0.0, 1.5)
	tween.tween_callback(player.stop)
	pass

func set_reverb(type: REVERB_TYPE) -> void:
	var reverb_fx: AudioEffectReverb = AudioServer.get_bus_effect(1, 0)
	if not reverb_fx:
		return
	AudioServer.set_bus_effect_enabled(1, 0, true)
	match type:
		REVERB_TYPE.NONE: 
			AudioServer.set_bus_effect_enabled(1, 0, false)
		REVERB_TYPE.SMALL:
			reverb_fx.room_size = 0.2
		REVERB_TYPE.MEDIUM:
			reverb_fx.room_size = 0.5
		REVERB_TYPE.LARGE:
			reverb_fx.room_size = 0.8
	pass

func play_spatial_sound(audio: AudioStream, pos: Vector2) -> void:
	var ap: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	add_child(ap)
	ap.bus ="SFX"
	ap.stream = audio
	ap.finished.connect(ap.queue_free)
	ap.play()
	
	pass

#region
func ui_focus_play() -> void:
	
	play_ui_audio(ui_focus_audio, 15.0)
	pass

func ui_success_play() -> void:
	play_ui_audio(ui_success_audio)
	pass

func ui_cancel_play() -> void:
	play_ui_audio(ui_cancel_audio)
	pass

func ui_error_play() -> void:
	play_ui_audio(ui_error_audio)
	pass

func ui_select_play() -> void:
	play_ui_audio(ui_select_audio)
	pass
#endregion
