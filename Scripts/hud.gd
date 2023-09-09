extends CanvasLayer


@onready var armor = $MarginContainer/Stats/Values/ArmorValue
@onready var health = $MarginContainer/Stats/Values/healthValue
@onready var ammo = $MarginContainer/Stats/Ammo/AmmoValue

func _process(delta):
	var current_gun = PlayerStats.current_gun
	armor.text = PlayerStats.get_armor()
	health.text = PlayerStats.get_health()

	if current_gun == "Pistol":
		ammo.text = PlayerStats.get_pistol_ammo()
	if current_gun == "Rifle":
		ammo.text = PlayerStats.get_rifle_ammo()
	if current_gun == "DP28":
		ammo.text = PlayerStats.get_mgun_ammo()


