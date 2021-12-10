extends Node2D

# warning-ignore:unused_signal
signal hit(damage)

const VALUE = 1

onready var life = 15
onready var velocity = 35
onready var mobPathLocation = get_parent()
onready var offset = 0

func _ready():
	$AnimatedSprite.play("walk")
	# warning-ignore:return_value_discarded
	$explode.connect("animation_finished", self, "detach_animation_ended")
	
	if !Values.is_connected("buy", Values, "update_coins"):
		# warning-ignore:return_value_discarded
		Values.connect("buy", Values, "update_coins")

#func _physics_process(delta):
#	#if offset == 0:
#	#	offset = velocity * delta
#	#else:
#	#	offset += velocity * delta
#	mobPathLocation.offset += velocity * delta
#	# mobPathLocation.set_offset(mobPathLocation.get_offset() + velocity * delta)
#	# pathToFollow.offset += 350 * delta

func _on_Node2D_hit(damage):
	life -= damage
	$AnimatedSprite.play("hurt")
	$explode.playing = true
	$explode.visible = true

func detach_animation_ended():
	Values.coins += VALUE
	Values.emit_signal("buy")
	self.queue_free()
