PROCESSOR 18F47Q10
    
   #include "header.inc"
   //===============================================
   //1. esto ira en la RAM, muy en particular estara en acces bank el cual esta hubicado en (0x00H hasta 0x5H)----zona GPR de del bank0 los primeros 96 bytes
   //==============================================
   PSECT variables , Class=COMRAM , space=1 ,  abs 
   ORG 00H
   dividendo:  DS 1
   divisor: DS 1 //DS (define space) 
    
    
   
   
   //=========================================
   //2. la seccion divisor va fisicamente ubicado en la flash 
   //====================================
   PSECT divisor , Class=CODE  ,reloc=2 , abs 

divisor:
    ORG 00000H
    bra configuracion
    
    ORG 000300H  ; ORG: origin   empesar en la direccion 00300H de la memoria del programa(flash), hasta 0000C00H
    
tabla_display_7seg: DB 3FH/*0*/, 06H/*1*/, 5BH/*2*/, 4FH/*3*/, 66H/*4*/, 6DH/*5*/, 7DH/*6*/, 07H/*7*/, 7FH/*8*/, 67H/*9**/;-----DB:define byte
     
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
   //===========================salidas=====display=========
    bcf TRISA,0,1         ; RC0 salida
    bcf ANSELA,0,1        ; RC0 digital

    bcf TRISA,1,1         ; RC1 salida
    bcf ANSELA,1,1        ; RC1 digital

    bcf TRISA,2,1         ; RC2 salida
    bcf ANSELA,2,1        ; RC2 digital

    bcf TRISA,3,1         ; RC3 salida
    bcf ANSELA,3,1        ; RC3 digital
    
    bcf TRISA,4,1         ; salida
    bcf ANSELA,4,1       ;   digital       
    
    bcf TRISA,5,1         ; RC4 salida
    bcf ANSELA,5,1        ; RC4 digital
    
    bcf TRISA,6,1        ;salida
    bcf ANSELA,6,1    ; digital
    
    // ==========habilitadores
    // habilitador 1
    bcf PORTB,5,1  
    bcf ANSELB,5,1
    
    // habilitador 2
    bcf PORTC,1,1
    bcf ANSELC,1,1
    
    // habilitador 3
    bcf PORTC,0,1
    bcf ALSELC,0,1
    
    // habilitador 4
    bcf PORTE,1,1
    bcf ANSELE,1,1
    
    
    
    
    //================================================================
    
    // ======entrada===dividend====
    //--bit mas significativo
    bsf TRISD,0,1  // entrada 
    bcf ANSELD,0,1  // digital
    bst WPUD,0,1 // activar resistencia pull up
    
    bsf TRISD,1,1  // entrada
    bcf ANSELD,1,1 // digital
    bsf WPUD,1,1 // restencia pull-up activo
    
    bsf TRISD,2,1 // entrada 
    bcf ANSELD,2,1 // digital
    bsf WPUD,2,1  //restencia pull-up activo
    
    bsf TRISD,3,1 
    bcf ANSELD,3,1
    bcf WPUD,3,1
    
    //--bit menos significativo
    bsf TRISD,4,1
    bcf ANSELD,4,1
    bsf WPUD,4,1   
    
    
    // ======entrada===divisor====
    
    // bit mas significativo
    bsf PORTB,0,1
    bcf ANSELB,0,1
    bsf WPUB,0,1
    
    bsf PORTB,1,1
    bcf ANSELB,1,1
    bsf PWUB,1,1
    
    // bit menos significativo
    bsf PORTB,2,1
    bcf ANSELB,2,1
    bsf PWUB,2,1
    
    
loop:
    
    
    
    
    
    
    
    
sum_ent_divisor:
    btfsc PORTB,2,1
    bra sum_bit_min
    
cum_bit_min:
    movlw 00000H
    movwf TBLPTRL,1
    movlw 00000000H
    movwf TBLPTRH,1
    movlw 00000300H
    movwf TBLPTRL,1
    
    TBLRD*
    movlw
    
    
    
    
    
    
    
    
    
