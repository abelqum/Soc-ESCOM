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
    
    ; --- ARREGLO DEL MENSAJE COMPLETO ---
    ; Agregamos ceros al inicio y al final para que el mensaje
    ; "entre" por la derecha y "salga" por la izquierda limpiamente.
    clr r0
    clr r1
    clr r2
    
    ldi aux, $40        ; Carácter '-'
    mov r3, aux
    ldi aux, $76        ; Carácter 'H'
    mov r4, aux
    ldi aux, $3f        ; Carácter 'O'
    mov r5, aux
    ldi aux, $38        ; Carácter 'L'
    mov r6, aux
    ldi aux, $77        ; Carácter 'A'
    mov r7, aux
    ldi aux, $40        ; Carácter '-'
    mov r8, aux
    
    clr r9
    clr r10
    clr r11
    
    clr zh
    clr desplaza

    ; --- CONFIGURACIÓN TIMERS ---
    
    ; ¡CAMBIO CLAVE PARA PROTEUS! 
    ; Usamos prescaler de 64 (ldi aux, 3) en lugar de 1.
    ; Esto evita que Proteus parpadee o encime las letras.
    ldi aux, 3
    out tccr0, aux      
    
    ; Timer 1 (Ventana deslizante - 0.5s)
    ldi aux, 5
    out tccr1b, aux     ; Prescaler 1024
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
    cpi desplaza, 9     ; Ahora recorre 9 posiciones para que el mensaje entre y salga
    brne fin_t1
    clr desplaza        ; Reinicia el ciclo
fin_t1:
    reti
