extends Area3D

var health_val = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("Player"):
		PlayerStats.change_health(health_val)
		queue_free()
	elif body.is_in_group("Player") and PlayerStats.health == 100:
		return
