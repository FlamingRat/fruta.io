extends RigidBody2D


const MAX_AGE = 5


var force_bonus: int = 0


@onready var age: float = 0


func _ready():
	var upward_force = (300 + (100 * force_bonus)) * randf_range(0.8, 1.2)
	apply_impulse(
		Vector2.UP * upward_force + randf_range(-0.5, 0.5) * 
		Vector2.LEFT * 300,
		Vector2.LEFT * 0.5 * (randi_range(0, 1) * 2 - 1)
	)


func _process(delta):
	age += delta
	
	if age >= MAX_AGE:
		queue_free()
