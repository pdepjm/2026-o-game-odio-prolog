import wollok.game.*
import globo.*
import nubes.*
import consumibles.*
import gravedad.*

class Generador {
    var ultimaAltura = 3 
    const elementos = []
    var ultimoXdeUltimaInstancia = 0 //inicializo con valor al azar donde no va a poder posicionarse la primera nube/consumible
    // TIPO DE OBJETO
    method crearElemento(pos)

    method generar() {
        if (globo.altura() >= ultimaAltura - 10) {

            const posXposibles = (0..game.width())
            const nuevaX = posXposibles.filter({n => n != ultimoXdeUltimaInstancia}).anyOne() //quiero que 2 nubes/consumibles que se generen una atras de la otra no aparezcan en la misma posicion x
            ultimoXdeUltimaInstancia = nuevaX
            ultimaAltura = ultimaAltura + (1..3).anyOne()
            
            //const yEnPantalla = ultimaAltura - globo.altura() + 2 //la altura real del globo no se modifica esto hacia que cada vez aparezcan menos nubes y consumibles
            
            const nuevoElemento = self.crearElemento(game.at(nuevaX, gravedad.ySpawn()))
            
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
        const elementosViejos = elementos.filter({ e => gravedad.fueraDePantalla(e.position()) })
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

object generadorDeNubes inherits Generador() {
    override method crearElemento(pos) = new Nube(position = pos)
}

object generadorDeConsumibles inherits Generador() {

        override method crearElemento(pos) {
        const sorteo = (1..10).anyOne()
        return if (sorteo <= 3) new SanLorenzo(position = pos)
            else if (sorteo <= 6) new ChiquiTapia(position = pos)
            else if (sorteo <= 9) new Azzaro(position = pos)
            else new Ciclon(position = pos)   // solo sale con el 10: 1 de cada 10
    }

}
