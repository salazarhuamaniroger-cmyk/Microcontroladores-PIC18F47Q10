PROCESSOR 18F47Q10

    #include "header.inc"
    
    PSECT UPECINO, class=CODE, reloc=2, abs

UPECINO:
    ORG 000000H
    BRA configuro
    
    ORG 00001AH
   
configuro:
    ; --- OSCILADOR ---
    movlb   0EH
    movlw   60H
    movwf   OSCCON1, 1
    movlw   03H             ; Frecuencia a 8 MHz
    movwf   OSCFRQ, 1
    
    ; --- CONFIGURACIÓN DE PUERTOS (Exclusivo con MOV) ---
    movlb   0FH
    movlw   07H             
    movwf   TRISA, 1        ; RA0, RA1, RA2 entradas (1), resto salidas (0)[span_1](start_span)[span_1](end_span)
    movlw   00H             
    movwf   ANSELA, 1       ; Todo el Puerto A es digital[span_2](start_span)[span_2](end_span)
    movlw   07H             
    movwf   WPUA, 1         ; Activa Pull-up solo en RA0, RA1 y RA2
    
    movlw   00H
    movwf   LATA, 1         ; Asegurar salidas de A en cero
    
    bcf     TRISD, 0, 1     ; RD0 como salida
    bcf     ANSELD, 0, 1
    bcf     LATD, 0, 1
    
    ; --- CONFIGURACIÓN T0CON0: Modo 8 Bits ---
    movlw   80H             ; T0EN=1, MD16=0 (Modo comparador de 8 bits)
    movwf   T0CON0, 1
    
loop:
    ; --- ÁRBOL DE DECISIONES DE 3 BITS (RA2, RA1, RA0) ---
    movlb   0FH
    btfsc   PORTA, 2, 1     ; ¿RA2 es 0?
    bra     mitad_superior  ; Salta si RA2 = 1
    
mitad_inferior:             ; (Si RA2 = 0)
    btfsc   PORTA, 1, 1     ; ¿RA1 es 0?
    bra     casos_2_y_3     ; Salta si RA1 = 1
    
casos_0_y_1:                ; (Si RA2=0, RA1=0)
    btfsc   PORTA, 0, 1     
    bra     caso_1          ; Salta si RA0 = 1 (001)
    bra     caso_0          ; Continúa si RA0 = 0 (000)

casos_2_y_3:                ; (Si RA2=0, RA1=1)
    btfsc   PORTA, 0, 1
    bra     caso_3          ; Salta si RA0 = 1 (011)
    bra     caso_2          ; Continúa si RA0 = 0 (010)

mitad_superior:             ; (Si RA2 = 1)
    btfsc   PORTA, 1, 1     
    bra     casos_6_y_7     ; Salta si RA1 = 1
    
casos_4_y_5:                ; (Si RA2=1, RA1=0)
    btfsc   PORTA, 0, 1
    bra     caso_5          ; Salta si RA0 = 1 (101)
    bra     caso_4          ; Continúa si RA0 = 0 (100)

casos_6_y_7:                ; (Si RA2=1, RA1=1)
    btfsc   PORTA, 0, 1
    bra     caso_7          ; Salta si RA0 = 1 (111)
    bra     caso_6          ; Continúa si RA0 = 0 (110)


    ; --- CONFIGURACIÓN DE TIEMPOS POR CASO ---
    ; (Valores INVERTIDOS para voltear la gráfica del osciloscopio)
caso_0:
    movlw   43H             ; Prescaler 1:8
    movwf   T0CON1, 1
    btfsc   LATD, 0, 1      ; ¿El pin AHORA está Arriba (1)?
    bra     opt0_on
opt0_off:
    movlw   100             ; [INVERTIDO] Para forzar 6 cuadros abajo
    bra     actualiza_tmr
opt0_on:
    movlw   150             ; [INVERTIDO] Para forzar 4 cuadros arriba
    bra     actualiza_tmr
    
caso_1:
    movlw   43H             ; Prescaler 1:8
    movwf   T0CON1, 1
    btfsc   LATD, 0, 1
    bra     opt1_on
opt1_off:
    movlw   213             ; [INVERTIDO]
    bra     actualiza_tmr
opt1_on:
    movlw   38              ; [INVERTIDO]
    bra     actualiza_tmr

caso_2:
    movlw   42H             ; Prescaler 1:4
    movwf   T0CON1, 1
    btfsc   LATD, 0, 1
    bra     opt2_on
opt2_off:
    movlw   75              ; [INVERTIDO]
    bra     actualiza_tmr
opt2_on:
    movlw   175             ; [INVERTIDO]
    bra     actualiza_tmr

caso_3:
    movlw   42H             ; Prescaler 1:4
    movwf   T0CON1, 1
    btfsc   LATD, 0, 1
    bra     opt3_on
opt3_off:
    movlw   200             ; [INVERTIDO]
    bra     actualiza_tmr
opt3_on:
    movlw   50              ; [INVERTIDO]
    bra     actualiza_tmr

caso_4:
    movlw   41H             ; Prescaler 1:2
    movwf   T0CON1, 1
    btfsc   LATD, 0, 1
    bra     opt4_on
opt4_off:
    movlw   33              ; [INVERTIDO]
    bra     actualiza_tmr
opt4_on:
    movlw   189             ; [INVERTIDO]
    bra     actualiza_tmr

caso_5:                     ; << Caso exacto al 50% >>
    movlw   40H             ; Prescaler 1:1
    movwf   T0CON1, 1
    btfsc   LATD, 0, 1
    bra     opt5_on
opt5_off:
    movlw   222             ; (50%)
    bra     actualiza_tmr
opt5_on:
    movlw   222             ; (50%)
    bra     actualiza_tmr

caso_6:
    movlw   40H             ; Prescaler 1:1
    movwf   T0CON1, 1
    btfsc   LATD, 0, 1
    bra     opt6_on
opt6_off:
    movlw   59              ; [INVERTIDO]
    bra     actualiza_tmr
opt6_on:
    movlw   110             ; [INVERTIDO]
    bra     actualiza_tmr

caso_7:
    movlw   40H             ; Prescaler 1:1
    movwf   T0CON1, 1
    btfsc   LATD, 0, 1
    bra     opt7_on
opt7_off:
    movlw   124             ; [INVERTIDO]
    bra     actualiza_tmr
opt7_on:
    movlw   46              ; [INVERTIDO]
    bra     actualiza_tmr


    ; --- CARGA Y EJECUCIÓN DEL TIMER0 ---
actualiza_tmr:
    movwf   TMR0H, 1        ; Banco 15: Carga el valor en el comparador
    
    movlb   0EH             ; Banco 14: Dónde está el registro PIR0
espera_tmr0:
    btfss   PIR0, 5, 1      ; Espera bandera TMR0IF
    bra     espera_tmr0
    
    bcf     PIR0, 5, 1      ; Limpieza manual de la bandera al terminar el tiempo
    
    ; --- CONMUTAR LA SEÑAL ---
    movlb   0FH             ; Volver al Banco 15 para LATD
    btg     LATD, 0, 1      ; Cambia el pin RD0, logrando la onda
    
    bra     loop            
    
    end UPECINO
    
    
    
    
    
    
    


