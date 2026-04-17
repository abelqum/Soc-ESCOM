.include "m8535def.inc"

.def aux = r16
.def cont = r17

; --- CONFIGURACIÓN INICIAL ---
    ldi aux, low(RAMEND)  ; Inicializar Puntero de Pila (Stack Pointer) 
    out spl, aux          ; (Obligatorio para que funcione la instrucción 'rcall')
    ldi aux, high(RAMEND)
    out sph, aux

    ser aux               ; aux = 0xFF (Poner todos los bits en 1)
    out ddra, aux         ; Configurar todo el Puerto A como salida para los LEDs
    clr cont              ; Inicializar el contador en 0

; --- BUCLE PRINCIPAL ---
MAIN:
    out porta, cont       ; Mandar el valor del contador a la barra de LEDs
    rcall delay           ; Esperar 1/4 de segundo (250 ms)
    inc cont              ; Sumarle 1 al contador
    rjmp MAIN             ; Volver al inicio del ciclo

; --- SUBRUTINA DE RETARDO (1/4 de segundo) ---
; Genera un retardo de ~249,993 ciclos 
; Equivale a ~250ms si el ATmega8535 corre a 1 MHz
delay:
    ldi r18, 2
    ldi r19, 69
    ldi r20, 168
L1: dec r20
    brne L1
    dec r19
    brne L1
    dec r18
    brne L1
    nop
    ret
