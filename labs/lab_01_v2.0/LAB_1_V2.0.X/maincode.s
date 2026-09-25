PROCESSOR  18F47Q10

    
#include "header.inc"

    cont EQU 00F0H
    
PSECT upcino , class= CODE ,reloc= 2 , abs

 
 
 upcino:
    ORG 00000H
    bra configuracion
    
    ORG 000300H  ; ORG: origin   empesar en la direccion 00300H de la memoria del programa(flash)
    tabla_display_7seg: DB 3FH/*0*/, 06H/*1*/, 5BH/*2*/, 4FH/*3*/, 66H/*4*/, 6DH/*5*/, 7DH/*6*/, 07H/*7*/, 7FH/*8*/, 67H/*9*/ ,77H/*A*/, 7CH/*B*/, 39H/*C*/, 5EH/*D*/, 79H/*E*/, 71H/*F*/  ;-----DB:define byte
     
    ORG 00100H
configuracion:
    // configuracion del ocilador
     movlb 0EH  ; bank14
     
     movlw 60H
     movwf OSCCON1,1  //  NOSC=HFINTOSC. NDIV=1:1

     movlw 03H
     movwf OSCFRQ,1        ; HFINTOSC a 8MHz

     movlw 40H
     movwf OSCEN, 1        ; HFINTOSC enabled
   
    ; configuracion de los puertos de entrada / salida
    movlb 0FH             ; Me voy al Bank15

    bcf TRISC,0,1         ; RC0 salida
    bcf ANSELC,0,1        ; RC0 digital

    bcf TRISC,1,1         ; RC1 salida
    bcf ANSELC,1,1        ; RC1 digital

    bcf TRISC,2,1         ; RC2 salida
    bcf ANSELC,2,1        ; RC2 digital

    bcf TRISC,3,1         ; RC3 salida
    bcf ANSELC,3,1        ; RC3 digital

    bcf TRISC,4,1         ; RC4 salida
    bcf ANSELC,4,1        ; RC4 digital

    bcf TRISC,5,1         ; RC5 salida
    bcf ANSELC,5,1        ; RC5 digital

    bcf TRISC,6,1         ; RC6 salida
    bcf ANSELC,6,1        ; RC6 digital
    
    
    ; botones
    ; boton 1 : decrementa -1 
    bsf TRISA,0,1          ; RA0 entrada
    bcf ANSELA,0,1         ; RA0 digital
    bsf WPUA,0,1           ; pull-up activado en RA0

    ; boton 2: incrementa +2
    bsf TRISA,7,1          ; RA7 entrada
    bcf ANSELA,7,1         ; RA7 digital
    bsf WPUA,7,1           ; pull-up activado en RA7

    ; boton 3: incrementa +1 
    bsf TRISB,4,1          ; RB4 entrada
    bcf ANSELB,4,1         ; RB4 digital
    bsf WPUB,4,1           ; pull-up activado en RB4
    
    
    // direccionando el puntero a 000300H
    movlw 00H
    movwf TBLPTRU,1
    movlw 03H
    movwf TBLPTRH,1
    movlw 00H
    movwf TBLPTRL,1
    
    movlb 0H
    clrf cont,1
    
    
    
inicio:
    
    
    
    
    
    
    
    
 //==================================================
 // SUB RUTINAS
 //==================================================
 
 display:
    movlw contador,1
    
 decremento:
    
 incremeto_1:
    
 incremento_2:
    
    
    
    
    end upcino   