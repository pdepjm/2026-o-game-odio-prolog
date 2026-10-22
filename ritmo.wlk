import wollok.game.*
import globo.*
import generadores.*

object ritmo {
    const intervaloInicial = 500   // antes era 350 (más alto = más lento)
    const intervaloMinimo = 250    // el juego nunca va más rápido que esto
    const reduccion = 20           // cuántos ms se acorta el intervalo en cada aceleración
    const cadaCuanto = 10000       // cada cuántos ms se acelera (10 segundos)

    var intervalo = 500

    method intervalo() = intervalo

    method reiniciar() {
        intervalo = intervaloInicial
    }

    method arrancar() {
        self.iniciarTicks()
        game.onTick(cadaCuanto, "aceleracionProgresiva", { self.acelerar() })
    }

    method detener() {
        self.detenerTicks()
        game.removeTickEvent("aceleracionProgresiva")
    }

    method acelerar() {
        intervalo = (intervalo - reduccion).max(intervaloMinimo)
        // los ticks no pueden cambiar de intervalo: se borran y se vuelven a crear
        self.detenerTicks()
        self.iniciarTicks()
    }

    method iniciarTicks() {
        game.onTick(intervalo, "movimientoGlobo", { globo.avanzarAltura() })
        game.onTick(intervalo, "movimientoNubes", {
            generadorDeNubes.moverElementos()
            generadorDeConsumibles.moverElementos()
        })
        game.onTick(intervalo, "generadorNubes", { generadorDeNubes.generar() })
    }

    method detenerTicks() {
        game.removeTickEvent("movimientoGlobo")
        game.removeTickEvent("movimientoNubes")
        game.removeTickEvent("generadorNubes")
    }
}