import nubes.*
import globo.*
import wollok.game.*
import gravedad.*

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

class Consumible {
    var property position

    // Cada consumible define cómo se llama su imagen (sin extensión) y qué pasa al chocar con el globo
    method nombreImagen()
    method interaccion()

    method image() = gravedad.imagen(self.nombreImagen())

    method moverse() {
        self.position(gravedad.siguientePosicion(self.position(), estadoConsumibles.acelerador()))
    }
}

class SanLorenzo inherits Consumible {

    override method nombreImagen() = "caslaCar"

    //quiero que el "SanLorenzo" choque con el personaje y lo realentize

    override method interaccion(){
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
}

class ChiquiTapia inherits Consumible {

    override method nombreImagen() = "chiquiTapia"

    override method interaccion() {
        globo.sumarPuntaje(5)
        game.removeVisual(self)
        sonidos.reproducir("chiquiTapia.mp3", 0.3, 16000)
    }
}

class Azzaro inherits Consumible {

    override method nombreImagen() = "azzaro"

    override method interaccion() {
        game.removeVisual(self)
        sonidos.reproducir("azzaro.mp3", 0.3, 8000)
    }
}

class Ciclon inherits Consumible {

    override method nombreImagen() = "ciclon"

    override method interaccion() {
        game.removeVisual(self)
        gravedad.rotar()
    }
}

object sanloDiminuto{
    var property position = game.at(3,5)
    method image() = gravedad.imagen("memeSanlo")
    method interaccion() { }   // no hace nada: evita el error si el globo lo toca
}