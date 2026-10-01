/*PROCESSOR  18F47Q10

    
#include "header.inc"

    cont EQU 00F0H
    
PSECT timer , class= CODE ,reloc= 2 , abs

 
 
 timer:
    ORG 00000H
    bra configuracion
   
     
    ORG 00100H
configuracion:
    // configuracion del ocilador
     movlb 0EH  ; bank14
     
     movlw 60H
     movwf OSCCON1,1  //  NOSC=HFINTOSC. NDIV=1:1  

     movlw 02H
     movwf OSCFRQ,1        ; HFINTOSC a 4MHz

     movlw 40H
     movwf OSCEN, 1        ; HFINTOSC enabled
    
     
     
    movlb 0FH
    bsf TRISB,0,1  // entrada
    bcf ANSELB,0,1  // digital
    bsf WPUB,0,1 // resistencia pull-up
    
    bcf TRISD,0,1  //  salida
    bcf ANSELD,0,  //  dgital    */
    
    
PROCESSOR  18F47Q10
#include "header.inc"

 cont EQU 00F0H

PSECT timer , class= CODE ,reloc= 2 , abs

timer:
 ORG 00000H
 bra configuracion
 
 ORG 00100H
configuracion:
 // configuracion del oscilador
 movlb 0EH        ; bank14
 movlw 02H
 movwf OSCFRQ,1   ; HFINTOSC a 4MHz
 movlw 40H
 movwf OSCEN, 1   ; HFINTOSC enabled

 movlb 0FH
 // CORRECCIÓN: Se usa TRIS en lugar de PORT para configurar dirección
 bsf TRISB,0,1    ; RB0 como entrada 
 bcf ANSELB,0,1   ; RB0 digital
 bsf WPUB,0,1     ; resistencia pull-up en RB0
 
 bcf TRISD,0,1    ; RD0 como salida
 bcf ANSELD,0,1   ; RD0 digital
 
 // --- LO QUE FALTARÍA: CONFIGURACIÓN DEL TIMER 0 ---
 movlw 80H
 movwf T0CON0, 1  ; Configura TMR0 en modo de 8 bits (T0CON0 = 80H)
 
 movlw 73H
 movwf T0CON1, 1  ; Configura reloj y prescaler a 1:8 (T0CON1 = 73H)[cite: 1]
 
 movlw 250
 movwf TMR0H, 1   ; Carga el valor 250 en el registro comparador para lograr 500us[cite: 1]
 
 clrf TMR0L, 1    ; Inicializa el contador en 0

 // --- LO QUE FALTARÍA: BUCLE PRINCIPAL (POLLING) ---

loop:
 movlb 0EH        ; Cambia al banco 14 para leer PIR0 (donde está TMR0IF)[cite: 1]
 btfss PIR0, 5, 1 ; Pregunta si la bandera TMR0IF (bit 5) se activó tras 500us[cite: 1]
 bra loop         ; Si no se activó, regresa a 'loop' y sigue esperando[cite: 1]

 // Acción al completarse el tiempo
 bcf PIR0, 5, 1   ; Limpia la bandera TMR0IF poniéndola en 0[cite: 1]
 
 movlb 0FH        ; Cambia al banco 15 para acceder a los pines
 btg LATD, 0, 1   ; Invierte el estado de RD0 (Bit Toggle) para generar la onda cuadrada[cite: 1]
 
 movlb 0EH        ; Regresa al banco 14 para la siguiente evaluación
 bra loop         ; Bucle infinito[cite: 1]
    

    

    


