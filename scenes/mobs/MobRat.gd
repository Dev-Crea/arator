extends Node2D

# warning-ignore:unused_signal
signal hit(damage)

const VALUE = 1

onready var life = 15
onready var velocity = 35
onready var mobPathLocation = get_parent()

func _ready():
	$AnimatedSprite.play("walk")
	# warning-ignore:return_value_discarded
	$explode.connect("animation_finished", self, "detach_animation_ended")
	
	if !Values.is_connected("buy", Values, "update_coins"):
		# warning-ignore:return_value_discarded
		Values.connect("buy", Values, "update_coins")

func _physics_process(delta):
	mobPathLocation.set_offset(mobPathLocation.get_offset() + velocity * delta)

func _on_Node2D_hit(damage):
	life -= damage
	$AnimatedSprite.play("hurt")
	$explode.playing = true
	$explode.visible = true

func detach_animation_ended():
	Values.coins += VALUE
	Values.emit_signal("buy")
	self.queue_free()
