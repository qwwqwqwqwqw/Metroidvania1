class_name PlayerstateGroundSlam extends PlayerState


const DASH_AUDIO = preload("uid://bke8mc3gwtsdf")
const BOOM_AUDIO = preload("uid://b5nbx3dl7ff73")
const HIT_WOOD_LARGE = preload("uid://brygep1mm1tsa")
const HIT_WOOD_MEDIUM = preload("uid://wmv54yr1umwb")
const HIT_WOOD_SMALL = preload("uid://d37xkly2ai15m")
const BREAK_WOOD = preload("uid://cx0jknndi3r74")

@onready var damage_area: DamageArea = %DamageArea
@onready var ground_slam_shapecast: ShapeCast2D = $"../../GroundSlamShapecast"
@onready var ground_slam_attack_area: AttackArea = %GroundSlamAttackArea


@export var velocity: float = 400.0
@export var effect_delay: float = 0.075
var effect_timer: float

func init() -> void:
	#print("init!idle")
	pass
	
#当进入状态是会发生什么	
func enter()-> void:
	#print("enter!idle")
	effect_timer = 0.0
	damage_area.start_invulnerable()
	player.animation_player.play("ground_stam")
	player.sprite_2d.tween_color()
	Audio.play_spatial_sound(DASH_AUDIO, player.global_position)
	ground_slam_attack_area.set_active()
	pass
	
#当退出状态时会发生什么	
func exit()-> void:
	player.sprite_2d.reset_color()
	VisualEffects.land_dust(player.global_position)
	VisualEffects.hit_dust(player.global_position)
	VisualEffects.camera_shake(10.0)
	Audio.play_spatial_sound(BOOM_AUDIO, player.global_position)
	damage_area.end_invulnerable()
	ground_slam_attack_area.set_active(false)
	pass


#处理输入发生的事件
func handle_input(event: InputEvent)-> PlayerState:

	return null
	
	

#状态过程中发生的事
func process(_delta: float)-> PlayerState:
	#print("process:",name,_delta)
	
	check_collisions(_delta)
	effect_timer -= _delta
	if effect_timer <= 0.0:
		player.sprite_2d.spawn_dash_afterimage()
		effect_timer = effect_delay
	return null
	
#每次物理过程更新时会发生的事情	
func physics_process(_delta: float)-> PlayerState:
	#print("pp:",name)
	player.velocity.y = velocity
	
	if player.is_on_floor():
		if not check_collisions(_delta):
			return idle
	return null


func check_collisions(_delta: float) -> bool:
	ground_slam_shapecast.target_position.y = velocity * _delta
	ground_slam_shapecast.force_shapecast_update()
	if ground_slam_shapecast.is_colliding():
		for i in ground_slam_shapecast.get_collision_count():
			var c = ground_slam_shapecast.get_collider(i)
			var pos : Vector2 = ground_slam_shapecast.get_collision_point(i)
			if c.get_parent() is Breakable:
				var b: Breakable = c.get_parent();
				b.queue_free();
				Audio.play_spatial_sound(b.destory_audio, pos)
				for p in b.destroy_particles:
					VisualEffects.hit_particles(pos, Vector2.DOWN, p)
			else:	
				c.queue_free()
				VisualEffects.hit_particles(pos, Vector2.DOWN, HIT_WOOD_LARGE)
				VisualEffects.hit_particles(pos, Vector2.DOWN, HIT_WOOD_MEDIUM)
				VisualEffects.hit_particles(pos, Vector2.UP, HIT_WOOD_SMALL)
				Audio.play_spatial_sound(BREAK_WOOD, pos)
			VisualEffects.hit_dust(pos)
			VisualEffects.camera_shake(10)
		return true
	return false
