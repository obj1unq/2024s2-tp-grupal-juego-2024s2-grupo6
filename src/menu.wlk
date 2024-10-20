import wollok.game.*
import barry.*
import posiciones.*
import extras.*
import randomizer.*

object administrador {

    method sumarMoneda() {
        contadorMonedas.agregarMoneda()
    }

    method sacarVida(vida) {
        contadorVidasBarry.restarVida(vida)
    } 

    method sumarVida(vida) {
        contadorVidasBarry.agregarVidas(vida)
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

object contadorMonedas {
    var property monedas = 0
    var property position = game.at(0,8)
  
    method agregarMoneda() {
        monedas += 1
    }

    method text() {
        return monedas.toString() +"\n" + "\n" + "\n"
    }

    method textColor() {
        return "FFFF00FF"
    }

}

object contadorVidasBarry {
    var property vidas = 1
    var property position = game.at(0,8)
    
    method text() {
        return vidas.toString()
    }

    method textColor() {
        return "FF0000FF"
    }

    method agregarVidas(vida) {
        vidas = vidas + vida
    } 

    method restarVida(vida) {
        vidas -= vida
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
    var nivel = 1

    method image() {
        return "fondoo" + nivel + ".png"
    }

    method subirNivel() {
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
class Menu {
    var property juegoIniciado = false

    method init() {
        game.title("jetpackjoyride")
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
        // Llamar a la función de inicialización del juego
        self.iniciarJuego()
    }


    method iniciarJuego() {
	    game.addVisual(fondoJuego)
	    game.addVisual(reloj)
	    game.addVisual(barry)
        game.addVisual(contadorMonedas)
        game.addVisual(contadorVidasBarry)
    

	    // Crear instancias de clases
        generadorDeObjetos.construirMisil()
        generadorDeObjetos.construirMisil()
	    generadorDeObjetos.construirMoneda()
        generadorDeObjetos.construirMoneda()
        game.schedule(25000, {generadorDeObjetos.construirToken()})
        generadorDeObjetos.construirReloj()
        generadorDeObjetos.gravedad()


	    keyboard.up().onPressDo({barry.volar()})
	    //keyboard.s().onPressDo({barry.subirGravedad()})
        //keyboard.w().onPressDo({barry.bajarGravedad()})
  
        game.onTick(50000, "fondo", {fondoJuego.subirNivel()})
        game.schedule(250200, {administrador.pararJuegoYMostrarGameOver()})
        // Colisiones
        game.onCollideDo(barry, {cosa => cosa.colisiono(barry)})  
    }
}