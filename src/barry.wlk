import wollok.game.*
import posiciones.*
import extras.*
import menu.*

object barry {
	var property position = game.at(1,5)
	var property transformacion = normal
	var property vidas = 1
	var property monedas = 0

	method image() {
		return transformacion.image()
	}

	method mover(direccion) {
        const nuevaPosicion = direccion.siguiente(self.position()) 
        tablero.validarDentro(nuevaPosicion)
        self.position(nuevaPosicion)
    }

	method volar() {
	  	transformacion.volar()
	}
	
    method caer() {
	  	transformacion.caer()
	}

	method equiparseEscudo() {
		self.transformarseA(barryConEscudo)
	}

	method transformarse() {
		if (0.randomUpTo(100) < 30) {
			self.transformarseA(ssj)
			game.onTick(60, "ssjimagen", {ssj.cambiarImagen()})
		} else if(0.randomUpTo(100) < 50) {
			self.transformarseA(profitBird)
		} else {
			self.transformarseA(millonario)
		}
	}

	method transformarseA(_transformacion) {
		transformacion = _transformacion
		self.vidas(_transformacion.vidas())
		game.schedule(20000, {self.destransformarse()})
	}

	method destransformarse() {
		transformacion.resetear()
		transformacion = normal
		self.vidas(1)
	}

	method agarroMoneda() {
		monedas += transformacion.cantidadMonedasQueAgarra()
		contadorMonedas.monedas(monedas)
	}

	method sacarMonedas(cantidad) {
		monedas = (monedas-cantidad).max(0)
		contadorMonedas.monedas(monedas)
	}

	method lanzarPoder() {
		transformacion.lanzarPoder()
	}

	method restarVidas(vida) {
		vidas -= vida
		contadorVidas.vidas(self)
	}

	method agregarVidas(vida) {
		vidas += vida
		contadorVidas.vidas(self)
	}

	method colisiono() {
		transformacion.colisiono(self)
	}

	method esMillonario() { 
		return transformacion.esMillonario()
	}
}

class Transformacion {
	var property image
	var property vidas

	method volar() {
		barry.mover(arriba)
		self.ponerImagenVolando()
	}

	method ponerImagenVolando()
	
	method caer() {
		barry.mover(abajo)
		self.ponerImagenCayendo()
	}

	method ponerImagenCayendo()
	
	method lanzarPoder() {

	}

	method cantidadMonedasQueAgarra() {
		return 1
	}

	method colisiono(personaje) {
        personaje.destransformarse()
	}

	method esMillonario() {
		return false
	}

	method resetear() {

	}
}

object normal inherits Transformacion(image = "barrynormal.png", vidas = 1) {

	override method ponerImagenVolando() {
		image = "barryvolando.png"
	}

	override method ponerImagenCayendo() {
	  	image = "barrynormal.png"
	}

	override method colisiono(personaje) {
		game.schedule(200, {administrador.pararJuegoYMostrarResultado(perdedor)})
	}
}

object ssj inherits Transformacion (image = ["barrysupersj1.png", "barrysupersj2.png", "barrysupersj3.png","barrysupersj4.png"], vidas = 3){
	var property imagenActualIndex = 0
	var property imagenesPoder = ["ataq1.png", "ataq8.png","ataq3.png","ataq4.png","ataq8.png","ataq6.png","ataq7.png","ataq8.png"]
	var property imagenesActual = image
	var property ki = 100

	override method lanzarPoder() {
	  	self.validarLanzarPoder()
		game.removeTickEvent("ssjimagen")
		imagenesActual = imagenesPoder
		game.onTick(200, "ssjimagen", {self.cambiarImagen()})
		game.schedule(10000, {self.ponerImagenesDefault()})
		picolo.lanzarPoder()
		vegeta.lanzarPoder()
		gohan.lanzarPoder()
		self.ki(0)
	}

	method validarLanzarPoder() {
		if (not self.puedeLanzarPoder()) {
			self.error("No puedo lanzar el poder")
		}
	}

	method puedeLanzarPoder() {
		return contadorMonedas.monedas() >= 30 and self.ki() == 100
	}

