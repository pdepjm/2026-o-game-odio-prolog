import wollok.game.*
import globo.*
import nubes.*
import consumibles.*

class Generador {
    var ultimaAltura = 3 
    const elementos = []
    
    // TIPO DE OBJETO
    const accionCrearElemento 

    method generar() {
        if (globo.altura() >= ultimaAltura - 10) {
            const nuevaX = (0..game.width() - 1).anyOne()
            ultimaAltura = ultimaAltura + (4..7).anyOne()
            
            const yEnPantalla = ultimaAltura - globo.altura() + 2
            
            const nuevoElemento = accionCrearElemento.apply(game.at(nuevaX, yEnPantalla))
            
            if (nuevoElemento != null) {
                game.addVisual(nuevoElemento)
                elementos.add(nuevoElemento)
            }
        }
    }

    method moverElementos() {
        elementos.forEach({ e => 
            e.moverse() 
        })
        const elementosViejos = elementos.filter({ e => e.position().y() < -2 }) 
        elementosViejos.forEach({ e => 
            if (game.hasVisual(e)) { game.removeVisual(e) } 
            elementos.remove(e) 
        })
    }

    method limpiarElementos() { 
        elementos.forEach({ e => 
            if (game.hasVisual(e)) { game.removeVisual(e) }
        })
        elementos.clear()
    }

    method reiniciar() {
        self.limpiarElementos()
        ultimaAltura = 3
    }
}

object generadorDeNubes inherits Generador(accionCrearElemento = { pos => new Nube(position = pos) }) {}

object generadorDeConsumibles inherits Generador(accionCrearElemento = { pos => 
    const opcion = [1].anyOne()
    if (opcion == 1) new SanLorenzo(position = pos) else null
}) {}
