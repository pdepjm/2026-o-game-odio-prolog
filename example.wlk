import wollok.game.*


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