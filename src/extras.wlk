import wollok.game.*
import barry.*
import posiciones.*
import randomizer.*
import menu.*

object generadorDeObjetos {
    method construirMisil() {
        const misil = new Misil(position = game.at(12, randomizer.anyY()), imagenes = ["misil1.png", "misil2.png", "misil3.png", "misil4.png", "misil5.png", "misil6.png"])
        game.addVisual(misil)
        game.onTick(300, "misil", {misil.mover(izquierda)})
        game.onTick(60, "misil", {misil.cambiarImagen()})
    }

    method construirMoneda() {
        const coin = new Coin(position = game.at(12, randomizer.anyY()), imagenes = ["7.png","2.png","3.png","4.png","5.png","6.png"])
        game.addVisual(coin)
        game.onTick(60, "coin", {coin.cambiarImagen()})
        game.onTick(400, "coin", {coin.mover(izquierda)})
    }

    method construirToken() {
        const token = new Token(position = game.at(12, randomizer.anyY()), imagenes = ["token.png","token1.png","token2.png","token3.png","token4.png","token5.png","token6.png","token7.png","token8.png","token9.png","token10.png"])
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

class ObjetoVolador {
    var property position
    const property imagenes
    var property imagenActualIndex = 0
    var property visible = true

    method cambiarImagen() {
        imagenActualIndex = (imagenActualIndex + 1) % imagenes.size()
    }

    method mover(direccion) {
        const nuevaPosicion = direccion.siguiente(self.position()) 
        
        tablero.validarDentro(nuevaPosicion) // Validar el movimiento
        self.position(nuevaPosicion) // Actualizar la posición

        // Verifica si el objeto llegó al borde izquierdo
        if (self.saliDelTablero()){ 
            self.llegoAlBorde()
        }
    }

    method llegoAlBorde() {
        game.removeVisual(self) // Elimina el objeto actual
        game.removeTickEvent(self.tipo()) // Elimina el onTick
    }

    method saliDelTablero() {
        return self.position().x() == -1
    }

    method desaparecer() {
        visible = false
        game.removeVisual(self)
    }

    method image() {
        return if (visible) imagenes.get(imagenActualIndex) else null
    }

    method reaparecer()
    method tipo() 
}

class Misil inherits ObjetoVolador {

    override method image() {
        return imagenes.get(imagenActualIndex)
    }

    override method tipo() {
        return "misil"
    }

    override method llegoAlBorde() {
        super()
        self.reaparecer()
    }

    override method reaparecer() {
        generadorDeObjetos.construirMisil()
        generadorDeObjetos.construirMisil()
    }

    method colisiono(personaje) {
        if (contadorVidasBarry.vidas() == 1){
            game.schedule(200, {administrador.pararJuegoYMostrarGameOver()})
        } else if (contadorVidasBarry.vidas() >= 3){
            administrador.sacarVida(1)
        } else if (contadorVidasBarry.vidas() == 2){
            personaje.transformacion().colisiono(personaje)
        }
    }
}

class Token inherits ObjetoVolador {

    override method tipo() {
        return "token"
    }

    override method llegoAlBorde() {
        super()
        game.schedule(45500, {self.reaparecer()})
    }

    override method reaparecer() {
        generadorDeObjetos.construirToken()
    }

    method colisiono(personaje) {
        self.desaparecer()
        personaje.transformarse()
    }

}
class Coin inherits ObjetoVolador {

    override method tipo() {
        return "coin"
    }

    override method llegoAlBorde() {
        super()
        self.reaparecer()
    }

    override method reaparecer() {
        generadorDeObjetos.construirMoneda()
        generadorDeObjetos.construirMoneda()
    }

    method colisiono(personaje) {
        self.desaparecer()
        personaje.agarroMoneda()
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