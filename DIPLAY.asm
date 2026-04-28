.include "m8535def.inc"
.def aux=r16
.def col=r17
.def desplaza=r18

reset:
    rjmp inicio
.org $008               ; Vector del Timer 1
    rjmp t1_ovf
.org $009               ; Vector del Timer 0
    rjmp t0_ovf

inicio:
    ldi aux, low(RAMEND)
    out spl, aux
    ldi aux, high(RAMEND)
    out sph, aux
    
    ser aux
    out ddra, aux
    out ddrc, aux
    
    ; --- MENSAJE NUEVO: tacosss ---
    clr r0
    clr r1
    clr r2
    
    ldi aux, $78        ; Carácter 't' (minúscula)
    mov r3, aux
    ldi aux, $77        ; Carácter 'A' (mayúscula)
    mov r4, aux
    ldi aux, $58        ; Carácter 'c' (minúscula)
    mov r5, aux
    ldi aux, $5C        ; Carácter 'o' (minúscula)
    mov r6, aux
    ldi aux, $6D        ; Carácter 'S' 
    mov r7, aux
    ldi aux, $6D        ; Carácter 'S' 
    mov r8, aux
    ldi aux, $6D        ; Carácter 'S' 
    mov r9, aux
    
    ; Tres espacios en blanco al final para que salga suave
    clr r10
    clr r11
    clr r12
    
    clr zh
    clr desplaza

    ; --- CONFIGURACIÓN TIMERS ---
    ldi aux, 1          ; Prescaler 64 para simulación fluida en Proteus
    out tccr0, aux      
    
    ldi aux, 5          ; Prescaler 1024 para el movimiento
    out tccr1b, aux     
    ldi aux, $FE
    out tcnt1h, aux
    ldi aux, $18
    out tcnt1l, aux

    ldi aux, $05        
    out timsk, aux      
    sei
    rcall val_ini

loop:
    rjmp loop

; --- ESCANEO DISPLAY ---
val_ini:
    ldi col, 1
    mov zl, desplaza
    ld aux, z
    com col
    out portc, col
    com col
    out porta, aux
    ret

t0_ovf:
    out porta, zh       ; Apaga para evitar fantasmas
    lsl col
    cpi col, 16         ; Límite para 4 displays
    breq uno
    
    inc zl
    ld aux, z
    com col
    out portc, col
    com col
    out porta, aux	
dos:
    reti
uno:
    rcall val_ini
    rjmp dos

; --- MOVIMIENTO DEL MENSAJE ---
t1_ovf:
    ldi aux, $FE
    out tcnt1h, aux
    ldi aux, $18
    out tcnt1l, aux
    
    inc desplaza
    ; Como 'tacosss' tiene 7 letras (+ 3 ceros de inicio), el límite se queda en 10
    cpi desplaza, 10     
    brne fin_t1
    clr desplaza        
fin_t1:
    reti
