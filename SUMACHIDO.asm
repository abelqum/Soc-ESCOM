; Archivo de definiciones del ATmega8535
.include "m8535def.inc" 

; Vector de inicio
.org 0x0000
    rjmp inicio

inicio:
    ; Configurar el Stack Pointer (Puntero de pila)
    ldi r16, low(RAMEND)
    out SPL, r16
    ldi r16, high(RAMEND)
    out SPH, r16

    ; 1. Configurar Puerto B como entrada y habilitar pull-ups (DSW1)
    clr r16             ; Pone r16 en 0x00
    out DDRB, r16       ; DDRB = 0x00 (Puerto B es entrada)
    ser r16             ; Pone r16 en 0xFF
    out PORTB, r16      ; PORTB = 0xFF (Habilita las resistencias pull-up)

    ; 2. Configurar Puerto D como entrada y habilitar pull-ups (DSW2)
    clr r16             
    out DDRD, r16       ; DDRD = 0x00 (Puerto D es entrada)
    ser r16             
    out PORTD, r16      ; PORTD = 0xFF (Habilita las resistencias pull-up)

    ; 3. Configurar Puerto A como salida (Barra de LEDs U2)
    ser r16             
    out DDRA, r16       ; DDRA = 0xFF (Puerto A es salida)
    clr r16             
    out PORTA, r16      ; Apaga todos los pines del Puerto A inicialmente

bucle_principal:
    ; 4. Leer los datos de los DIP switches
    in r16, PINB        ; Lee el valor del Puerto B (DSW1) y lo guarda en r16
    in r17, PIND        ; Lee el valor del Puerto D (DSW2) y lo guarda en r17

    ; 5. Invertir la lógica (Complemento a 1)
    com r16             
    com r17             

    ; 6. Realizar la suma
    add r16, r17        ; Suma r17 a r16 y guarda el resultado en r16

    ; 7. Enviar el resultado al Puerto A
    out PORTA, r16      ; Muestra el resultado de la suma en los LEDs

    ; 8. Repetir infinitamente
    rjmp bucle_principal
