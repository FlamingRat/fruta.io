extends RigidBody2D
class_name Fruit


signal combine(level: int)


const MAX_SCALE = 8
const EASING = 1.1
const MAX_LEVEL: int = 11
const TIME_TO_MATURE: float = 0.1


var level_manager: LevelManager
var level: int = 1
var last_frame_level: int = 1
var age: float = 0
var sprite_scale: Vector2
var radius: float = 0 : get = get_radius


@onready var sprite_mask: Node2D = $sprite_mask
@onready var sprite: Sprite2D = $sprite_mask/sprite
@onready var shape: CollisionShape2D = $shape
@onready var merge_range: Area2D = $merge_range


func get_radius():
	return shape.shape.get_rect().size.x * shape.scale.x / 2


func _ready():
	combine.connect(level_manager._on_fruit_combined)
	sprite_scale = sprite.scale
	update_size()


func animate_promotion(new_pos: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", new_pos, 0.3)


func update_size():
	var progress = (level - 1.0) / (MAX_LEVEL - 1.0)
	var current_scale = 1 + (MAX_SCALE - 1) * pow(progress, EASING)
	sprite_mask.scale = current_scale * Vector2.ONE
	sprite.frame = level - 1
	shape.scale = current_scale * Vector2.ONE
	merge_range.scale = current_scale * Vector2.ONE
	mass = current_scale
	
	animate_size()


func grow():
	level += 1
	age = 0
	combine.emit(level)


func try_combine(fruit: Fruit):
	if fruit.level != level or level >= MAX_LEVEL or \
		fruit.is_queued_for_deletion() or is_queued_for_deletion() or \
		age < TIME_TO_MATURE or fruit.age < TIME_TO_MATURE:

		return false

	var lower: Fruit
	var higher: Fruit
	
	if position.y >= fruit.position.y:
		lower = self
		higher = fruit
	else:
		lower = fruit
		higher = self
	
	higher.queue_free()
	lower.grow()
	return true


func animate_size():
	var tween = create_tween()
	sprite.scale = Vector2.ZERO
	tween.tween_property(sprite, "scale", sprite_scale, 0.2)


func _physics_process(delta):
	if age < TIME_TO_MATURE:
		age += delta
	
	if level != last_frame_level:
		last_frame_level = level
		update_size()
		return

	for body in merge_range.get_overlapping_bodies():
		if body != self and body.is_in_group('fruit') and try_combine(body):
			break