	method ponerImagenesDefault() {
	 	game.removeTickEvent("ssjimagen") 
	 	imagenesActual = image
	 	game.onTick(60, "ssjimagen", {self.cambiarImagen()})
		self.imagenesDefaultPoder()
	}

	override method image() {
		return imagenesActual.get(imagenActualIndex)
	}

	method cambiarImagen() {
        imagenActualIndex = (imagenActualIndex + 1) % image.size()
    }

	override method colisiono(personaje) {
		if (personaje.vidas() == 3) {
			personaje.restarVidas(1)
		} else {
			super(personaje)
			game.removeTickEvent("ssjimagen")
		}
	}

	override method ponerImagenVolando() {

	}

	override method ponerImagenCayendo() {

	}

	override method resetear() {
		game.removeTickEvent("ssjimagen")
		ki = 100
		self.imagenesDefaultPoder()
	}

	method imagenesDefaultPoder() {
		picolo.ponerImagenesDefault()
		vegeta.ponerImagenesDefault()
		gohan.ponerImagenesDefault()
	}
}

class DragonBall {
	var property imagenes
	var property imagenActualIndex = 0
	var property position

	method agarroMoneda() {
		barry.agarroMoneda()
	}

	method image() {
		return imagenes.get(imagenActualIndex)
	}

	method cambiarImagen() {
        imagenActualIndex = (imagenActualIndex + 1) % imagenes.size()
    }

	method colisiono() {

	}

	method lanzarPoder() {
	  game.addVisual(self)
	  game.onTick(120, self.nombreDeEventoImagen(), {self.cambiarImagen()})
	  game.schedule(15000, {self.ponerImagenesDefault()})
	  game.schedule(20000, {self.ponerImagenesDefault()})
	  game.onCollideDo(self, {cosa => cosa.colisiono(self)})
	}

	method ponerImagenesDefault() {
	 game.removeTickEvent(self.nombreDeEventoImagen()) 
	 game.removeVisual(self)
	}

	method nombreDeEventoImagen() {
		return self.prefijoDeEvento() + "Imagen" + self.identity()
	}

	method prefijoDeEvento()
}

object picolo inherits DragonBall(imagenes = ["pi1.png","pi2.png","pi3.png","pi4.png","pi5.png","pi6.png","pi7.png","pi8.png","pi4.png","pi7.png","pi8.png","pi4.png","pi7.png","pi8.png"], position = game.at(8, 4) ) {
	override method prefijoDeEvento() {
		return "picolo"
	}
}

object vegeta inherits DragonBall(imagenes = ["ve1.png","ve2.png","ve3.png","ve4.png","ve5.png","ve6.png","ve7.png","ve3.png","ve4.png","ve6.png","ve7.png","ve3.png","ve4.png","ve6.png","ve7.png","ve3.png","ve4.png","ve6.png","ve7.png"], position = game.at(4, 1)){
	override method prefijoDeEvento() {
		return "vegeta"
	}
}

object gohan inherits DragonBall(imagenes = ["gohan2.png","gohan3.png","gohan4.png","gohan5.png","gohan5.png","gohan2.png","gohan3.png","gohan4.png","gohan5.png","gohan5.png","gohan2.png","gohan3.png","gohan4.png","gohan5.png","gohan5.png"], position = game.at(7, 6)){
	override method prefijoDeEvento() {
		return "gohan"
	}
}

object profitBird inherits Transformacion(image = "goldbird3.png", vidas = 2) {

	override method ponerImagenVolando() {
		image = "goldbird1.png"
	}

	override method ponerImagenCayendo() {
	  	image = "goldbird3.png"
	}

	override method cantidadMonedasQueAgarra() {
		return 2
	}
}

object barryConEscudo inherits Transformacion(image = "barrynormalconescudo.png", vidas = 2){
	
	override method ponerImagenVolando() {
		image = "barryvolandoconescudo.png"
	}

	override method ponerImagenCayendo() {
	  	image = "barrynormalconescudo.png"
	}
}

object millonario inherits Transformacion(image = "barryrich1.png", vidas = 2){

	override method ponerImagenVolando() {
		image = "barryrich2.png"
	}

	override method ponerImagenCayendo() {
	  	image = "barryrich1.png"
	}

	override method cantidadMonedasQueAgarra() {
		return 2
	}

	override method esMillonario() {
		return true
	}
}