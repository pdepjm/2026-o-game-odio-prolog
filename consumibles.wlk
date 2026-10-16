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

// Wollok guarda cada sonido que se reproduce hasta que se le hace stop(),
// aunque ya haya terminado de sonar. Si no se frenan, se acumulan y el juego se traba.
object sonidos {
    const activos = []

    method reproducir(archivo, volumen, duracion) {
        const sonido = game.sound(archivo)
        sonido.volume(volumen)
        sonido.play()
        activos.add(sonido)
        game.schedule(duracion, { self.detener(sonido) })
        return sonido
    }

    method detener(sonido) {
        if (sonido.played()) {
            sonido.stop()
        }
        activos.remove(sonido)
    }

    method detenerTodos() {
        activos.copy().forEach({ sonido => self.detener(sonido) })
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
        const musica = sonidos.reproducir("acabaDePerderSanlo.mp3", 0.5, 11000)
        game.onTick(350, "imagenDeSanlo", {
            const opcion = [sanloDiminuto].anyOne()
            if (!game.hasVisual(opcion)) {
                game.addVisual(opcion)
                game.schedule(250, { if (game.hasVisual(opcion)) game.removeVisual(opcion) })
            }

            if(!globo.vivo()){
                sonidos.detener(musica)
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
        sonidos.reproducir("chiquiTapia.mp3", 0.3, 16000)
    }

    method moverse() {
        if(self.position().y() != 3) {
            self.position(self.position().down(estadoConsumibles.acelerador()))
        } else {
            self.position(self.position().down(1))
        }
    }
}

class Azzaro {
    var property position

    method image() = "azzaro.png"

    method interaccion() {
        game.removeVisual(self)
        sonidos.reproducir("azzaro.mp3", 0.3, 8000)
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
