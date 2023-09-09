extends Node

var health = 100
var max_health = 200
var armor = 0
var max_armor = 100
var guns_carried = []
var ammo_pistol = 50
var ammo_rifle = 50
var ammo_mgun = 50
var ammo_max_pistol = 200
var ammo_max_rifle = 50
var ammo_max_mgun = 200
 
var red_key = false
var blue_key = false
var yellow_key = false
var current_gun = "Pistol"

func reset():
	var health = 100
	var max_health = 200
	var armor = 0
	var max_armor = 100
	var guns_carried = []
	var ammo_pistol = 50
	var ammo_rifle = 50
	var ammo_mgun = 50
	var ammo_max_pistol = 200
	var ammo_max_rifle = 50
	var ammo_max_mgun = 200
	var red_key = false
	var blue_key = false
	var yellow_key = false
	var current_gun = "Pistol"
	

func _ready():
	pass

func take_damage(amount):
	if amount > armor:
		amount = amount - armor
		armor = 0
	else:
		change_armor(-amount)
		return
	###apply remaining damage to health
	change_health(-amount)
		
	
func change_health(amount):
	health += amount
	health = clamp(health, 0, max_health)
	
func change_armor(amount):
	armor += amount
	armor = clamp(armor,0,max_armor)
	
func change_pistol_ammo(amount):
	ammo_pistol+=amount
	ammo_pistol = clamp(ammo_pistol,0,ammo_max_pistol)
	
func change_rifle_ammo(amount):
	ammo_rifle+=amount
	ammo_rifle = clamp(ammo_rifle,0,ammo_max_rifle)
	
func change_mgun_ammo(amount):
	ammo_mgun +=amount
	ammo_mgun = clamp(ammo_mgun,0,ammo_max_mgun)
	
func get_pistol_ammo():
	return str(ammo_pistol)
 
func get_rifle_ammo():
	return str(ammo_rifle)
	
func get_mgun_ammo():
	return str(ammo_mgun)
	
func get_health():
	return str(health)
 
func get_armor():
	return str(armor)
