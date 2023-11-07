extends RigidBody2D
class_name Fruit


signal combine(level: int)


const SCALE_BASE_INCREASE = 0.5
const SCALE_PER_LEVEL_RATIO = 1.5
const MAX_LEVEL: int = 11


var level_manager: LevelManager
var level: int = 1
var last_frame_level: int = 1


@onready var animator: AnimationPlayer = $animator
@onready var sprite_mask: Node2D = $sprite_mask
@onready var sprite: Sprite2D = $sprite_mask/sprite
@onready var shape: CollisionShape2D = $shape


func _ready():
	combine.connect(level_manager._on_fruit_combined)
	update_size()
	animator.play("spawn")
	
	
func animate_promotion(new_pos: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", new_pos, 0.3)


func update_size():
	var constant_increase = SCALE_BASE_INCREASE * level
	sprite_mask.scale = (1 + constant_increase) * SCALE_PER_LEVEL_RATIO * Vector2.ONE
	sprite.frame = level - 1
	shape.scale = (1 + constant_increase) * SCALE_PER_LEVEL_RATIO * Vector2.ONE


func try_combine(fruit: Fruit):
	if fruit.level != level or level >= MAX_LEVEL or fruit.is_queued_for_deletion():
		return false
		
	fruit.queue_free()
	level += 1
	combine.emit(level)
	return true


func _physics_process(_delta):
	if level != last_frame_level:
		last_frame_level = level
		update_size()
		return

	for body in get_colliding_bodies():
		if body.is_in_group('fruit') and try_combine(body):
			animator.play("spawn")
			break
