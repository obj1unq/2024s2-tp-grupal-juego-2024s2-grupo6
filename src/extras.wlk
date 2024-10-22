import wollok.game.*
import barry.*
import posiciones.*
import randomizer.*
import menu.*

object generadorDeObjetos {
    method construirReloj() {
        game.onTick(1000, "reloj", {reloj.tick()})
    }

    method gravedad() {
        game.onTick(100, "gravedad", {barry.caer()}) 
    }

    /*
    method subirGravedad() {
        game.onTick(50, "subirGravedad", {barry.volar()})
    }

    method bajarGravedad() {
        game.onTick(50, "bajarGravedad", {barry.caer()})
    }
    */
}

class Generador {
    method construir() {
        const nuevoObjeto = self.instanciar() 
        nuevoObjeto.position(self.position())
        nuevoObjeto.imagenes(self.imagenes())
        nuevoObjeto.generador(self)
        nuevoObjeto.aparecer(self.frecuenciaDeImagen(), self.frecuenciaDeMovimiento())
    }

    method instanciar()
    method position() {
        return game.at(12, randomizer.anyY())
    }

    method imagenes()

    method frecuenciaDeImagen() {
        return 60 
    }

    method frecuenciaDeMovimiento() {
        return 300
    }
}

object generadorDeMisiles inherits Generador{
    var property velocidad = 300
    
    override method instanciar() {
        return new Misil()
    }

    override method imagenes() {
        return ["misil1.png", "misil2.png", "misil3.png", "misil4.png", "misil5.png", "misil6.png"]
    }

    method aumentarVelocidad() {
        velocidad -= 20
    }

    override method frecuenciaDeMovimiento() {
        return velocidad
    }
}

object generadorDeMonedas inherits Generador{
    override method instanciar() {
        return new Coin()
    }

    override method imagenes() {
        return ["7.png","2.png","3.png","4.png","5.png","6.png"]
    }

    override method frecuenciaDeMovimiento() {
        return 400
    }
}

object generadorDeTokens inherits Generador{
    override method instanciar() {
        return new Token()
    }

    override method imagenes() {
        return ["token.png","token1.png","token2.png","token3.png","token4.png","token5.png","token6.png","token7.png","token8.png","token9.png","token10.png"]
    }

    override method frecuenciaDeImagen() {
        return 20
    }
}

class ObjetoVolador {
    var property position = null
    var property imagenes = null
    var property imagenActualIndex = 0
    var property generador = null

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
        self.desaparecer()
        self.reaparecer()
    }

    method saliDelTablero() {
        return self.position().x() == -1
    }

    method desaparecer() {
        //visible = false //revisar
        game.removeVisual(self) // Elimina el objeto actual
        game.removeTickEvent(self.nombreDeEventoMovimiento()) // Elimina el onTick de movimiento
        game.removeTickEvent(self.nombreDeEventoImagen()) // Elimina el onTick de imagen
    }

    method image() {
        return imagenes.get(imagenActualIndex) //if (visible) imagenes.get(imagenActualIndex) else null
    }

    method aparecer(frecuenciaImagen, frecuenciaMovimiento) {
        game.addVisual(self)
        game.onTick(frecuenciaMovimiento, self.nombreDeEventoMovimiento(), {self.mover(izquierda)})
        game.onTick(frecuenciaImagen, self.nombreDeEventoImagen(), {self.cambiarImagen()})
    }

    method nombreDeEventoMovimiento() {
        return self.prefijoDeEvento() + "Movimiento" + self.identity()
    }

    method nombreDeEventoImagen() {
        return self.prefijoDeEvento() + "Imagen" + self.identity()
    }

    method reaparecer() {
        generador.construir()
    }

    method prefijoDeEvento() 
}

class Misil inherits ObjetoVolador {

    override method image() {
        return imagenes.get(imagenActualIndex)
    }

    override method prefijoDeEvento() {
        return "misil"
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

    override method prefijoDeEvento() {
        return "token"
    }

    override method reaparecer() {
        game.schedule(45500, {self.reaparecerDiferido()})
    }

    method reaparecerDiferido() {
        generador.construir()
    }

    method colisiono(personaje) {
        self.desaparecer()
        personaje.transformarse()
        self.reaparecer()
    }
}

class Coin inherits ObjetoVolador {

    override method prefijoDeEvento() {
        return "coin"
    }

    method colisiono(personaje) {
        self.desaparecer()
        personaje.agarroMoneda()
        self.reaparecer()
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