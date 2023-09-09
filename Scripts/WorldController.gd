extends Node3D

@onready var NavAgent = get_node("/root/World/CharacterBody3D/BasicGrunt/NavigationAgent3D")
@onready var Visual = get_node("/root/World/CharacterBody3D/BasicGrunt/Visual")
@onready var BasicGrunt1 = get_node("/root/World/CharacterBody3D/BasicGrunt")

@onready var CollisionShape2 = get_node("/root/World/CharacterBody3D/BasicGrunt/CollisionShape3D")
@onready var AnimatedSprite2 = get_node("/root/World/CharacterBody3D/BasicGrunt/AnimatedSprite3D")
@onready var BasicGrunt2 = get_node("/root/World/CharacterBody3D/BasicGrunt")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
