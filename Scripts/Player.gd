extends CharacterBody3D

var speed
var gravity = 0
var max_speed = 8
var crouchm_speed = 3
var crouch_speed = 20
var crouch_height = 0.5
var default_height = 1.5
var mouse_sensitivity = 0.002
var walking = true
var crouching = true

@onready var pistol = preload("res://Scenes/Pistol.tscn")
@onready var rifle = preload("res://Scenes/Rifle.tscn")
@onready var dp28 = preload("res://Scenes/dp28.tscn")
@onready var machete = preload("res://Scenes/Machete.tscn")
var current_gun = 0
@onready var carried_guns = [pistol, rifle, dp28, machete]
@onready var pcap = $CollisionShape3D

func _ready():
	walking = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("move_forward"):
		input_dir += -global_transform.basis.z
		$Pivot/Gun.rotation.y = 0
		if walking == false:
			$Pivot/Gun.rotation.x = 0.1 + -$Pivot/Gun.rotation.y
			$Pivot/Gun.rotation.y = 0.1 + $Pivot/Gun.rotation.x
	if Input.is_action_pressed("move_back"):
		input_dir += global_transform.basis.z
		if walking == false:
			$Pivot/Gun.rotation.x = 0.1 + -$Pivot/Gun.rotation.y
			$Pivot/Gun.rotation.y = 0.1 + $Pivot/Gun.rotation.x
	if Input.is_action_pressed("strafe_left"):
		input_dir += -global_transform.basis.x
		if walking == false:
			$Pivot/Gun.rotation.x = 0.1 + -$Pivot/Gun.rotation.y
			$Pivot/Gun.rotation.y = 0.1 + $Pivot/Gun.rotation.x
	if Input.is_action_pressed("strafe_right"):
		input_dir += global_transform.basis.x
		$Pivot/Gun.rotation.x = 0
		if walking == false:
			$Pivot/Gun.rotation.x = 0.1 + -$Pivot/Gun.rotation.y
			$Pivot/Gun.rotation.y = 0.1 + $Pivot/Gun.rotation.x
	if Input.is_action_just_pressed("walking"):
		print("walking on")
		$Pivot/Gun.rotation.x = 0
		$Pivot/Gun.rotation.y = 0
		max_speed = 3
		walking = !walking
	if Input.is_action_just_pressed("walking") && !walking:
		print("walking off")
		max_speed = 8
	
	input_dir = input_dir.normalized()
	return input_dir
		
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x - clamp($Pivot.rotation.x, -1.2, 1.2)

func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	set_velocity(velocity)
	set_up_direction(Vector3.UP)
	set_floor_stop_on_slope_enabled(true)
	move_and_slide()
	velocity = velocity

func change_gun(gun):
	$Pivot/Gun.get_child(0).queue_free()
	var new_gun = carried_guns[gun].instantiate()
	$Pivot/Gun.add_child(new_gun)
	PlayerStats.current_gun = new_gun.name
	print("current gun: " + PlayerStats.current_gun)

func _process(delta):
	
	speed = max_speed
	
	if Input.is_action_just_pressed("crouch"):
		print("crouching")
		pcap.shape.height -= crouch_speed * delta
		speed = crouchm_speed
		crouching = !crouching
	if Input.is_action_just_pressed("crouch") && !crouching:
		print("crouching off")
		pcap.shape.height += crouch_speed * delta
		
	pcap.shape.height = clamp(pcap.shape.height, crouch_height, default_height)
	if Input.is_action_just_pressed("next_gun"):
		current_gun += 1
		if current_gun > len(carried_guns)-1:
			current_gun = 0
			change_gun(current_gun)
	elif Input.is_action_just_pressed("prev_gun"):
			current_gun -= 1
			if current_gun < 0:
				current_gun = len(carried_guns)-1
			change_gun(current_gun)

