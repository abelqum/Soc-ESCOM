.include "m8535def.inc"
.def aux = r16
.def uno = r17

reset:
    rjmp inicio
    .org $009
    rjmp cambio

inicio:
    ldi aux, low(RAMEND)
    out spl, aux
    ldi aux, high(RAMEND)
    out sph, aux
    sbi ddra, 0
    ldi aux, 2
    out tccr0, aux
    ldi aux, 1
    out timsk, aux
    sei
    ldi uno, 1

loop:
    rjmp loop

cambio:
    ldi aux, 194
    out tcnt0, aux
    in aux, pina
    eor aux, uno
    out porta, aux
    reti
