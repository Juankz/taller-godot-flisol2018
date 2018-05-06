extends Node2D

const ObjetivoPeq = preload("res://objetos/ObjetivoPeq.tscn")
const ObjetivoGrande = preload("res://objetos/ObjetivoGrande.tscn")

onready var titulo_inicio = $Presentacion/Titulo.text
var puntaje = 0
var tiempo = 30 #Tiempo en segundos
onready var pos_obj_peq = $ObjetosLejanos.position
onready var pos_obj_gran = $ObjetosCercanos.position
func _ready():
	randomize()
	get_tree().paused = true
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	var pos_mouse = get_viewport().get_mouse_position()
	$Escopeta/Mira.position = pos_mouse
	$Escopeta/Arma.position.x = pos_mouse.x + 200
	$Escopeta/Arma.position.y = pos_mouse.y/10 + 550

func _input(event):
	if event.is_action_pressed("disparo"):
		$Escopeta/AudioStreamPlayer2D.play(0)
		
func punto():
	puntaje += 1
	$HUD/Puntaje.text = str(puntaje)

func crear_objetivo():
#	randomize()
	var aleatorio = randf()
	var nuevo_objetivo
	if aleatorio > 0.5:
		nuevo_objetivo = ObjetivoPeq.instance()
		nuevo_objetivo.position = Vector2(pos_obj_peq.x,pos_obj_peq.y)
		nuevo_objetivo.position.y -= 100
	else:
		nuevo_objetivo = ObjetivoGrande.instance()
		nuevo_objetivo.position = pos_obj_gran
		
		
	var max_x = get_viewport().get_visible_rect().end.x - 120
	nuevo_objetivo.position.x = 100 + randi() % 700
	$ObjetosLejanos.add_child(nuevo_objetivo)
	nuevo_objetivo.connect("pego",self,"punto")


func _reiniciar_contador():
	$Timer.wait_time = rand_range(0.25,1)


func _segundo_transcurrido():
	tiempo -= 1
	$HUD/Tiempo.text = "00:"+str(tiempo)
	if(tiempo<=0):
		get_tree().paused = true
		$Presentacion/Titulo.text = "Fin del Juego \n Tu puntaje fue: "+str(puntaje)
		$Presentacion/Button.text = "Jugar de nuevo"
		$Presentacion/AnimationPlayer.play_backwards("abrir_telon")


func iniciar_juego():
	$"Presentacion/AnimationPlayer".play("abrir_telon")
	get_tree().paused = false
	inicializar_variables()

func inicializar_variables():
	puntaje = 0
	tiempo = 30
	$Presentacion/Titulo.text = titulo_inicio
	$Presentacion/Button.text = "Jugar"