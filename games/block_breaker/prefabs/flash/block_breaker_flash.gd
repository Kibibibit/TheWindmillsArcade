extends AnimatedSprite2D
class_name BlockBreakerFlash

func _ready() -> void:
	self.animation_finished.connect(_delete)
	self.frame = 0
	self.play("default")
	


func _delete() -> void:
	self.get_parent().remove_child(self)
	self.queue_free()
