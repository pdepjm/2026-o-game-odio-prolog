import wollok.game.*

class Nube {
    var property position
    var property opacidad = (1..4).anyOne() == 1

    method image() = if(opacidad) "2026-o-game-odio-prolog/assets/nube_transparente.png" else "2026-o-game-odio-prolog/assets/nube.png"
    
    method interaccion() {
        if (!opacidad) {
            globo.morir()
        }
    }
}

object generadorDeNubes {
    var ultimaAltura = 3
    const nubes = []

    method generar() {
        if (globo.altura() >= ultimaAltura - 10) {
            const nuevaX = (0..game.width() - 1).anyOne()
            ultimaAltura = ultimaAltura + (4..7).anyOne()
            
            const yEnPantalla = ultimaAltura - globo.altura() + 2
            
            const nuevaNube = new Nube(position = game.at(nuevaX, yEnPantalla))
            game.addVisual(nuevaNube)
            nubes.add(nuevaNube)
        }
    }

    method moverNubes() {
        nubes.forEach({ nube => 
            nube.position(nube.position().down(1))
        })
        const nubesViejas = nubes.filter({ nube => nube.position().y() < -2 })
        nubesViejas.forEach({ nube => 
            if (game.hasVisual(nube)) { game.removeVisual(nube) }
            nubes.remove(nube)
        })
    }

    method limpiarNubes() {
        nubes.forEach({ nube => 
            if (game.hasVisual(nube)) { game.removeVisual(nube) }
        })
        nubes.clear()
    }

    method reiniciar() {
        self.limpiarNubes()
        ultimaAltura = 3
    }
}

object globo {
    var property direccionActual = "ninguna"
    var property position = game.at(5, 2)
    var property altura = 2
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

    method image() = "2026-o-game-odio-prolog/assets/personajeGlobo.png"

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
    }

    method reiniciar() {
        position = game.at(game.width().div(2), 2)
        altura = 2
        direccionActual = "ninguna"
        vivo = true
    }
}
