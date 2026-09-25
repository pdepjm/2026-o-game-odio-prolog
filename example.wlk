import wollok.game.*

object nube {
var property position
var property opacidad = false
method image() = "assets/nube.png" //ahora la cargo
method interaccion() {
    if (opacidad) {
        //self.opacity(reducir) (tengo que ver ahora como reducirla)
    } else {
        //perder juego
    }
}
}
object globo {
var property direccionActual = "ninguna"

var property position = game.at(5, 2)

method image() = "assets/personajeGlobo.png" //no me carga la imagen. solo carga si pongo la carpeta utils afuera del repo

method moverse() {
    if(direccionActual == "derecha" && position.x() < 10){
    self.position(position.right(1))
    }
    else if(direccionActual == "izquierda" && position.x() > 0){
    self.position(position.left(1))
    }

    direccionActual = "ninguna"
} 


}
