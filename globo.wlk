import wollok.game.*

import nubes.*


object globo {
    var property direccionActual = "ninguna"
    var property position = game.at(5, 2)
    var property altura = 2
    var property puntaje = 0
    var vivo = true

    method morir() {
        if (vivo) {
            vivo = false
            game.say(self, "pero la puta madre")
            game.schedule(1500, {
                game.removeTickEvent("movimientoGlobo")
                game.removeTickEvent("generadorNubes")
                game.say(self, "Presiona R para reiniciar")
            })
        }
    }

    method image() = "personajeGlobo.png"

    method moverseHorizontal() {
        var nuevaPosicion = position

        if (direccionActual == "derecha" && position.x() < game.width() - 1) {
            nuevaPosicion = nuevaPosicion.right(1)
        }
        else if (direccionActual == "izquierda" && position.x() > 0) {
            nuevaPosicion = nuevaPosicion.left(1)
        }

        self.position(nuevaPosicion)
        direccionActual = "ninguna"
    } 

    method avanzarAltura() {
        altura = altura + 1
        puntaje = puntaje + 1
    }

    method reiniciar() {
        position = game.at(game.width().div(2), 2)
        altura = 2
        puntaje = 0
        direccionActual = "ninguna"
        vivo = true
    }
}
