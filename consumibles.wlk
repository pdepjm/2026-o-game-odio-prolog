import nubes.*
import globo.*
import wollok.game.*

class SanLorenzo{
    var property position

    method image() = "caslaCar.png"

    //quiero que el "SanLorenzo" choque con el personaje y lo realentize

    method interaccion(){
        // globo.realentizar()
        generadorDeNubes.acelerar()
        game.removeVisual(self)
        game.sound("acabaDePerderSanlo.mp3").play()
        game.onTick(350, "imagenDeSanlo", {
            const opcion = [sanloDiminuto].anyOne()
            game.addVisual(opcion)
            game.schedule(250, {game.removeVisual(opcion)})
        })
        game.schedule(10000, {game.removeTickEvent("imagenDeSanlo")})
    }
}

object sanloDiminuto{
    var property position = game.at(3,5)
    method image() = "memeSanlo.png"
}

object generadorDeConsumibles{

    var ultimaAltura = 3 
    const consumibles = []

    method generar() {
        if (globo.altura() >= ultimaAltura - 10) {
            const nuevaX = (0..game.width() - 1).anyOne()
            ultimaAltura = ultimaAltura + (4..7).anyOne()
            
            const yEnPantalla = ultimaAltura - globo.altura() + 2
            
            const opcion = [1].anyOne() // la idea es hacer varias opciones y que salgan al azar alguna opcion

            if(opcion == 1){
            const nuevoConsumible = new SanLorenzo(position = game.at(nuevaX, yEnPantalla))
            game.addVisual(nuevoConsumible)
            consumibles.add(nuevoConsumible)
            }

        }
    }


        method moverConsumibles() {
        consumibles.forEach({ c => 
            c.position(c.position().down(1)) 
        })
        const nubesViejas = consumibles.filter({ c => c.position().y() < -2 }) 
        nubesViejas.forEach({ c => 
            if (game.hasVisual(c)) { game.removeVisual(c) } 
            consumibles.remove(c) 
        })
    }

        method limpiarConsumibles() { 
        consumibles.forEach({ c => 
            if (game.hasVisual(c)) { game.removeVisual(c) }
        })
        consumibles.clear()
    }

    //se reinicia el sistema de nubes
    method reiniciar() {
        self.limpiarConsumibles()
        ultimaAltura = 3
    }
}

