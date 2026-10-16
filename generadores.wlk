import wollok.game.*
import globo.*
import nubes.*
import consumibles.*

class Generador {
    var ultimaAltura = 3 
    const elementos = []
    var ultimoXdeUltimaInstancia = 0 //inicializo con valor al azar donde no va a poder posicionarse la primera nube/consumible
    // TIPO DE OBJETO
    const accionCrearElemento 

    method generar() {
        if (globo.altura() >= ultimaAltura - 10) {

            const posXposibles = (0..game.width())
            const nuevaX = posXposibles.filter({n => n != ultimoXdeUltimaInstancia}).anyOne() //quiero que 2 nubes/consumibles que se generen una atras de la otra no aparezcan en la misma posicion x
            ultimoXdeUltimaInstancia = nuevaX
            ultimaAltura = ultimaAltura + (1..3).anyOne()
            
            //const yEnPantalla = ultimaAltura - globo.altura() + 2 //la altura real del globo no se modifica esto hacia que cada vez aparezcan menos nubes y consumibles
            
            const nuevoElemento = accionCrearElemento.apply(game.at(nuevaX, game.height())) //aparece justo arriba de la pantalla
            
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
        const elementosViejos = elementos.filter({ e => e.position().y() < 0 }) //ya salio de la pantalla
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
    const opcion = [1, 2, 3].anyOne()
    if (opcion == 1) new SanLorenzo(position = pos)
    else if (opcion == 2) new ChiquiTapia(position = pos)
    else new Azzaro(position = pos)
}) {}
