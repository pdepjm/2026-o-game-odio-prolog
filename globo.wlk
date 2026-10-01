import wollok.game.*
import consumibles.*
import nubes.*



object globo {
    var property direccionActual = "ninguna"
    var property position = game.at(5, 2)
    var property altura = 2
    var property puntaje = 0
    var vivo = true
    var estaRealentizado = false 

    method morir() {
        if (vivo) {
            vivo = false
            generadorDeConsumibles.limpiarConsumibles()
            generadorDeNubes.limpiarNubes()
            game.removeTickEvent("movimientoGlobo")
            game.removeTickEvent("generadorNubes")
            game.removeTickEvent("generadorConsumibles")
            game.schedule(350, {
                game.say(self, "pero la puta madre")
            }) 
            game.schedule(2000, {
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
        generadorDeNubes.limpiarNubes()
        generadorDeConsumibles.limpiarConsumibles()
    }

    method realentizar() {
    estaRealentizado = true
    
    // Cambiamos el tick a velocidad lenta (ej: 1500 ms)
    game.removeTickEvent("movimientoGlobo")
    game.onTick(1500, "movimientoGlobo", {
        self.moverseHorizontal()
        self.avanzarAltura()
    })

    // A los 10 segundos vuelve a la normalidad
    game.schedule(10000, {
        estaRealentizado = false
        game.removeTickEvent("movimientoGlobo")
        // Volvemos al tick normal (350 ms)
        game.onTick(350, "movimientoGlobo", {
            self.moverseHorizontal()
            self.avanzarAltura()
        })
    })
}
}
