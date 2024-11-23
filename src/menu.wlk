import wollok.game.*
import barry.*
import posiciones.*
import extras.*
import randomizer.*

object administradorEscudo {

    method equiparEscudo(personaje) {
        if (self.validarEscudo()) {
            personaje.equiparseEscudo()
        }
    }

    method validarEscudo() {
        return contadorMonedas.tieneSuficienteParaEscudo(fondoJuego.nivel()) //Está hecho asi porque la validación en wollokGame no nos funcionaba muy bien.
    }
}

object administrador {
    method pararJuegoYMostrarGameOver() {
        menu.sonido().stop()
        game.removeVisual(botonPlay)
	    game.addVisual(fondoFinish)
        game.addVisual(hasVolado)
	    game.addVisual(gameOver)
        game.sound("gameover.mp3").play()
        reloj.position(game.at(5,7))
        contadorMonedas.position(game.at(6,2))
        contadorVidas.position(game.at(11,11))
	    game.schedule(100,{game.stop()})
    }

    method sonidoWin() {
        game.sound("musicawin.mp3").play()
    }

    method sonidoGameOver() {
        game.sound("gameover.mp3").play()
    }
} 

object contadorMonedas {
    var property monedas = 0
    var property position = game.at(0,8)

    method text() {
        return monedas.toString() +"\n" + "\n" + "\n"
    }

    method textColor() {
        return "FFFF00FF"
    }

    method tieneSuficienteParaEscudo(nivel) {
        return (monedas >= 25 * (nivel-1))
    }
}

object contadorVidas {
    var property position = game.at(0,8)
    
    method vidas(personaje) {
        return personaje.vidas()
    }

    method text() {
        return self.vidas(barry).toString()
    }

    method textColor() {
        return "FF0000FF"
    }
}

object fondoMenu {
	method image() {
        return "menu.png"
    }

    method position() = game.at(0,0)
}

object hasVolado {
    method image() {
        return "Volado.png"
    } 

    method position() = game.at(4,8)
}

object fondoFinish {
	method image() {
        return "recuentoMonedascopia1.png"
    }

    method position() = game.at(1,1)
}

object fondoJuego {
    var property nivel = 1

    method image() {
        return "fondoo" + nivel + ".png"
    }

    method subirNivel() {
        game.sound("levelup.mp3").play()
        nivel += 1
    }

    method position() = game.at(0,0)
}

object botonPlay {
    method image() {
        return "play.png"
    }

    method position() = game.at(4,1)
}

object gameOver {
    method image() {
        return "gameover.png"
    }

    method position() = game.at(6,10)
}
object menu {
    var property juegoIniciado = false
    const property sonido = game.sound("MainTheme.mp3")

    method init() {
        game.title("Jetpack Joyride")
	    game.height(10)
	    game.width(12)
	    game.cellSize(50)
        
        game.addVisual(fondoMenu) // Mostrar el fondo del menú
        game.addVisual(botonPlay)
        // Configurar la acción para iniciar el juego cuando se presiona "Enter"
        keyboard.enter().onPressDo({self.startGame()})// Iniciar el juego al presionar "Enter"
    }

    method startGame() {
        self.juegoIniciado(true) // Marcar el juego como iniciado
        game.removeVisual(fondoMenu) // Limpiar visuales del menú
        game.removeVisual(botonPlay)
        sonido.shouldLoop(true)
        sonido.play()
        // Llamar a la función de inicialización del juego
        self.iniciarJuego()
    }


    method iniciarJuego() {
	    game.addVisual(fondoJuego)
	    game.addVisual(reloj)
	    game.addVisual(barry)
        game.addVisual(contadorMonedas)
        game.addVisual(contadorVidas)

	    // Crear instancias de clases
        generadorDeMisiles.construir()
        game.schedule(1000, {generadorDeMisiles.construir()})
        game.onTick(50000, "masMisiles" ,{generadorDeMisiles.construir()})
        game.onTick(50000, "masVelocidad" ,{generadorDeMisiles.aumentarVelocidad()})
	    generadorDeMonedas.construir()
        game.schedule(500, {generadorDeMonedas.construir()})
        game.schedule(700, {generadorDeMonedas.construir()})
        game.schedule(1000, {generadorDeMonedas.construir()})
        game.schedule(1500, {generadorDeMonedas.construir()})
        game.schedule(2000, {generadorDeMonedas.construir()})
        game.schedule(25000, {generadorDeTokens.construir()})
        generadorDeObjetos.construirReloj()
        generadorDeObjetos.gravedad()
        

	    keyboard.up().onPressDo({barry.volar()})
        keyboard.space().onPressDo({barry.lanzarPoder()})
  
        game.onTick(50000, "fondo", {fondoJuego.subirNivel()})
        game.onTick(50100, "barryescudo", {administradorEscudo.equiparEscudo(barry)})
        game.schedule(250200, {administrador.pararJuegoYMostrarGameOver() administrador.sonidoWin()})
        // Colisiones
        game.onCollideDo(barry, {cosa => cosa.colisiono(barry)}) 
    }
}