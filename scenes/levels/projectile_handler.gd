extends Node2D

#NOTE: One of each of these arrays is needed for every projectile type because for some reason GDScript doesn't support nested arrays
var projectiles_ID_0: Array[Projectile] = []
var projectiles_ID_0_num_inactive: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    if len(projectiles_ID_0) > 0:
        
        for i in range(0, len(projectiles_ID_0)):
            
            if projectiles_ID_0[i].lifetime_current > 0:
                
                projectiles_ID_0[i].update(delta)
            
            elif projectiles_ID_0[i].lifetime_current == 0:
                
                projectiles_ID_0[i].deactivate()
                projectiles_ID_0_num_inactive += 1


func _on_player_fire(start_pos, fire_direction, projectile_ID):
    
    #NOTE: Add an elif for every projectile ID
    if projectile_ID == 0 and projectiles_ID_0_num_inactive > 0:
        
        for i in range(0, len(projectiles_ID_0)):
            
            if projectiles_ID_0[i].lifetime_current == 0:
                
                projectiles_ID_0[i].activate(start_pos, fire_direction)
                projectiles_ID_0_num_inactive -= 1
                break
        
    else:
        
        var projectile_new = Projectile.new(start_pos, fire_direction, projectile_ID)
        projectiles_ID_0.append(projectile_new)
        add_child(projectile_new)

class Projectile extends Area2D:
    
    #INFO: each element of the array is a dictionary containing the properties of a projectile with an ID of the index that dictionary is located at
    static var projectile_properties: Array[Dictionary] = [{"type": "bullet_basic", "speed": 50, "damage": 10, "lifetime": 200, "special": true, "texture": load("res://textures/bullet.png")}]
    var this_projectile: Area2D
    var sprite: Sprite2D
    var hitbox: CollisionShape2D
    var speed: int
    var damage: int
    var lifetime_max: int
    var special: bool
    var direction: Vector2
    var lifetime_current: int
    
    
    func _init(start_pos, aim_direction, projectile_ID):
        
        if projectile_ID > len(projectile_properties):
            projectile_ID = 0
        
        this_projectile = Area2D.new()
        position = start_pos
        rotation_degrees = rad_to_deg(aim_direction.angle()) + 90
        scale *= 0.5
        
        #add sprite
        sprite = Sprite2D.new()
        sprite.texture = projectile_properties[projectile_ID]["texture"]
        add_child(sprite)
        
        #add collision
        hitbox = CollisionShape2D.new()
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
    
    
    func activate(start_pos, aim_direction):
        
        position = start_pos
        rotation_degrees = rad_to_deg(aim_direction.angle()) + 90
        sprite.visible = true
        hitbox.disabled = false
        direction = aim_direction
        lifetime_current = lifetime_max
    
    func deactivate():
        
        sprite.visible = false
        hitbox.disabled = true
        lifetime_current = -1
    
    
