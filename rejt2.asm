.include "m8535def.inc"
.def dato = r16

ser dato
out ddra, dato
out portb, dato

ldi r20, $3f
ldi r21, 6
ldi r22, $5b
ldi r23, $4f
ldi r24, $66
ldi r25, $6d
ldi r26, $7d
ldi r27, 7
ldi r28, $7f
ldi r29, $6f

clr zh

aqui:
    ldi zl, 20
    in dato, pinb
    andi dato, $0f

    ; --- INICIO DEL CÓDIGO AGREGADO PARA A-F ---
    cpi dato, 10
    brlo calcular_z      ; Si es menor a 10 (0-9), usa tu lógica original con el puntero Z

    ; Si llegó aquí, el número es 10 a 15 (A - F)
    cpi dato, 10
    brne chk_b
    ldi dato, $77        ; Código 7-seg para 'A'
    rjmp imprimir
chk_b:
    cpi dato, 11
    brne chk_c
    ldi dato, $7c        ; Código 7-seg para 'b'
    rjmp imprimir
chk_c:
    cpi dato, 12
    brne chk_d
    ldi dato, $39        ; Código 7-seg para 'C'
    rjmp imprimir
chk_d:
    cpi dato, 13
    brne chk_e
    ldi dato, $5e        ; Código 7-seg para 'd'
    rjmp imprimir
chk_e:
    cpi dato, 14
    brne chk_f
    ldi dato, $79        ; Código 7-seg para 'E'
    rjmp imprimir
chk_f:
    ldi dato, $71        ; Código 7-seg para 'F'
    rjmp imprimir

calcular_z:
    ; --- FIN DEL CÓDIGO AGREGADO ---

    ; --- TUS LÍNEAS ORIGINALES INTACTAS ---
    add zl, dato
    ld dato, z

imprimir:                ; (Etiqueta agregada para unificar la salida del puerto A)
    out porta, dato
    rjmp aqui
