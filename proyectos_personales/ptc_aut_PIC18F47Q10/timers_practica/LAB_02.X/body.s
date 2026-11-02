PROCESSOR 18F47Q10
    #include "header.inc"
    PSECT bioloco, class=CODE, reloc=2, abs 
bioloco: 
    ORG 000000H
    bra configuro 
    
    ORG 00001AH

configuro: 
    ; --- Configuración del oscilador interno a 4 MHz ---
    movlb 0EH 
    movlw 60H              ; HFINTOSC con divisor 1:1
    movwf OSCCON1,1 
    movlw 02H              ; Frecuencia a 4 MHz
    movwf OSCFRQ, 1 
    movlw 50H 
    movwf OSCEN, 1 
    
    ; --- Configuración de entradas y salidas ---
    movlb 0FH
    
    ; DIP Switch: RB0 y RB1 como entradas con pull-up
    bsf TRISB, 0, 1
    bsf TRISB, 1, 1
    bcf ANSELB, 0, 1
    bcf ANSELB, 1, 1
    bsf WPUB, 0, 1
    bsf WPUB, 1, 1
    
    ; Leds Complementarios: RD0 y RD1 como salidas digitales
    bcf TRISD, 0, 1        
    bcf TRISD, 1, 1
    bcf ANSELD, 0, 1
    bcf ANSELD, 1, 1
    
    ; Display: Transistores en RA0-RA3
    movlw 0F0H             ; RA0, RA1, RA2, RA3 como salidas (0)
    movwf TRISA, 1
    movwf ANSELA, 1
    clrf LATA, 1           ; Apagamos los transistores por seguridad
    
    ; Display: Segmentos en RC0-RC7
    movlw 00H              
    movwf TRISC, 1         
    movwf ANSELC, 1
    
    ; Puertos adicionales que tenías en tu base
    bcf TRISE, 0, 1
    bcf ANSELE, 0, 1
    
    ; Inicializar punteros
    clrf TBLPTRU, 1 
    movlw 01H
    movwf TBLPTRH, 1
    
    ; --- Configuración inicial del TIMER0 (Modo 8 bits) ---
    movlw 80H
    movwf T0CON0, 1

    ; Estado inicial complementario de los LEDs en el puerto D
    bsf LATD, 0, 1         ; LED 0 inicia ON
    bcf LATD, 1, 1         ; LED 1 inicia OFF
    
loop: 
    ; 1. CONMUTAR LEDS COMPLEMENTARIOS
    movlb 0FH              ; Aseguramos Banco 15 
    btg LATD, 0, 1
    btg LATD, 1, 1
    
    ; 2. LECTURA DEL DIP SWITCH (RB1, RB0) PARA CARGAR EL TIMER
    btfss PORTB, 1, 1      
    bra revisar_rb0_0      
    bra revisar_rb0_1      

revisar_rb0_0:             
    btfss PORTB, 0, 1      
    bra opc_00             ; (00)
    bra opc_01             ; (01)

revisar_rb0_1:             
    btfss PORTB, 0, 1      
    bra opc_10             ; (10)
    bra opc_11             ; (11)

    ; 3. LÓGICA ASIMÉTRICA: Carga de valores al Timer0
opc_00: ; 1 Hz / 60% DC (Periodo 1000ms: 600ms ON / 400ms OFF)
    movlw 50H              
    movwf PRODL, 1         
    movlw 4CH              
    movwf T0CON1, 1
    btfss LATD, 0, 1       ; Revisamos estado del LED 0
    bra opc_00_off
opc_00_on:
    movlw 146              
    bra cargar_tmr
opc_00_off:
    movlw 98               
    bra cargar_tmr

opc_01: ; 2 Hz / 40% DC (Periodo 500ms: 200ms ON / 300ms OFF)
    movlw 60H              
    movwf PRODL, 1
    movlw 4BH              
    movwf T0CON1, 1
    btfss LATD, 0, 1
    bra opc_01_off
opc_01_on:
    movlw 98               
    bra cargar_tmr
opc_01_off:
    movlw 146              
    bra cargar_tmr

