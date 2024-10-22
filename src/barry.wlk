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
	  	transformacion.volar()
	}
	
    method caer() {
	  	transformacion.caer()
	}
	
	method transformarse() {
		
		transformacion = ssj
		administrador.sumarVida(2)
		game.onTick(60, "ssjimagen", {ssj.cambiarImagen()})
		game.schedule(20000, {self.destransformarse()})
		game.schedule(20000, {contadorVidasBarry.vidas(1)})
		
		/*
		transformacion = gravedad
		game.removeTickEvent("gravedad")
		//game.onTick(50, "subirGravedad", {self.volar()})
		administrador.sumarVida(1)
		game.schedule(20000, {self.destransformarse()})
		game.schedule(20000, {contadorVidasBarry.vidas(1)})

		if (0.randomUpTo(100) < 30) {
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
		//game.removeTickEvent("bajarGravedad")
		//game.removeTickEvent("subirGravedad")
		//generadorDeObjetos.gravedad()
	}

	method agarroMoneda() {
		administrador.sumarMoneda()
	}
}

object normal {
	var property image = "barrynormal.png"

	method volar() {
		barry.mover(arriba)
		image = "barryvolando.png"
	}

	method caer() {
	  	barry.mover(abajo)
	  	image = "barrynormal.png"
	}
}

object ssj {
	const property imagenes = ["barrysupersj1.png", "barrysupersj2.png", "barrysupersj3.png","barrysupersj4.png"]
	var property imagenActualIndex = 0

	method volar() {
		barry.mover(arriba)
	}

	method caer() {
	  	barry.mover(abajo)
	}

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
	var property image = "gravity1.png"

	method volar() {
		barry.mover(arriba)
		image = "gravity2.png"
		game.removeTickEvent("bajarGravedad")
	}

	method caer() {
	  	barry.mover(abajo)
		image = "gravity1.png"
		game.removeTickEvent("subirGravedad")
	}
	/*
	method subirGravedad() {
		game.removeTickEvent("bajarGravedad")
		generadorDeObjetos.subirGravedad()
	}

	method bajarGravedad() {
		game.removeTickEvent("subirGravedad")
		generadorDeObjetos.bajarGravedad()
	}
	*/
	method colisiono(personaje) {
		administrador.sacarVida(1)
        generadorDeObjetos.gravedad()
        personaje.destransformarse()
	}
}