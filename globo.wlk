import wollok.game.*
import consumibles.*
import nubes.*
import generadores.*
import gravedad.*
import ritmo.*



object globo {
    var property position = game.at(5, 2)
    var property altura = 2
    var puntaje = 0
    var vivo = true


    method puntaje() = puntaje
    method vivo() = vivo


    method morir() {
        if (vivo) {
            vivo = false
            generadorDeConsumibles.limpiarElementos()
            generadorDeNubes.limpiarElementos()
            ritmo.detener()
            sonidos.detenerTodos()   // corta todos los sonidos en el game over
            game.removeTickEvent("generadorConsumibles")
            game.removeVisual(self)
            game.addVisual(gameOver)
        }
    }

    method image() = gravedad.imagen("personajeGlobo")

    method mover(direccion) {
        if (direccion.puedeMoverse(self)) {
            position = direccion.siguiente(position)
        }
    }

    method avanzarAltura() {
        altura = altura + 1
        puntaje = puntaje + 1
    }

    method sumarPuntaje(cantidad) {
        puntaje = puntaje + cantidad
    }   

    method reiniciar() {
        position = game.at(game.width().div(2), 2)
        altura = 2
        puntaje = 0
        vivo = true
        generadorDeNubes.limpiarElementos()
        generadorDeConsumibles.limpiarElementos()
    }


}

object izquierda {
    method siguiente(pos) = pos.left(1)
    
    method puedeMoverse(personaje) = personaje.position().x() > 0
}

object derecha {
    method siguiente(pos) = pos.right(1)
    
    method puedeMoverse(personaje) = personaje.position().x() < game.width() - 1
}

object gameOver{
    var property position = game.at(0, 0)
    method image() = "gameOver3.png"
}