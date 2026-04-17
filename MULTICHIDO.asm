.include "m8535def.inc"
.def M1= r17
.def M2= r18
.def MH= r19
.def ML= r20

I:
    ; Configurar puertos B y D como entradas (DIP Switches)
    clr r16
    out ddrb, r16  ; DSW1 (Entrada 1)
    out ddrd, r16  ; DSW2 (Entrada 2)
    ser r16
    out portb, r16 ; Activa pull-ups en Puerto B
    out portd, r16 ; Activa pull-ups en Puerto D

    ; Configurar puertos A y C como salidas (Barras LED)
    ; r16 ya tiene 0xFF por el "ser r16" anterior
    out ddra, r16  ; U2 (LEDs Parte Alta)
    out ddrc, r16  ; U3 (LEDs Parte Baja)

CICLO: 
    ; 1. Leer entradas e invertir lógica (porque los switches van a GND)
    in M1, pinb    ; Leer Puerto B (DSW1)
    in M2, pind    ; Leer Puerto D (DSW2)
    com M1
    com M2

    ; 2. Limpiar registros de resultado
    clr MH
    clr ML

    ; 3. Parche para el cero: Si M2 es 0, saltar directo a mostrar el resultado (0)
    cpi M2, 0
    breq DOS 

    ; 4. Iniciar la suma sucesiva
    mov ML, M1
UNO:
    dec M2
    breq DOS
    add ML, M1
    brcc UNO
    inc MH
    rjmp UNO

DOS:
    ; 5. Mostrar el resultado (16 bits continuos de arriba a abajo)
    out porta, ML  ; U2 (Barra de arriba) muestra los bits 0 al 7
    out portc, MH  ; U3 (Barra de abajo) muestra los bits 8 al 15

    ; 6. Volver a empezar para leer cambios en los switches
    rjmp CICLO
