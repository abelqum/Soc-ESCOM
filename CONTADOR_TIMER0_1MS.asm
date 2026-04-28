.include "m8535def.inc"

.def aux   = r16
.def uno   = r17
.def cont  = r18      ; Contador de milisegundos
.def flag  = r19      ; Bandera de estado: 0 = apagado (0V), 1 = señal activa (Toggle)

reset:
    rjmp inicio
.org $009               ; Vector de interrupción de Overflow del Timer 0
    rjmp cambio

inicio:
    ; --- Configuración de Pila (Stack Pointer) ---
    ldi aux, low(RAMEND)
    out spl, aux
    ldi aux, high(RAMEND)
    out sph, aux

    ; --- Configuración de Puertos ---
    ; PA0 como salida (aquí conectas el osciloscopio)
    sbi ddra, 0

    ; --- Configuración del Timer 0 ---
    ; Prescaler = 8 (CS01 = 1) -> 1 tick = 8 us a 1 MHz
    ldi aux, 2
    out tccr0, aux

    ; Habilitar interrupción por desbordamiento (TOIE0 = 1)
    ldi aux, 1
    out timsk, aux

    sei                 ; Habilitar interrupciones globales

    ; --- Inicialización de Variables ---
    ldi uno, 1
    clr cont            ; Inicia contador en 0
    clr flag            ; Inicia en fase apagada (10ms en 0V)

loop:
    rjmp loop

;===================================================
; RUTINA DE INTERRUPCIÓN: TIMER 0 OVERFLOW
;===================================================
cambio:
    ; 1. Recargar el Timer para que la interrupción dure EXACTAMENTE 1 ms
    ; A 1 MHz con prescaler 8: 125 ticks = 1 ms.
    ; TCNT0 = 256 - 125 = 131
    ldi aux, 131
    out tcnt0, aux

    ; 2. Incrementar nuestro contador de milisegundos
    inc cont
    
    ; 3. Comprobar si ya pasaron los 10 ms (10 cuadritos de 1ms)
    cpi cont, 10         
    brne seguir          ; Si no han pasado 10ms, salta a evaluar la salida

    ; Si ya pasaron 10ms, reiniciamos la cuenta y cambiamos de fase
    clr cont
    eor flag, uno        ; Cambia la bandera (de 0 a 1, o de 1 a 0)

seguir:
    ; 4. Control de la salida (Pin PA0) dependiendo de la fase
    tst flag             ; ¿La bandera es cero?
    breq apagar          ; Si es 0, salta a forzar el pin a 0V

    ; Si la bandera es 1 (Fase activa): Hacemos Toggle a PA0 cada 1 ms
    in aux, porta
    eor aux, uno
    out porta, aux
    rjmp fin

apagar:
    ; Fase inactiva: Forzar el pin PA0 a estado bajo (0V)
    in aux, porta
    andi aux, 0b11111110 ; Máscara para borrar solo el bit 0 sin afectar los demás
    out porta, aux

fin:
    reti
