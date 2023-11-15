extends Node2D


signal fruit_dropped(level: int)


const STARTING_MAX_SPAWN_LEVEL: int = 3
const TURNS_TO_INCREASE_MAX_SPAWN_LEVEL: float = 7
const FINAL_MAX_SPAWN_LEVEL: int = 5


@export var fruitFactory: PackedScene
@export var level_manager: LevelManager
@export var bucket: Bucket


var current_fruit: Fruit
var next_fruit: Fruit
var turn_count: int = 0


func reposition():
	var follow_coords = get_global_mouse_position()
	var r: float = current_fruit.radius if current_fruit else 0.0
	global_position.x = max(
		min(follow_coords.x, bucket.end_r - r),
		bucket.end_l + r
	)
	
	
func reposition_fruit():
	var next_fruit_position = (
		Vector2.UP *
		(next_fruit.radius + 2 + current_fruit.radius)
	)
	
	current_fruit.position = next_fruit_position
	current_fruit.animate_promotion(Vector2.ZERO)
	next_fruit.position = next_fruit_position


func get_new_fruit():
	var max_spawn_level_increase = floor(
		turn_count / TURNS_TO_INCREASE_MAX_SPAWN_LEVEL
	)
	var max_level = min(
		STARTING_MAX_SPAWN_LEVEL + max_spawn_level_increase,
		FINAL_MAX_SPAWN_LEVEL
	)

	next_fruit = fruitFactory.instantiate()
	next_fruit.set_collision_mask_value(1, false)
	next_fruit.set_collision_layer_value(1, false)
	next_fruit.level = randi_range(1, max_level)
	next_fruit.level_manager = level_manager
	add_child(next_fruit)
	next_fruit.freeze = true
	
	if current_fruit:
		reposition_fruit()
	
	
func promote_fruit():
	current_fruit = next_fruit
	get_new_fruit()


func drop_fruit():
	turn_count += 1

	remove_child(current_fruit)
	get_tree().current_scene.add_child(current_fruit)

	current_fruit.global_position = global_position	
	fruit_dropped.emit(current_fruit.level)
	current_fruit.set_collision_mask_value(1, true)
	current_fruit.set_collision_layer_value(1, true)
	current_fruit.freeze = false
	current_fruit = null
	promote_fruit()


func _ready():
	reposition()
	get_new_fruit()
	promote_fruit()


func _physics_process(_delta):
	reposition()


func _on_level_game_over():
	queue_free()


func _on_input_mask_click_mask_pressed():
	if current_fruit.global_position == global_position:
		drop_fruit()
