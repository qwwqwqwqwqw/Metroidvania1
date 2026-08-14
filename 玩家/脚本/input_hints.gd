@icon("res://general/ions/input_hints.svg")
class_name InputHints extends Node2D

const HINT_MAP: Dictionary = {
	"keyboard":{
		"interact" : 12,
		"attack" : 10,
		"jump" : 9,
		"dash" : 11,
		"up" : 13
	},
	
	"xbox":{
		"interact" : 6,
		"attack" : 7,
		"jump" : 5,
		"dash" : 0,
		"up" : 8
	},
}


var controller_type: String = "keyboard"

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	visible = false
	Messages.input_hint_changed.connect(_on_hint_changed)
	pass


func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton or event is InputEventKey:
		controller_type = "keyboard"
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		get_controller_type(event.device)
	pass





func _on_hint_changed(hint: String) -> void:
	if hint == "":
		visible = false
	else:
		visible = true
		sprite_2d.frame = HINT_MAP[controller_type].get(hint, "0")
		#更新精灵图
	pass



func get_controller_type(device_id: int) -> void:
	var n: String = Input.get_joy_name(device_id).to_lower()
	if "xbox" in n or "xinput" in n:
		controller_type = "xbox"
	elif "playstation" in n or "ps" in n or "dualsense" in n:
		controller_type = "playstation"
	elif "nintendo" in n or "switch" in n:
		#controller_type = "nintendo"
		controller_type = "playstation"
	else:
		controller_type = "unknow"
		
	
	pass
