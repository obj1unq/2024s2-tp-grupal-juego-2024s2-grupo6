import wollok.game.*
import barry.*
import posiciones.*
import randomizer.*
import menu.*

class Misil {
    var property position = game.at(9, 5)
    const property imagenes = ["misil1.png", "misil2.png", "misil3.png", "misil4.png", "misil5.png", "misil6.png"]
    var property imagenActualIndex = 0

    method image() {
        return imagenes.get(imagenActualIndex)
    }

    method tipo() {
        return "Misil"
    }
    
    method cambiarImagen() {
        imagenActualIndex = (imagenActualIndex + 1) % imagenes.size()
    }

    method mover(direccion) {
        var nuevaPosicion = direccion.siguiente(self.position()) 
        
        tablero.validarDentro(nuevaPosicion) // Validar el movimiento
        self.position(nuevaPosicion) // Actualizar la posición

        // Verifica si el misil llegó al borde izquierdo
        if (self.saliDelTablero()){ 
            game.removeVisual(self) // Elimina el misil actual
            game.removeTickEvent("misil") // Elimina el onTick
            self.reaparecer() // Llama al método para reaparecer
        }
    }
    method saliDelTablero() {
        return self.position().x() == -1
    }

    method reaparecer() {
        generadorDeObjetos.construirMisil()
        generadorDeObjetos.construirMisil()
    }

    method colisiono(personaje) {
        if (contadorVidasBarry.vidas() == 1){
            game.schedule(200, {self.pararJuegoYMostrarGameOver()})
        } else if (contadorVidasBarry.vidas() >= 3){
            administrador.sacarVida(1)
        } else if (contadorVidasBarry.vidas() == 2){
            personaje.transformacion().colisiono(personaje)
        }
    }

    method pararJuegoYMostrarGameOver() {
		game.removeVisual(botonPlay)
		//game.removeVisual(fondoJuego)
		game.addVisual(fondoFinish)
        game.addVisual(hasVolado)
		game.addVisual(gameOver)
        reloj.position(game.at(5,7))
        contadorMonedas.position(game.at(6,2))
        contadorVidasBarry.position(game.at(11,11))
		game.schedule(100,{game.stop()})
	}
}

object generadorDeObjetos {
    method construirMisil() {
        var misil = new Misil(position = game.at(12, randomizer.anyY()))
        game.addVisual(misil)
        game.onTick(300, "misil", {misil.mover(izquierda)})
        game.onTick(60, "misil", {misil.cambiarImagen()})
      
    }

    method constuirMoneda() {
        var coin = new Coin(position = game.at(12, randomizer.anyY()))
        game.addVisual(coin)
        game.onTick(60, "coin", {coin.cambiarImagen()})
        game.onTick(400, "coin", {coin.mover(izquierda)})
      
    }

    method construirToken() {
        var token = new Token(position = game.at(12, randomizer.anyY()))
        game.addVisual(token)
        game.onTick(20, "token", {token.cambiarImagen()})
	    game.onTick(300, "token", {token.mover(izquierda)})
      
    }

    method construirReloj() {
        game.onTick(1000, "reloj", {reloj.tick()})
      
    }

    method gravedad() {
        game.onTick(130, "gravedad", {barry.caer()}) 
    }
  
}

class Token {
    var property position = game.at(9,7)
    const property imagenes = ["token.png","token1.png","token2.png","token3.png","token4.png","token5.png","token6.png","token7.png","token8.png","token9.png","token10.png"]
    var property imagenActualIndex = 0
    var property visible = true

    method image() {
        return if (visible) imagenes.get(imagenActualIndex) else null
    }

    method tipo() {
        return "Token"
    }

    method cambiarImagen() {
        imagenActualIndex = (imagenActualIndex + 1) % imagenes.size()
    }

    method mover(direccion) {
        var nuevaPosicion = direccion.siguiente(self.position()) 
        
        tablero.validarDentro(nuevaPosicion) // Validar el movimiento
        self.position(nuevaPosicion) // Actualizar la posición

        // Verifica si el misil llegó al borde izquierdo
        if (self.saliDelTablero()){ 
            game.removeVisual(self) // Elimina el token actual
            game.removeTickEvent("token") // Elimina el onTick
            game.schedule(45500, {self.reaparecer()})
            // Llama al método para reaparecer
        }
    }
    method saliDelTablero() {
        return self.position().x() == -1
    }

    method reaparecer() {
        generadorDeObjetos.construirToken()
    }

    method colisiono(personaje) {
        self.desaparecer()
        barry.transformarse()
        
    }

    method desaparecer() {
        visible = false
        game.removeVisual(self)
    }

}
class Coin {
    var property position = game.at(9,3)
    const property imagenes = ["7.png","2.png","3.png","4.png","5.png","6.png"]
    var property imagenActualIndex = 0
    var property visible = true // Propiedad para saber si está visible

    method image() {
        return if (visible) imagenes.get(imagenActualIndex) else null
    }

    method tipo() {
        return "Coin"
    }

    method cambiarImagen() {
        imagenActualIndex = (imagenActualIndex + 1) % imagenes.size()
    }

    method mover(direccion) {
        var nuevaPosicion = direccion.siguiente(self.position()) 
        
        tablero.validarDentro(nuevaPosicion) // Validar el movimiento
        self.position(nuevaPosicion) // Actualizar la posición

        // Verifica si el misil llegó al borde izquierdo
        if (self.saliDelTablero()){ 
            game.removeVisual(self) // Elimina el coin actual
            game.removeTickEvent("coin") // Elimina el onTick
            self.reaparecer()
            // Llama al método para reaparecer
        }
    }
    method saliDelTablero() {
        return self.position().x() == -1
    }   

    method reaparecer() {
        // Genera una nueva posición aleatoria en el eje Y
        generadorDeObjetos.constuirMoneda()
        generadorDeObjetos.constuirMoneda()
    }

    method colisiono(personaje) {
        self.desaparecer()
        administrador.sumarMoneda()
    }

    method desaparecer() {
        visible = false // Desactivar la visibilidad
        game.removeVisual(self) // Quitar visualmente el objeto
    }
}

object fondo {
    method position() = game.at(0,0)

    method image() {
        return "fondo123.png"
    }
}

object reloj {
    var property segundos = 0
    var property position = game.at(0,9)
    

    method text() {
        return segundos.toString()
    }

    method textColor() {
        return "FFFFFFFF"
    }

    method tick() {
        segundos = (segundos + 1) % 1000
    }

    method colisiono(personaje) {

    }


}