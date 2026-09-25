
; Directiva de procesador
PROCESSOR 18F47Q10

; llamada a la cabecera
#include "header.inc"
    ; Declaracion de PSECT
    PSECT upcino, class=CODE, reloc=2, abs

mecatron:
     ORG 000000H          ; direccion del vector de RESET
     bra configuro        ; salto a label configuro
     
configuro:
    ; configuracion de fuente de reloj
    movlb 0EH             ; Me voy al Bank14

    movlw 59H
    movwf OSCCON1, 1      ; NOSC=HFINTOSC. NDIV=1:1
    movlw 02H
    movwf OSCFRQ, 1       ; HFINTOSC a 8MHz
    movlw 50H
    movwf OSCEN, 1        ; HFINTOSC enabled

    ; configuracion de los puertos de entrada / salida
    movlb 0FH             ; Me voy al Bank15

    ; Configuración Puerto C (Segmentos)
    bcf TRISC, 0, 1       ; RC0 salida
    bcf ANSELC, 0, 1      ; RC0 digital
    bcf TRISC, 1, 1       ; RC1 salida
    bcf ANSELC, 1, 1      ; RC1 digital
    bcf TRISC, 2, 1       ; RC2 salida
    bcf ANSELC, 2, 1      ; RC2 digital
    bcf TRISC, 3, 1       ; RC3 salida
    bcf ANSELC, 3, 1      ; RC3 digital
    bcf TRISC, 4, 1       ; RC4 salida
    bcf ANSELC, 4, 1      ; RC4 digital
    bcf TRISC, 5, 1       ; RC5 salida
    bcf ANSELC, 5, 1      ; RC5 digital
    bcf TRISC, 6, 1       ; RC6 salida
    bcf ANSELC, 6, 1      ; RC6 digital
    ;=====================
    bcf TRISE,0,1  ; salida
    bcf ANSELE,0,1 ; digital
    ;=====================
    ; botones
    ; boton 1
    bsf TRISA, 0, 1       ; RA0 entrada
    bcf ANSELA, 0, 1      ; RA0 digital
    bsf WPUA, 0, 1        ; pull-up activado en RA0

    ; boton 3
    bsf TRISB, 0, 1       ; RB0 entrada
    bcf ANSELB, 0, 1      ; RB0 digital
    bsf WPUB, 0, 1        ; pull-up activado en RB0
    
    ; habilitadores (Se cambió '//' por ';' y se corrigieron los comentarios)
    ; transistor 1 (Dígito 1)
    bcf TRISD, 0, 1       ; RD0 salida
    bcf ANSELD, 0, 1      ; RD0 digital
    ; transistor 2 (Dígito 2)
    bcf TRISD, 1, 1       ; RD1 salida
    bcf ANSELD, 1, 1      ; RD1 digital
    ; transistor 3 (Dígito 3)
    bcf TRISD, 2, 1       ; RD2 salida
    bcf ANSELD, 2, 1      ; RD2 digital
    ; transistor 4 (Dígito 4) -> AÑADIDO PARA LA LETRA 'U'
    bcf TRISD, 3, 1       ; RD3 salida
    bcf ANSELD, 3, 1      ; RD3 digital

    clrf LATD, 1          ; Apagar todos los dígitos inicialmente
    
    ; Inicialización del puntero de tabla de la Parte Alta y Media
    ; Se corrige la dirección para que apunte a 000150H (donde están tus datos)
    movlw 00H
    movwf TBLPTRU, 1
    movlw 01H             ; Corregido de 02H a 01H
    movwf TBLPTRH, 1

loop:
    /*
    ; >>> SECCIÓN AÑADIDA: Bucle principal de multiplexación <<<
    ; Reiniciar puntero L para el barrido en cada ciclo
    movlw 50H
    movwf TBLPTRL, 1

    ; --- Letra 'P' ---
    TBLRD*+               ; Lee 0x150
    movff TABLAT, LATC
    bsf LATD, 0, 1        ; Enciende RD0
    call nopes
    bcf LATD, 0, 1        ; Apaga RD0

    ; --- Letra 'e' ---
    TBLRD*+               ; Lee 0x151
    movff TABLAT, LATC
    bsf LATD, 1, 1        ; Enciende RD1
    call nopes
    bcf LATD, 1, 1        ; Apaga RD1

    ; --- Letra 'r' ---
    TBLRD*+               ; Lee 0x152
    movff TABLAT, LATC
    bsf LATD, 2, 1        ; Enciende RD2
    call nopes
    bcf LATD, 2, 1        ; Apaga RD2

    ; --- Letra 'U' ---
    TBLRD*+               ; Lee 0x153
    movff TABLAT, LATC
    bsf LATD, 3, 1        ; Enciende RD3
    call nopes
    bcf LATD, 3, 1        ; Apaga RD3  */
    
    btfss PORTB,0,1
    call heat
    call peru
    btfss PORTA,0,1
    bsf LATE,0,1
    btfsc PORTA,0,1
    bcf LATE,0,1
    
    

    bra loop              ; Repetir ciclo infinitamente
    
nopes:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    return
peru:
    movlw 50H
    movwf TBLPTRL, 1
    ; --- Letra 'P' ---
    TBLRD*+               ; Lee 0x150
    movff TABLAT, LATC
    bsf LATD, 0, 1        ; Enciende RD0
    call nopes
    bcf LATD, 0, 1        ; Apaga RD0

    ; --- Letra 'e' ---
    TBLRD*+               ; Lee 0x151
    movff TABLAT, LATC
    bsf LATD, 1, 1        ; Enciende RD1
    call nopes
    bcf LATD, 1, 1        ; Apaga RD1

    ; --- Letra 'r' ---
    TBLRD*+               ; Lee 0x152
    movff TABLAT, LATC
    bsf LATD, 2, 1        ; Enciende RD2
    call nopes
    bcf LATD, 2, 1        ; Apaga RD2

    ; --- Letra 'U' ---
    TBLRD*+               ; Lee 0x153
    movff TABLAT, LATC
    bsf LATD, 3, 1        ; Enciende RD3
    call nopes
    bcf LATD, 3, 1        ; Apaga RD3
    
    return
    
 heat:
    movlw 54H
    movwf TBLPTRL, 1
    ; --- Letra 'P' ---
    TBLRD*+               ; Lee 0x150
    movff TABLAT, LATC
    bsf LATD, 0, 1        ; Enciende RD0
    call nopes
    bcf LATD, 0, 1        ; Apaga RD0

    ; --- Letra 'e' ---
    TBLRD*+               ; Lee 0x151
    movff TABLAT, LATC
    bsf LATD, 1, 1        ; Enciende RD1
    call nopes
    bcf LATD, 1, 1        ; Apaga RD1

    ; --- Letra 'r' ---
    TBLRD*+               ; Lee 0x152
    movff TABLAT, LATC
    bsf LATD, 2, 1        ; Enciende RD2
    call nopes
    bcf LATD, 2, 1        ; Apaga RD2

    ; --- Letra 'U' ---
    TBLRD*+               ; Lee 0x153
    movff TABLAT, LATC
    bsf LATD, 3, 1        ; Enciende RD3
    call nopes
    bcf LATD, 3, 1        ; Apaga RD3
    
    
    ORG 000150H           ; Corregido de 0000150H (sintaxis estándar de 21-bits)
datos:
     DB 73H, 7BH, 50H, 1CH, 076H,07BH, 05FH, 078H
     ;   P    e    r    U    H     e     a     t
 
    end mecatron


