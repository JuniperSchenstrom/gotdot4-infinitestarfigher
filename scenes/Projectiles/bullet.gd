extends Area2D

var speed: int = 2000
var direction: Vector2
var lifetime: int = 2000


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position += direction * speed * delta
	
	lifetime -= 1
	if lifetime == 0:
		queue_free()
