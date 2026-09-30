extends Node


const DUST_EFFECT = preload("uid://dptlswrb5dqx2")

signal camera_shook(strength: float)


#创建灰尘效果
func _create_dust_effect(pos: Vector2) -> DustEffect:
	#实例化灰尘对象并放入场景树作为节点最后返回此节点
	var dust: DustEffect = DUST_EFFECT.instantiate()
	add_child(dust)
	dust.global_position = pos
	return dust




#创建跳跃灰尘
func jump_dust(pos: Vector2) -> void:
	var dust: DustEffect =  _create_dust_effect(pos)
	dust.start(DustEffect.TYPE.JUMP)
	pass



#创建落地灰尘
func land_dust(pos: Vector2) -> void:
	var dust: DustEffect =  _create_dust_effect(pos)
	dust.start(DustEffect.TYPE.LAND)
	pass



#打击灰尘
func hit_dust(pos: Vector2) -> void:
	var dust: DustEffect =  _create_dust_effect(pos)
	dust.start(DustEffect.TYPE.HIT)
	pass


func hit_particles() -> void:
	
	pass


func camera_shake(strength: float = 1.0) -> void:
	camera_shook.emit(strength)
	pass