opc_10: ; 5 Hz / 20% DC (Periodo 200ms: 40ms ON / 160ms OFF)
    movlw 70H              
    movwf PRODL, 1
    movlw 4AH              
    movwf T0CON1, 1
    btfss LATD, 0, 1
    bra opc_10_off
opc_10_on:
    movlw 39               
    bra cargar_tmr
opc_10_off:
    movlw 156              
    bra cargar_tmr

opc_11: ; 8 Hz / 10% DC (Periodo 125ms: 12.5ms ON / 112.5ms OFF)
    movlw 80H              
    movwf PRODL, 1
    movlw 49H              
    movwf T0CON1, 1
    btfss LATD, 0, 1
    bra opc_11_off
opc_11_on:
    movlw 24               
    bra cargar_tmr
opc_11_off:
    movlw 220              
    bra cargar_tmr

cargar_tmr:
    clrf TMR0L, 1          ; Reiniciar cuenta a 0 para exactitud
    movwf TMR0H, 1         ; Carga el límite
    
    ; 4. BUCLE DE MULTIPLEXACIÓN Y ESPERA DEL TIMER
espera_tmr0:
    movlb 0FH              
    
    ; =========================================================
    ; LECTURA AL INSTANTE (Ahora en el puerto B)
    ; =========================================================
    btfss PORTB, 1, 1      
    bra ver_rb0_0          
    bra ver_rb0_1          

ver_rb0_0:             
    btfss PORTB, 0, 1      
    bra pon_wan            
    bra pon_thu            

ver_rb0_1:             
    btfss PORTB, 0, 1      
    bra pon_tri            
    bra pon_for            

pon_wan:
    movlw 50H
    bra actualiza_palabra
pon_thu:
    movlw 60H
    bra actualiza_palabra
pon_tri:
    movlw 70H
    bra actualiza_palabra
pon_for:
    movlw 80H

actualiza_palabra:
    movwf PRODL, 1         ; Actualiza la dirección al momento

    movff PRODL, TBLPTRL   ; Recarga el puntero a la letra inicial
    
    ; Multiplexamos a velocidad saludable (1 ms por dígito en el puerto A)
    TBLRD*+ 
    movff TABLAT, LATC 
    bsf LATA, 0, 1         
    call nopes 
    bcf LATA, 0, 1         
    
    TBLRD*+ 
    movff TABLAT, LATC 
    bsf LATA, 1, 1         
    call nopes 
    bcf LATA, 1, 1 
    
    TBLRD*+ 
    movff TABLAT, LATC 
    bsf LATA, 2, 1         
    call nopes 
    bcf LATA, 2, 1 
    
    TBLRD*+ 
    movff TABLAT, LATC 
    bsf LATA, 3, 1         
    call nopes 
    bcf LATA, 3, 1 
    
    ; Polling: Revisar si el Timer terminó
    movlb 0EH              
    btfss PIR0, 5, 1       
    bra espera_tmr0        ; Si NO ha terminado, vuelve a dibujar la palabra
    
    bcf PIR0, 5, 1         ; Si SÍ, limpia bandera
    bra loop               ; Salta al inicio para invertir los LEDs

    ; --- RUTINA NOPES (Retardo de 1 ms exacto a 4 MHz) ---
nopes: 
    movlw 250              ; Cargamos 250 iteraciones
    movwf 20H, 1           ; Guardamos en registro de RAM genérico (0x20)
retardo:
    nop                    ; 1 ciclo
    decfsz 20H, 1, 1       ; Resta 1 y salta si es 0 (1 ciclo)
    bra retardo            ; Vuelve a restar (2 ciclos)
    return                 ; (Total = 4 ciclos x 250 = 1000 us = 1 ms)
    
    ; --- Tablas de mensajes ---
    ORG 000150H 
WAN: DB 2AH, 77H, 54H, 00H 

    ORG 000160H 
THU: DB 78H, 76H, 3EH, 00H

    ORG 000170H 
TRI: DB 78H, 50H, 06H, 00H

    ORG 000180H 
FOR: DB 71H, 3FH, 50H, 00H
    
    end bioloco