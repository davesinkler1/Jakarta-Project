extends Node3D

@onready var gun_sprite = $CanvasLayer/Control/GunSprite
@onready var gun_rays = $GunRays.get_children()
@onready var flash = preload("res://Scenes/MuzzleFlash.tscn")
@onready var blood = preload("res://Scenes/Blood.tscn")
@onready var pistol = get_parent().get_node("Pistol")
@onready var rifle = get_parent().get_node("Rifle")
@onready var dp28 = get_parent().get_node("DP28")
@onready var rapid_fire = false
@onready var World = get_node("/root/World/")
@onready var World2 = get_node("/root/World2/")
var BG = load("res://Scripts/BasicGrunt.gd").new()

var can_shoot =  true
var Hattack = false
var blocking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	gun_sprite.play("idle")
	print("Hattack: ", Hattack)
	print("can_shoot: ",  can_shoot)
	
func check_hit():
	for ray in gun_rays:
		if ray.is_colliding():
			print("collided with: " + ray.get_collider().get_name())
			var collision_shape_name = ray.get_collider().shape_owner_get_owner(ray.get_collider_shape()).name
			if ray.get_collider().is_in_group("Enemy"):
				if PlayerStats.current_gun == "Pistol":
					match collision_shape_name:
						"head":
							print("headshot called")
							BG.take_damage(20)
							return
					ray.get_collider().take_damage(8)
					print("pistol damage")
				elif PlayerStats.current_gun == "Rifle":
					if ray.get_collider().get_name() == "head":
						checkWorld()
						return
					ray.get_collider().take_damage(12)
					print("rifle damage")
				elif PlayerStats.current_gun == "DP28":
					if ray.get_collider().get_name() == "head":
						checkWorld()
						return
					ray.get_collider().take_damage(7)
					print("dp28 damage")
				elif PlayerStats.current_gun == "Machete":
					if ray.get_collider().get_name() == "head":
						checkWorld()
						return
					elif Hattack == true:
						ray.get_collider().take_damage(20)
						print("machete heavy")
						return
					elif blocking == true:
						ray.get_collider().is_blocking()
						print("is blocking")
						return
					ray.get_collider().take_damage(10)
					print("machete damage")
				var new_blood = blood.instantiate()
				print("adding blood")
				get_node("/root/World").add_child(new_blood)
				new_blood.global_transform.origin = ray.get_collision_point()
				new_blood.emitting = true

func make_flash():
	var f = flash.instantiate()
	add_child(f)

func _process(delta):
	if PlayerStats.current_gun == "Pistol":
		if Input.is_action_just_pressed("shoot") and can_shoot and PlayerStats.ammo_pistol > 0:
			gun_sprite.play("shoot")
			make_flash()
			check_hit()
			PlayerStats.change_pistol_ammo(-1)
			can_shoot = false
			
			await gun_sprite.animation_finished
		
			can_shoot = true
			gun_sprite.play("idle")
			
	elif PlayerStats.current_gun == "Rifle":
		if Input.is_action_just_pressed("shoot") and can_shoot and PlayerStats.ammo_rifle > 0:
			gun_sprite.play("shoot")
			make_flash()
			check_hit()
			PlayerStats.change_rifle_ammo(-1)
			can_shoot = false
		
			await gun_sprite.animation_finished
		
			can_shoot = true
			gun_sprite.play("idle")
			
	elif PlayerStats.current_gun == "DP28":
		if Input.is_action_just_pressed("shoot") and can_shoot and PlayerStats.ammo_mgun > 0:
			gun_sprite.play("shoot")
			make_flash()
			check_hit()
			PlayerStats.change_mgun_ammo(-1)
			can_shoot = false
		
			await gun_sprite.animation_finished
		
			can_shoot = true
			gun_sprite.play("idle")
			
	elif PlayerStats.current_gun == "Machete":
		if Input.is_action_just_pressed("shoot") and can_shoot:
			gun_sprite.play("attack")
			check_hit()
			can_shoot = false
		
			await gun_sprite.animation_finished
		
			can_shoot = true
			gun_sprite.play("idle")
		elif Input.is_action_just_pressed("ADS"):
			print("hattack called")
			gun_sprite.play("hattack")
			await get_tree().create_timer(2).timeout
			Hattack = true
			check_hit()
			Hattack = false
		
			await gun_sprite.animation_finished
			
			can_shoot = true
			gun_sprite.play("idle")
		
		if Input.is_action_just_pressed("block"):
			print("block")
			gun_sprite.play("blocks")
			await get_tree().create_timer(2).timeout
			blocking = true
			check_hit()
			blocking = false
			
			await gun_sprite.animation_finished
			
			gun_sprite.play("idle")

func checkWorld():
	print("check world called")
	for ray in gun_rays:
		print ("world loop")
		if get_node("/root/World/"):
			print("WORLD 1")
			ray.get_collider().deathH1()
		elif get_node("/root/World2/"):
			ray.get_collider().deathH2()

func _on_Timer_timeout():
	can_shoot = true
