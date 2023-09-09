extends CharacterBody3D

@onready var nav = get_tree().get_nodes_in_group("NavMesh")[0]
@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var nav_agent = $NavigationAgent3D



var path = []
var path_index = 0
var speed = 3
var health = 20
var move = true
var target
var vector

var searching = false
var shooting = false
var dead = false

var damage = 8

@onready var ray = $Visual

func _ready():
	pass

func take_damage(amount):
	health -= amount
	if health <= 0:
		death()
		return
	move = false
	$AnimatedSprite3D.play("hit")
	await $AnimatedSprite3D.animation_finished
	$AnimatedSprite3D.play("walking")
	move = true

func is_blocking():
	if searching and not dead and not shooting:
		$AnimatedSprite3D.play("shoot")
		shooting = true
		await $AnimatedSprite3D.frame_changed
		if ray.is_colliding():
			if ray.get_collider().is_in_group("Player"):
				PlayerStats.change_health(-damage * 0.5)
		await $AnimatedSprite3D.animation_finished
		shooting = false

func _physics_process(delta):
	if dead:
		return
	look_at_player()
	if searching and not shooting:
		var current_location = global_transform.origin
		var vector2 = (-current_location + player.global_transform.origin).normalized() * speed
		$AnimatedSprite3D.play("walking")
		
		velocity = vector2
		move_and_slide()
	else:
		if not shooting:
			$AnimatedSprite3D.play("idle")

func look_at_player():
	ray.look_at(player.global_transform.origin)
	if ray.is_colliding():
		if ray.get_collider().is_in_group("Player"):
			searching = true
			
		else:
			searching = false
			var check_near =  $Aural.get_overlapping_bodies()
			for body in check_near:
				if body.is_in_group("Player"):
					searching = true
	
func death():
	dead = true
	set_process(false)
	set_physics_process(false)
	$CollisionShape3D.disabled = true
	$AnimatedSprite3D.play("die")
	await $AnimatedSprite3D.animation_finished
	queue_free()

func move_towards_player(target):
	nav_agent.set_target_position(target)

func shoot():
	if searching and not dead and not shooting:
		$AnimatedSprite3D.play("shoot")
		shooting = true
		await $AnimatedSprite3D.frame_changed
		if ray.is_colliding():
			if ray.get_collider().is_in_group("Player"):
				PlayerStats.change_health(-damage)
		await $AnimatedSprite3D.animation_finished
		shooting = false

func _on_aural_body_entered(body):
	if body.is_in_group("Player"):
		searching = true


func _on_shoot_timer_timeout():
	shoot()
