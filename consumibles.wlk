import nubes.*
import globo.*
import wollok.game.*

object estadoConsumibles {
    var acelerador = 1

    method acelerador() = acelerador 


    method acelerar(){
        acelerador = 2 
        game.schedule(10000, { acelerador = 1 })
    }

    method reiniciar(){
        acelerador = 1 
    }
}
class SanLorenzo{
    var property position

    method image() = "caslaCar.png"

    //quiero que el "SanLorenzo" choque con el personaje y lo realentize

    method interaccion(){
        // globo.realentizar()
        estadoNubes.acelerar()
        estadoConsumibles.acelerar()
        game.removeVisual(self)
        const musica = game.sound("acabaDePerderSanlo.mp3")
        musica.play()
        game.onTick(350, "imagenDeSanlo", {
            const opcion = [sanloDiminuto].anyOne()
            game.addVisual(opcion)
            game.schedule(250, {game.removeVisual(opcion)})

            if(!globo.vivo()){
                musica.stop()
                game.removeTickEvent("imagenDeSanlo")
            }
        })
        game.schedule(10000, {
            game.removeTickEvent("imagenDeSanlo")
        })
    }

    method moverse() {
        if(self.position().y() != 3) {
            self.position(self.position().down(estadoConsumibles.acelerador()))
        } else {
            self.position(self.position().down(1))
        } //esto es para que cuando acelere el globo tenga que pasar por la casilla del glob si o si
        //copio y pego de nubes :P
    }
}

class ChiquiTapia {
    var property position

    method image() = "chiquiTapia.png"

    method interaccion() {
        globo.sumarPuntaje(5)
        game.removeVisual(self)
    }

    method moverse() {
        if(self.position().y() != 3) {
            self.position(self.position().down(estadoConsumibles.acelerador()))
        } else {
            self.position(self.position().down(1))
        }
    }
}

object sanloDiminuto{
    var property position = game.at(3,5)
    method image() = "memeSanlo.png"
}
