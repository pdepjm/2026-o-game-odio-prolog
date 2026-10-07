import wollok.game.*
import globo.*

object estadoNubes {
    var property acelerador = 1

    method acelerar(){
        acelerador = 2 
        game.schedule(10000, { acelerador = 1 })
    }
}

class Nube {
    var property position
    var property opacidad = (1..4).anyOne() == 1

    method image() = if(opacidad) "nube_transparente.png" else "nubeee.png"
    
    method interaccion() {
        if (!opacidad) {
            globo.morir()
        }
    }

    method moverse() {
        if(self.position().y() != 3) {
            self.position(self.position().down(estadoNubes.acelerador()))
        } else {
            self.position(self.position().down(1))
        } //esto es para que cuando acelere el globo tenga que pasar por la casilla del glob si o si
    }
}