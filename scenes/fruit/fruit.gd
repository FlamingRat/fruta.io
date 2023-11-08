extends RigidBody2D
class_name Fruit


signal combine(level: int)


const SCALE_BASE_INCREASE = 1
const SCALE_PER_LEVEL_RATIO = 1.25
const MAX_LEVEL: int = 11
const TIME_TO_MATURE: float = 0.1


var level_manager: LevelManager
var level: int = 1
var last_frame_level: int = 1
var age: float = 0
var max_scale: Vector2


@onready var sprite_mask: Node2D = $sprite_mask
@onready var sprite: Sprite2D = $sprite_mask/sprite
@onready var shape: CollisionShape2D = $shape


func _ready():
	combine.connect(level_manager._on_fruit_combined)
	max_scale = sprite.scale
	update_size()


func animate_promotion(new_pos: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", new_pos, 0.3)


func update_size():
	var constant_increase = SCALE_BASE_INCREASE * level
	sprite_mask.scale = (1 + constant_increase) * SCALE_PER_LEVEL_RATIO * Vector2.ONE
	sprite.frame = level - 1
	shape.scale = (1 + constant_increase) * SCALE_PER_LEVEL_RATIO * Vector2.ONE
	animate_size()


func try_combine(fruit: Fruit):
	if fruit.level != level or level >= MAX_LEVEL or \
		fruit.is_queued_for_deletion() or is_queued_for_deletion() or \
		age < TIME_TO_MATURE or fruit.age < TIME_TO_MATURE:

		return false
		
	fruit.queue_free()
	level += 1
	age = 0
	combine.emit(level)
	return true
	
	
func animate_size():
	var tween = create_tween()
	sprite.scale = Vector2.ZERO
	tween.tween_property(sprite, "scale", max_scale, 0.2)


func _physics_process(delta):
	if age < TIME_TO_MATURE:
		age += delta
	
	if level != last_frame_level:
		last_frame_level = level
		update_size()
		return

	for body in get_colliding_bodies():
		if body.is_in_group('fruit') and try_combine(body):
			break
