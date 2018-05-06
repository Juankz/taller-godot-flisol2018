extends Node2D

export var TIEMPO_MAX = 1
signal pego

func _ready():
	$AnimationPlayer.current_animation = "aparece"
	pass

func _input(event):
	if event.is_action_pressed("disparo"):
		var pos_mouse = get_viewport().get_mouse_position()
		var tamano_obj = $Obj.texture.get_size()*self.scale
		var pos_obj = $Obj.global_position - tamano_obj*0.5
		var area = Rect2(pos_obj,tamano_obj)
		if area.has_point(pos_mouse):
			emit_signal("pego")
			$AnimationPlayer.play("punto")
			$Timer.stop()

func _on_Timer_timeout():
	$AnimationPlayer.play("Desaparece")
	
func empezar_timer():
	$Timer.start()

func remover():
	self.queue_free()