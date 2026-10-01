import wollok.game.*
import globo.*

class Nube {
    var property position
    var property opacidad = (1..4).anyOne() == 1

    method image() = if(opacidad) "nube_transparente.png" else "nubeee.png"
    
    method interaccion() {
        if (!opacidad) {
            globo.morir()
        }
    }
}

object generadorDeNubes {
    var ultimaAltura = 3
    const nubes = []
    var acelerador = 1 

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
            if(nube.position().y() != 3) nube.position(nube.position().down(acelerador))
            else {nube.position(nube.position().down(1))} //esto es para que cuando acelere el globo tenga que pasar por la casilla del glob si o si
            
        })
        const nubesViejas = nubes.filter({ nube => nube.position().y() < -2 })
        nubesViejas.forEach({ nube => 
            if (game.hasVisual(nube)) { game.removeVisual(nube) }
            nubes.remove(nube)
        })
    }

    method acelerar(){
        acelerador = 2 
        game.schedule(10000,{acelerador = 1})
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