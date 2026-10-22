import wollok.game.*
import globo.*
import gravedad.*

object estadoNubes {
    var property acelerador = 1

    method acelerar(){
        acelerador = 2 
        game.schedule(10000, { acelerador = 1 })
    }

    method reiniciar(){
        acelerador = 1
    }
}

class Nube {
    var property position
    var property opacidad = (1..4).anyOne() == 1

    method image() = gravedad.imagen(if(opacidad) "nube_transparente" else "nubeee")
    
    method interaccion() {
        if (!opacidad) {
            globo.morir()
        }
    }

    method moverse() {
        self.position(gravedad.siguientePosicion(self.position(), estadoNubes.acelerador()))
    }
}