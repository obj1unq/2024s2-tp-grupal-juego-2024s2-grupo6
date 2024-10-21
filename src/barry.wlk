import wollok.game.*
import posiciones.*
import extras.*
import menu.*

object barry {
	var property position = game.at(1,5)
	var property transformacion = normal

	method image() {
		return transformacion.image()
	}

	method mover(direccion) {
        const nuevaPosicion = direccion.siguiente(self.position()) 
        tablero.validarDentro(nuevaPosicion) // Validar el movimiento
        self.position(nuevaPosicion) // Actualizar la posición 
    }

	method volar() {
	  	self.mover(arriba)
		normal.image("barryvolando.png")
	}
	
    method caer() {
	  	self.mover(abajo)
	  	normal.image("barrynormal.png")
	}
	
	method transformarse() {
		transformacion = ssj
		administrador.sumarVida(2)
		game.onTick(60, "ssjimagen", {ssj.cambiarImagen()})
		game.schedule(20000, {self.destransformarse()})
		game.schedule(20000, {contadorVidasBarry.vidas(1)})


		/*if (0.randomUpTo(100) < 30) {
        transformacion = "ssj"  // 30% de probabilidad de convertirse en ssj
		contadorVidasBarry.agregarVidas(2)
		game.onTick(60, "ssjimagen", {self.cambiarImagen()} )
    } else {
        transformacion = "gravedad"  // 70% de probabilidad de convertirse en gravedad
		game.removeTickEvent("gravedad")
		contadorVidasBarry.agregarVidas(1)
    }	*/	
}

	method destransformarse() {
		transformacion = normal
	}

	method agarroMoneda() {
		administrador.sumarMoneda()
	}

	//method subirGravedad() {
	//	generadorDeObjetos.gravedad()
	//	imagenActual = "gravity1.png"
	//}

	//method bajarGravedad() {
	//	game.removeTickEvent("gravedad")
	//	imagenActual = "gravity2.png"
	//}
}

object normal {
	var property image = "barrynormal.png"
}

object ssj {
	const property imagenes = ["barrysupersj1.png", "barrysupersj2.png", "barrysupersj3.png","barrysupersj4.png"]
	var property imagenActualIndex = 0

	method image() {
		return imagenes.get(imagenActualIndex)
	}

	method cambiarImagen() {
        imagenActualIndex = (imagenActualIndex + 1) % imagenes.size()
    }

	method colisiono(personaje) {
		administrador.sacarVida(1)
        personaje.destransformarse()
        game.removeTickEvent("ssjimagen")
	}
}

object gravedad {
	method colisiono(personaje) {
		administrador.sacarVida(1)
        generadorDeObjetos.gravedad()
        personaje.destransformarse()
	}
}