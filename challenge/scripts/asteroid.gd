extends RigidBody2D

func _ready() -> void:
	var rnd_scale = 0.1 + pow(randf(), 3.0) * 0.9
	$Texture.scale = Vector2(rnd_scale, rnd_scale)
	$CollisionShape2D.scale = Vector2(rnd_scale, rnd_scale)
	mass = rnd_scale
	var rnd_speed = Vector2(randf_range(-50.0, 50.0), randf_range(-50.0, 50.0))
	linear_velocity = Vector2(0, 150) + rnd_speed
	var rnd_angular = randf_range(-1.0, 1.0)
	angular_velocity = rnd_angular


func _physics_process(_delta: float) -> void:

	var screen: Vector2 = get_viewport_rect().size
	var m := 100.0
	var p := global_position

	if p.y > screen.y + m or p.x < -m or p.x > screen.x + m:
		queue_free()
