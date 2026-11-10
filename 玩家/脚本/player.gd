class_name  Player extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://ca5yc4awm2ua3")
const WHITE_FLASH_SHADER = preload("res://materialsAndshaders/white_flash.gdshader")
const DAMAGE_FLASH_INTERVAL: float = 0.06
const MAX_DASH_CHARGES: int = 2


#region

signal damage_taken
#endregion

#代码区域：准备就绪
@onready var sprite_2d: PlayerSprite = $Sprite2D
@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var da_stand: CollisionShape2D = %DAStand
@onready var da_crouch: CollisionShape2D = %DACrouch
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var one_way_plat_form_shapecast: ShapeCast2D = $OneWayPlatFormShapecast
@onready var attack_area: AttackArea = $AttackArea
@onready var attack_sprite_2d: Sprite2D = %AttackSprite2D
@onready var damage_area: DamageArea = %DamageArea

#代码区域结束






@export var move_speed: float=150.0
@export var jump_speed: float=450.0
@export var max_fall_speed: float=600.0
@export var dash_recharge_time: float = 1.0


#代码区域：状态机所需要的值
var states: Array[PlayerState]
var currentState: PlayerState:
	get: return states.front()
var previousState: PlayerState:
	get: return states[1]
#代码区域结束

#玩家统计信息
var hp: float = 20.0:
	set(value):
		hp = clampf(value, 0, max_hp)
		Messages.player_healed_changed.emit(hp,max_hp)
var max_hp: float = 20.0:
	set(value):
		max_hp = value
		Messages.player_healed_changed.emit(hp,max_hp)
var dash: bool = true
var double_jump: bool = true
var jumpTimes: int = 2
var dash_charges: int = MAX_DASH_CHARGES
var dash_recharge_remaining: float = 0.0
var ground_slam: bool = false
var morph_roll: bool = false
#----------





#代码区域：标准变量
var direction: Vector2=Vector2.ZERO
var gravity: float=980
var _damage_flash_material: ShaderMaterial
var _damage_flash_tween: Tween
#代码区域结束

func _ready() -> void:
	
	if get_tree().get_first_node_in_group("Player") != self:
		self.queue_free()
	_setup_damage_flash_material()
	
	#初始化状态
	init_states()
	self.call_deferred("reparent", get_tree().root)
	Messages.player_healed.connect(_on_player_healed)
	Messages.back_to_title_screen.connect(queue_free)
	damage_area.damage_taken.connect( _on_damage_taken )
	hp = max_hp
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		Messages.player_interacted.emit(self)
	elif event.is_action_pressed("pause"):
		get_tree().paused = true
		var pause_menu: PauseMenu = load("res://pause_menu/PauseMenu.tscn").instantiate()
		add_child(pause_menu)
		return
		
	#测试代码    
	if OS.is_debug_build():
		if event is InputEventKey:
			if event.keycode == KEY_MINUS:
				if Input.is_key_pressed(KEY_SHIFT):
					max_hp-=10
				else:
					hp-= 2
			elif event.keycode == KEY_EQUAL:
				if Input.is_key_pressed(KEY_SHIFT):
					max_hp+=10
				else:
					hp+= 2
			
	
	
	change_state(currentState.handle_input(event))
	
	pass


func _process(_delta: float) -> void:
	
	change_state(currentState.process(_delta))
	update_direction()
	
	pass

func _physics_process(_delta: float) -> void:
	update_dash_recharge(_delta)
	
	if !self.is_on_floor():
		velocity.y+=gravity*_delta
		velocity.y = clamp(velocity.y, -1000.0, max_fall_speed)
	move_and_slide()
	change_state(currentState.physics_process(_delta))
	
	
	
	pass


func can_dash() -> bool:
	return dash and dash_charges > 0


func consume_dash() -> bool:
	if not can_dash():
		return false
	dash_charges -= 1
	return true


func update_dash_recharge(delta: float) -> void:
	if not dash:
		return
	if currentState == %Dash:
		return
	if dash_charges >= MAX_DASH_CHARGES:
		dash_recharge_remaining = 0.0
		return

	dash_recharge_remaining -= delta
	if dash_recharge_remaining <= 0.0:
		dash_charges += 1
		if dash_charges < MAX_DASH_CHARGES:
			dash_recharge_remaining = dash_recharge_time
		else:
			dash_recharge_remaining = 0.0


func init_states()-> void:
	
	states=[]
	#收集所有的状态
	for s in $States.get_children():
		if s is PlayerState:
			s.player=self
			states.append(s)

		pass
	print(states)
	
	if states.size()==0:
		return
	
	#初始化所有状态
	for state in states:
		state.init()
		
	
	
	#设置我们的第一个状态
	change_state(currentState)
	currentState.enter()
	
	pass
	
	
func change_state(new_state: PlayerState)->void:
	if new_state==null:
		return
	elif new_state==currentState:
		return
	if currentState:
		currentState.exit()
	
	states.push_front(new_state)
	currentState.enter()
	states.resize(3)
	pass
	
	
func update_direction()->void:
	
	var pre_direction:Vector2 = direction
	
	var x_axis=Input.get_axis("left","right")
	var y_axis=Input.get_axis("up","down")
	direction=Vector2(x_axis,y_axis)
	
	if pre_direction != direction:
		attack_area.flip(direction.x)
		if direction.x < 0:
			sprite_2d.flip_h = true
			attack_sprite_2d.flip_h = true
			attack_sprite_2d.position.x = -24
		elif direction.x > 0:
			sprite_2d.flip_h = false
			attack_sprite_2d.flip_h = false
			attack_sprite_2d.position.x = 24
	
	pass
	


func add_debug_indicator(color: Color=Color.RED)-> void:
	
	var d:Node2D=DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child(d)
	d.global_position = global_position
	d.modulate=color
	await  get_tree().create_timer(3.0).timeout
	d.queue_free() 
	
	pass


func _on_player_healed(amount: float) -> void:
	hp += amount
	print("玩家血量恢复量：",amount)
	pass

func start_invulnerability_flash(duration: float) -> void:
	if _damage_flash_tween and _damage_flash_tween.is_valid():
		_damage_flash_tween.kill()
	_set_damage_flash_amount(0.0)
	if duration <= 0.0:
		return

	var loop_count := maxi(1, ceili(duration / (DAMAGE_FLASH_INTERVAL * 2.0)))
	_damage_flash_tween = create_tween()
	_damage_flash_tween.set_loops(loop_count)
	_damage_flash_tween.tween_callback(_set_damage_flash_amount.bind(1.0))
	_damage_flash_tween.tween_interval(DAMAGE_FLASH_INTERVAL)
	_damage_flash_tween.tween_callback(_set_damage_flash_amount.bind(0.0))
	_damage_flash_tween.tween_interval(DAMAGE_FLASH_INTERVAL)
	_damage_flash_tween.finished.connect(_on_damage_flash_finished)


func _setup_damage_flash_material() -> void:
	_damage_flash_material = ShaderMaterial.new()
	_damage_flash_material.shader = WHITE_FLASH_SHADER
	sprite_2d.material = _damage_flash_material


func _set_damage_flash_amount(amount: float) -> void:
	if _damage_flash_material:
		_damage_flash_material.set_shader_parameter("flash_amount", amount)


func _on_damage_flash_finished() -> void:
	_set_damage_flash_amount(0.0)


func _on_damage_taken(source_area: AttackArea) -> void:
	#减少生命值
	hp -= source_area.damage
	#发出信号
	damage_taken.emit()
	print("玩家受到伤害")
	pass
