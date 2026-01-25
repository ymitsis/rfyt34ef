extends Area2D

@export var speed: float = 10

@export var tex_center: Texture2D
@export var tex_left: Texture2D
@export var tex_right: Texture2D

@onready var minigame := get_parent()
@onready var spaceship := $Spaceship
@onready var ex_left := $exhaust_left
@onready var ex_right := $exhaust_right
@onready var hit_sprite := $Hit_sprite
@onready var hit_sound1: AudioStreamPlayer = $Hit_sfx1
@onready var hit_sound2: AudioStreamPlayer = $Hit_sfx2


func _physics_process(_delta: float) -> void:
	# gives direction
	var direction = Input.get_axis("ui_left", "ui_right")
	position.x += direction * speed
	# change spaceship image
	if direction < 0:
		spaceship.texture = tex_left
		ex_left.position = Vector2(-70, 50)
		ex_right.position = Vector2(60, 50)
		ex_left.scale = Vector2(0.7, 0.9)
		ex_right.scale = Vector2(0.8, 1.0)
	elif direction > 0:
		spaceship.texture = tex_right
		ex_left.position = Vector2(-55, 50)
		ex_right.position = Vector2(70, 50)
		ex_left.scale = Vector2(0.8, 1.0)
		ex_right.scale = Vector2(0.7, 0.9)
	else:
		spaceship.texture = tex_center
		ex_left.position = Vector2(-95, 50)
		ex_right.position = Vector2(95, 50)
		ex_left.scale = Vector2(1.0, 1.0)
		ex_right.scale = Vector2(1.0, 1.0)
	# makes the loop effect when the ship goes beyond the screen
	if position.x > 750: position.x = 750
	elif position.x < 50: position.x = 50
	

# hit detection
func _on_body_entered(body: Node2D) -> void:
	var asteroid := body as RigidBody2D
	if asteroid == null: return
	var m: float = asteroid.mass
	var hit_sound: AudioStreamPlayer
	if m<0.7: hit_sound = hit_sound1
	else: hit_sound = hit_sound2
	hit_sound.volume_db = 30 * m - 30
	hit_sprite.position = to_local((global_position + asteroid.global_position) * 0.5)
	hit_sprite.scale = Vector2(m * 2, m * 2)
	hit_sound.play()
	hit_sprite.visible = true
	await get_tree().create_timer(0.1).timeout
	hit_sprite.visible = false
	minigame.damage += m
	print(minigame.damage)
	if is_instance_valid(asteroid): asteroid.queue_free()
