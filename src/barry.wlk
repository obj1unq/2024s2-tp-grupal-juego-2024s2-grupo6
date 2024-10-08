import wollok.game.*
import posiciones.*
import extras.*
import menu.*

object barry {
	var property position = game.at(1,5)
	var property imagenActual = "barrynormal.png"
	const property imagenes = ["barrysupersj1.png", "barrysupersj2.png", "barrysupersj3.png","barrysupersj4.png"]
	var property imagenActualIndex = 0
	
	var property transformacion = "normal"
	
	method image() {
		return if (transformacion == "ssj"){
			imagenes.get(imagenActualIndex)
		}
		else imagenActual
	}

	method cambiarImagen() {
        imagenActualIndex = (imagenActualIndex + 1) % imagenes.size()
    }

	method mover(direccion) {
        var nuevaPosicion = direccion.siguiente(self.position()) 
        tablero.validarDentro(nuevaPosicion) // Validar el movimiento
        self.position(nuevaPosicion) // Actualizar la posición 
    }

	method volar() {
	  self.mover(arriba)
	  
	  	imagenActual = "barryvolando.png"
		
	}
	
    method caer() {
	  self.mover(abajo)
	  
		
	  	imagenActual = "barrynormal.png"
		
		
	
	}
	
	method transformarse() {

		transformacion = "ssj"
		administrador.sumarVida(2)
		game.onTick(60, "ssjimagen", {self.cambiarImagen()})
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
		transformacion = "normal"
		
		
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