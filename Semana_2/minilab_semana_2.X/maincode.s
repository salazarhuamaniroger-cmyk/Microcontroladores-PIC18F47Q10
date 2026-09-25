 
; Este es un comentario
; Directiva de procesador

    PROCESSOR 18F47Q10

    ; llamada a la cabecera
    #include "cabecera.inc"


    ; Declaracion de PSECT
    PSECT upcino , class=CODE, reloc=2, abs


    upcino:

         ORG 000000H          ; direccion del vector de RESET
         bra configuro        ; salto a label configuro


         ORG 000080H          ; Zona de programa de usuario


    configuro:

        ; configuracion de fuente de reloj

        movlb 0EH             ; Me voy al Bank14

        movlw 60H
        movwf OSCCON1,1       ; NOSC=HFINTOSC. NDIV=1:1

        movlw 02H
        movwf OSCFRQ,1        ; HFINTOSC a 4MHz

        movlw 40H
        movwf OSCEN, 1        ; HFINTOSC enabled


        ; configuracion de los puertos de entrada / salida

        movlb 0FH             ; Me voy al Bank15

        ; RA0 como entrada
        bsf TRISA,0,1         ; RA0 entrada
        bcf ANSELA,0,1        ; RA0 entrada digital

        ; RA1 como entrada
        bsf TRISA,1,1         ; RA1 entrada
        bcf ANSELA,1,1        ; RA1 entrada digital

        ; RA2 como entrada
        bsf TRISA,2,1         ; RA2 entrada
        bcf ANSELA,2,1        ; RA2 entrada digital


        ; RC0 como salida
        bcf TRISC,0,1         ; RC0 salida
        bcf ANSELC,0,1        ; RC0 salida digital

        ; RC1 como salida
        bcf TRISC,1,1         ; RC1 salida
        bcf ANSELC,1,1        ; RC1 salida digital

        ; RC2 como salida
        bcf TRISC,2,1         ; RC2 salida
        bcf ANSELC,2,1        ; RC2 salida digital


   

    inicio:

        ;--------------------------------
        ; Comprobacion de RA0
        ;--------------------------------

        btfss PORTA,0,1       ; Comprueba RA0 y salta si esta en 1
        bra es_falso_1        ; Si RA0 esta en 0, salta a es_falso_1

        bcf LATC,0,1          ; Si RA0 esta en 1, pone RC0 en 0
        bra revisar_RA1       ; Continua con la comprobacion de RA1


    es_falso_1:

        bsf LATC,0,1          ; Si RA0 esta en 0, pone RC0 en 1
        bra revisar_RA1       ; Continua con la comprobacion de RA1


    revisar_RA1:

        ;--------------------------------
        ; Comprobacion de RA1
        ;--------------------------------

        btfss PORTA,1,1       ; Comprueba RA1 y salta si esta en 1
        bra es_falso_2        ; Si RA1 esta en 0, salta a es_falso_2

        bcf LATC,1,1          ; Si RA1 esta en 1, pone RC1 en 0
        bra revisar_RA2       ; Continua con la comprobacion de RA2


    es_falso_2:

        bsf LATC,1,1          ; Si RA1 esta en 0, pone RC1 en 1
        bra revisar_RA2       ; Continua con la comprobacion de RA2


    revisar_RA2:

        ;--------------------------------
        ; Comprobacion de RA2
        ;--------------------------------

        btfss PORTA,2,1       ; Comprueba RA2 y salta si esta en 1
        bra es_falso_3        ; Si RA2 esta en 0, salta a es_falso_3

        bcf LATC,2,1          ; Si RA2 esta en 1, pone RC2 en 0
        bra inicio            ; Regresa al inicio


    es_falso_3:

        bsf LATC,2,1          ; Si RA2 esta en 0, pone RC2 en 1
        bra inicio            ; Regresa al inicio


        ; configuracion de puertos de E/S

        ; cierre del PSECT

        end upcino


    
    
