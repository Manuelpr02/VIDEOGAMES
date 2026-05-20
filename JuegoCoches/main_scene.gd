extends Node2D

# 1. Referencias a la interfaz de Vueltas (VBoxContainer original)
@onready var lbl_c1 = $Vueltas/VBoxContainer/Coche1
@onready var lbl_c2 = $Vueltas/VBoxContainer/Coche2
@onready var lbl_c3 = $Vueltas/VBoxContainer/Coche3
@onready var lbl_user = $Vueltas/VBoxContainer/Coche4

# 2. Referencia al nuevo Cronómetro (Asegúrate de que el nombre coincida)
# He añadido una ruta común, cámbiala si tu segundo VBox se llama distinto
@onready var lbl_crono = $Vueltas/VBoxContainer2/Cronometro

# 3. Referencias a los nodos de los coches y el usuario
@onready var c1_follow = $Coche1/Path2D/PathFollow2D
@onready var c2_follow = $Coche2/Path2D/PathFollow2D
@onready var c3_follow = $Coche3/Path2D/PathFollow2D
@onready var user_node = $Usuario

# Variables de tiempo
var tiempo_total = 0.0
var carrera_activa = true

func _process(delta):
	# --- Lógica del Cronómetro ---
	if carrera_activa:
		tiempo_total += delta
		actualizar_crono()

	# --- Actualización de Vueltas ---
	# Usamos los nombres de colores que pediste
	if lbl_c1: lbl_c1.text = "Coche Negro: " + str(c1_follow.contador_vueltas)
	if lbl_c2: lbl_c2.text = "Coche Verde: " + str(c2_follow.contador_vueltas)
	if lbl_c3: lbl_c3.text = "Coche Amarillo: " + str(c3_follow.contador_vueltas)
	if lbl_user: lbl_user.text = "Coche Rojo: " + str(user_node.contador_vueltas)

func actualizar_crono():
	var minutos = int(tiempo_total / 60)
	var segundos = int(tiempo_total) % 60
	var centesimas = int((tiempo_total - int(tiempo_total)) * 100)
	
	if lbl_crono:
		lbl_crono.text = "%02d:%02d.%02d" % [minutos, segundos, centesimas]

# 3. Función de la Meta
func _on_meta_body_entered(body):
	if body == user_node:
		if user_node.has_method("sumar_vuelta"):
			user_node.sumar_vuelta()
	else:
		# Verificamos que el padre existe antes de preguntar por el método
		var padre = body.get_parent()
		if padre and padre.has_method("sumar_vuelta"):
			padre.sumar_vuelta()
