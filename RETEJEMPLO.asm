	.include "m8535def.inc"
	.def aux= r16
	.def count= r17

reset:
	rjmp inicio
	rjmp sube
	rjmp baja
inicio:
	ldi aux, low(RAMEND)
	out spl, aux
	ldi aux,high(RAMEND)
	out sph,aux
	ser aux
	out ddra,aux
	ldi aux, 0b00001100
	out portd, aux
	ldi aux, 0b00001110
	out mcucr, aux
	ldi aux, 0b11000000
	out gicr, aux
	sei
	clr count
	
loop: 
	out porta, count
	nop
	nop
	nop
	rjmp loop

sube: 
	inc count
	reti
baja:
	dec count
	reti	
	
