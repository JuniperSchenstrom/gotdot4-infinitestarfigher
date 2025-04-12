extends Node2D

static var projectile_properties: Array[Dictionary] = [{"type": "bullet_basic", "speed": 2000, "damage": 10, "lifetime": 2000, "special": true}]
var projectile_scene: Array[PackedScene] = [preload("res://scenes/Projectiles/bullet.tscn")]
var active_projectiles_ID_0: Array[Projectile] = []
var inactive_projectiles_ID_0: Array[Projectile] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if len(active_projectiles_ID_0) > 0: for i in len(active_projectiles_ID_0): active_projectiles_ID_0[i].update(delta)


func _on_player_fire(port_position, starbrd_position, fire_direction, projectile_ID):
	
	var port = Projectile.new(port_position, fire_direction, projectile_ID)
	var starbrd = Projectile.new(starbrd_position, fire_direction, projectile_ID)
	active_projectiles_ID_0.append(port)
	active_projectiles_ID_0.append(starbrd)
	add_child(port)
	add_child(starbrd)
	"""var bullet_port = projectile_scene[0].instantiate() as Area2D
	var bullet_starbrd = projectile_scene[0].instantiate() as Area2D
	bullet_port.position = port_position
	bullet_starbrd.position = starbrd_position
	bullet_port.scale *= 0.5
	bullet_starbrd.scale *= 0.5
	bullet_port.direction = fire_direction
	bullet_starbrd.direction = fire_direction
	bullet_port.rotation_degrees = rad_to_deg(fire_direction.angle()) + 90
	bullet_starbrd.rotation_degrees = rad_to_deg(fire_direction.angle()) + 90
	
	
	add_child(bullet_port)
	add_child(bullet_starbrd)"""

class Projectile extends Area2D:
	
	static var projectile_properties: Array[Dictionary] = [{"type": "bullet_basic", "speed": 2000, "damage": 10, "lifetime": 2000, "special": true, "texture": load("res://textures/bullet.png")}]
	var this_projectile: Area2D
	var speed: int
	var damage: int
	var lifetime_max: int
	var special: bool
	var direction: Vector2
	var lifetime_current: int
	
	
	func _init(start_pos, aim_direction, projectile_ID):
		
		this_projectile = Area2D.new()
		position = start_pos
		rotation_degrees = rad_to_deg(aim_direction.angle()) + 90
		scale *= 0.5
		
		#add sprite
		var sprite = Sprite2D.new()
		sprite.texture = projectile_properties[projectile_ID]["texture"]
		add_child(sprite)
		
		#add collision
		var hitbox = CollisionShape2D.new()
		hitbox.shape = RectangleShape2D.new()
		hitbox.shape.size = Vector2(4, 8)
		add_child(hitbox)
		
		speed = projectile_properties[projectile_ID]["speed"]
		damage = projectile_properties[projectile_ID]["damage"]
		lifetime_max = projectile_properties[projectile_ID]["lifetime"]
		special = projectile_properties[projectile_ID]["special"]
		direction = aim_direction
		lifetime_current = lifetime_max
		
	
	func update(delta):
		
		position += direction * speed * delta
		lifetime_current -= 1
		
		if lifetime_current == 0: deactivate()
	
	
	func activate(start_pos, direction):
		
		lifetime_current = lifetime_max
	
	func deactivate():
		
		pass
	
	
