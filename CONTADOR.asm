.include"m8535def.inc"
.def aux = r16
.def cont = r17

    ldi aux,low(RAMEND)
    out spl,aux
    ldi aux,high(RAMEND)
    out sph,aux
    ser aux
    out ddra,aux
    out portb,aux
    clr cont

uno:
    in aux,pinb
    andi aux,$0F
    out porta,cont

dos:
    rcall delay
    dec aux
    brne dos

    inc cont
    rjmp uno

delay:
    ; Assembly code auto-generated
    ; by utility from Bret Mulvey
    ; Delay 249 993 cycles
    ; 249ms 993us at 1 MHz

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
