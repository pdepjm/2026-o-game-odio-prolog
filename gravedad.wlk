import wollok.game.*
import globo.*
import generadores.*

object gravedad {
    var invertida = false

    // nombre SIN extensión: "nubeee" -> "nubeee.png" o "nubeee_inv.png"
    method imagen(nombre) = nombre + (if (invertida) "_inv" else "") + ".png"

    method fondo() = self.imagen("cielo3")

    method yGlobo() = if (invertida) game.height() - 3 else 2
    // fila justo antes del globo: y=3 normal / y=4 invertido
    method filaPrevia() = if (invertida) self.yGlobo() - 1 else self.yGlobo() + 1

    // donde aparecen, justo afuera de la pantalla: y=8 normal / y=-1 invertido
    method ySpawn() = if (invertida) -1 else game.height()

    // cuando ya salieron por el otro lado: y<0 normal / y>7 invertido
    method fueraDePantalla(pos) = if (invertida) pos.y() > game.height() - 1 else pos.y() < 0

    // reemplaza al if de cada "moverse()"
    method siguientePosicion(pos, velocidad) {
        const pasos = if (pos.y() == self.filaPrevia()) 1 else velocidad
        return if (invertida) pos.up(pasos) else pos.down(pasos)
    }
    
    method rotar() {
        invertida = !invertida
        globo.position(game.at(globo.position().x(), self.yGlobo()))
        generadorDeNubes.limpiarElementos()
        generadorDeConsumibles.limpiarElementos()
        game.boardGround(self.fondo())
    }

    method reiniciar() {
        invertida = false
        game.boardGround(self.fondo())
    }
}