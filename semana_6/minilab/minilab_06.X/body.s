PROCESSOR 18F47Q10
    #include "header.inc"
    
    PSECT TIMER, class=CODE, reloc=2, abs

TIMER:
    ORG 000000H
    BRA configuro
    
    ORG 00001AH
   
configuro:
    ; --- OSCILADOR ---
    BANKSEL OSCCON1
    movlw   60H
    movwf   OSCCON1, 1
    movlw   03H             ; Frecuencia a 8 MHz
    movwf   OSCFRQ, 1
    
    ; --- CONFIGURACIÓN DE PUERTOS ---
    BANKSEL TRISA
    movlw   07H             
    movwf   TRISA, 1        ; RA0, RA1, RA2 entradas, resto salidas
    movlw   00H             
    movwf   ANSELA, 1       ; Digital
    movlw   07H             
    movwf   WPUA, 1         ; Activa Pull-up en RA0, RA1 y RA2
    movlw   00H
    movwf   LATA, 1         ; LATA en cero
    
    BANKSEL TRISD
    bcf     TRISD, 0, 1     ; RD0 como salida
    bcf     ANSELD, 0, 1
    bcf     LATD, 0, 1
    
    ; --- CONFIGURACIÓN INICIAL T0CON0 ---
    BANKSEL T0CON0
    movlw   80H             ; T0EN=1, MD16=0 (Modo comparador de 8 bits)
    movwf   T0CON0, 1
    
loop:
    ; --- ÁRBOL DE DECISIONES DE 3 BITS (RA2, RA1, RA0) ---
    BANKSEL PORTA
    btfsc   PORTA, 2, 1     ; ¿RA2 es 0?
    bra     mitad_superior  ; Salta si RA2 = 1
    
mitad_inferior:             ; (RA2 = 0)
    btfsc   PORTA, 1, 1     ; ¿RA1 es 0?
    bra     casos_2_y_3     ; Salta si RA1 = 1
    
casos_0_y_1:                ; (RA2=0, RA1=0)
    btfsc   PORTA, 0, 1     ; ¿RA0 es 0?
    bra     caso_1          ; Salta si RA0 = 1 (001)
    bra     caso_0          ; Continúa si RA0 = 0 (000)

casos_2_y_3:                ; (RA2=0, RA1=1)
    btfsc   PORTA, 0, 1
    bra     caso_3          ; Salta si RA0 = 1 (011)
    bra     caso_2          ; Continúa si RA0 = 0 (010)

mitad_superior:             ; (RA2 = 1)
    btfsc   PORTA, 1, 1     ; ¿RA1 es 0?
    bra     casos_6_y_7     ; Salta si RA1 = 1
    
casos_4_y_5:                ; (RA2=1, RA1=0)
    btfsc   PORTA, 0, 1
    bra     caso_5          ; Salta si RA0 = 1 (101)
    bra     caso_4          ; Continúa si RA0 = 0 (100)

casos_6_y_7:                ; (RA2=1, RA1=1)
    btfsc   PORTA, 0, 1
    bra     caso_7          ; Salta si RA0 = 1 (111)
    bra     caso_6          ; Continúa si RA0 = 0 (110)


    ; --- CONFIGURACIÓN DE TIEMPOS POR CASO (Asimétrico invertido) ---
caso_0:
    movlw   43H             ; Prescaler 1:8
    BANKSEL T0CON1
    movwf   T0CON1, 1
    BANKSEL LATD
    btfss   LATD, 0, 1      ; <-- INVERSIÓN: Salta si es 1
    bra     opt0_on         
opt0_off:
    movlw   150             ; T_OFF (60%)
    bra     actualiza_tmr  
opt0_on:
    movlw   100             ; T_ON (40%)
    bra     actualiza_tmr
    
caso_1:
    movlw   43H             ; Prescaler 1:8
    BANKSEL T0CON1
    movwf   T0CON1, 1
    BANKSEL LATD
    btfss   LATD, 0, 1      ; <-- INVERSIÓN
    bra     opt1_on
opt1_off:
    movlw   38              ; T_OFF (15%)
    bra     actualiza_tmr 
opt1_on:
    movlw   213             ; T_ON (85%)
    bra     actualiza_tmr

caso_2:
    movlw   42H             ; Prescaler 1:4
    BANKSEL T0CON1
    movwf   T0CON1, 1
    BANKSEL LATD
    btfss   LATD, 0, 1      ; <-- INVERSIÓN
    bra     opt2_on
opt2_off:
    movlw   175             ; T_OFF (70%)
    bra     actualiza_tmr 
opt2_on:
    movlw   75              ; T_ON (30%)
    bra     actualiza_tmr

caso_3:
    movlw   42H             ; Prescaler 1:4
    BANKSEL T0CON1
    movwf   T0CON1, 1
    BANKSEL LATD
    btfss   LATD, 0, 1      ; <-- INVERSIÓN
    bra     opt3_on
opt3_off:
    movlw   50              ; T_OFF (20%)
    bra     actualiza_tmr 
opt3_on:
    movlw   200             ; T_ON (80%)
    bra     actualiza_tmr

caso_4:
    movlw   41H             ; Prescaler 1:2
    BANKSEL T0CON1
    movwf   T0CON1, 1
    BANKSEL LATD
    btfss   LATD, 0, 1      ; <-- INVERSIÓN
    bra     opt4_on
opt4_off:
    movlw   189             ; T_OFF (85%)
    bra     actualiza_tmr 
opt4_on:
    movlw   33              ; T_ON (15%)
    bra     actualiza_tmr

caso_5:                     
    movlw   40H             ; Prescaler 1:1
    BANKSEL T0CON1
    movwf   T0CON1, 1
    BANKSEL LATD
    btfss   LATD, 0, 1      ; <-- INVERSIÓN
    bra     opt5_on
opt5_off:
    movlw   222             ; T_OFF (50%)
    bra     actualiza_tmr 
opt5_on:
    movlw   222             ; T_ON (50%)
    bra     actualiza_tmr

caso_6:
    movlw   40H             ; Prescaler 1:1
    BANKSEL T0CON1
    movwf   T0CON1, 1
    BANKSEL LATD
    btfss   LATD, 0, 1      ; <-- INVERSIÓN
    bra     opt6_on
opt6_off:
    movlw   110             ; T_OFF (65%)
    bra     actualiza_tmr 
opt6_on:
    movlw   59              ; T_ON (35%)
    bra     actualiza_tmr

caso_7:
    movlw   40H             ; Prescaler 1:1
    BANKSEL T0CON1
    movwf   T0CON1, 1
    BANKSEL LATD
    btfss   LATD, 0, 1      ; <-- INVERSIÓN
    bra     opt7_on
opt7_off:
    movlw   46              ; T_OFF (27%)
    bra     actualiza_tmr 
opt7_on:
    movlw   124             ; T_ON (73%)
    bra     actualiza_tmr


    ; --- CARGA Y EJECUCIÓN DEL TIMER0 ---
actualiza_tmr:
    BANKSEL TMR0H
    movwf   TMR0H, 1        ; Se carga el valor de la duración elegida
    
    BANKSEL PIR0
espera_tmr0:
    btfss   PIR0, 5, 1      ; Polling esperando el tiempo de TMR0IF
    bra     espera_tmr0
    bcf     PIR0, 5, 1      ; Limpieza manual de la bandera
    
    ; --- MANTENIENDO TU LÓGICA DEL LED ---
    BANKSEL LATD
    btg     LATD, 0, 1      ; Alterna el estado del pin RD0
    
    bra     loop
    
    end TIMER
    
    
    
    
    


