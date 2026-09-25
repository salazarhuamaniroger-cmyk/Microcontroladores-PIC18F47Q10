 PROCESSOR 18F57Q43 // DIRECTIVA DEL PROCESADOR, PARA INDICARLE EL MODELO AL COMPILADOR
 #include "cabecera.inc" // llamada a archivo cabecera
   
   
   // crear una seccion de programa ()
   
   PSECT upcino, class=CODE, reloc=2, abs
   
   upcino:
       ORG 000000H  //posicion de memoria de programa: VECTOR DE RESET
       bra configuro // salto a etiqueta configuro
       
       ORG 000100H // posicion de momoria de programa 100H
       
       
    configuro:
        // configurar la fuente de reloj 
	
	movlb 0H //ME VOY al BANK0
	movlw 60H
	movwf OSCCON1, 1 //NOSC -> HFINTOSC, NDIV ->1:1
	movlw 02H
	movwf OSCFRQ, 1  //HFINTOSC enablend
	movlw 40H
	movwf OSCEN,1 // HFINTOSC enabled
	
	
	
	movlb 4H // voy al BANK 4
	//========================================================
	
	// pines del DISPLAY-7-SEGMENTS
	bcf TRISA, 1, 1  // RA1 como salida  ---------------------> E
	bcf ANSELA,1 , 1 // RA1 como digital
	
	bcf TRISA, 2, 1 //RA2 como salida    ---------------------> D
	bcf ANSELA, 2, 1 // RA2 como digital
	
	bcf TRISA, 3, 1 // RA3 como salida   ---------------------> C
	bcf ANSELA, 3, 1// RA3 como digital
	
	bcf TRISA, 4, 1 //RA4 como salida    ---------------------> B
	bcf ANSELA, 4, 1 // RA4 omo digital
	
	bcf TRISA, 5, 1 // RA5 como salida   ---------------------> A
	bcf ANSELA, 5, 1 //RA5 como digital
	
	bcf TRISA, 6, 1 //RA4 como salida    ---------------------> F
	bcf ANSELA, 6, 1 // RA4 omo digital
	
	bcf TRISA, 7, 1 // RA5 como salida   ---------------------> G
	bcf ANSELA, 7, 1 //RA5 como digital
	
	
	
	

	//button
	//========================================================
	bsf TRISD,0 ,1   // establcer RD0 como entrada
	bcf ANSELD, 0, 1 // establecer RD0 como pin digital
	bsf WPUD, 0, 1 // conectar RD0 a una resistencia PULL-UP(5V)
	
//==============================================================================
//MAIN LOOP()
//==============================================================================
	
    bucle_main:
        call cero
    espera_presion_0:
	btfsc PORTD, 0, 1 // si es cero salta una linea
	bra espera_presion_0 // mientras RD0 no sea 0 esta linea no se ejecuta 
    espera_soltar_0:
	btfss PORTD, 0, 1 // si es uno salta una line
	bra espera_soltar_0  // mientras RD0 no sea 0 esta linea no se ejecuta    
	
    proceso1:
	call uno
    espera_presion_1:
	btfsc PORTD, 0, 1 // si es cero salta una linea
	bra espera_presion_1 // mientras RD0 no sea 0 esta linea no se ejecuta 
    espera_soltar_1:
	btfss PORTD, 0, 1 // si es uno salta una linea
	bra espera_soltar_1  // mientras RD0 no sea 0 esta linea no se ejecuta
	
    proceso2:
        call dos
    espera_presion_2:
	btfsc PORTD, 0, 1 // si es cero salta una linea
	bra espera_presion_2 // mientras RD0 no sea 0 esta linea no se ejecuta 
    espera_soltar_2:
	btfss PORTD, 0, 1 // si es uno salta una linea
	bra espera_soltar_2  // mientras RD0 no sea 0 esta linea no se ejecuta
	
    proceso3:
	call tres
    espera_presion_3:
	btfsc PORTD, 0, 1 // si es cero salta una linea
	bra espera_presion_3 // mientras RD0 no sea 0 esta linea no se ejecuta 
    espera_soltar_3:
	btfss PORTD, 0, 1 // si es uno salta una linea
	bra espera_soltar_3  // mientras RD0 no sea 0 esta linea no se ejecuta
	
    proceso4:
        call cuatro
    espera_presion_4:
	btfsc PORTD, 0, 1 // si es cero salta una linea
	bra espera_presion_4 // mientras RD0 no sea 0 esta linea no se ejecuta 
    espera_soltar_4:
	btfss PORTD, 0, 1 // si es uno salta una line
	bra espera_soltar_4  // mientras RD0 no sea 0 esta linea no se ejecuta
	
    proceso5:
	call cinco
    espera_presion_5:
	btfsc PORTD, 0, 1 // si es cero salta una linea
	bra espera_presion_5 // mientras RD0 no sea 0 esta linea no se ejecuta 
    espera_soltar_5:
	btfss PORTD, 0, 1 // si es uno salta una linea
	bra espera_soltar_5  // mientras RD0 no sea 0 esta linea no se ejecuta
	
    proceso6:
        call seis
    espera_presion_6:
	btfsc PORTD, 0, 1 // si es cero salta una linea
	bra espera_presion_6 // mientras RD0 no sea 0 esta linea no se ejecuta 
    espera_soltar_6:
	btfss PORTD, 0, 1 // si es uno salta una linea
	bra espera_soltar_6  // mientras RD0 no sea 0 esta linea no se ejecuta
	
    proceso7:
	call siete
    espera_presion_7:
	btfsc PORTD, 0, 1 // si es cero salta una linea
	bra espera_presion_7 // mientras RD0 no sea 0 esta linea no se ejecuta 
    espera_soltar_7:
	btfss PORTD, 0, 1 // si es uno salta una linea
	bra espera_soltar_7  // mientras RD0 no sea 0 esta linea no se ejecuta
	
    proceso8:
        call ocho
    espera_presion_8:
	btfsc PORTD, 0, 1 // si es cero salta una linea
	bra espera_presion_8 // mientras RD0 no sea 0 esta linea no se ejecuta 
    espera_soltar_8:
	btfss PORTD, 0, 1 // si es cero salta una linea
	bra espera_soltar_8  // mientras RD0 no sea 0 esta linea no se ejecuta
	
    proceso9:
        call nueve
    espera_presion_9:
	btfsc PORTD, 0, 1 // si es cero salta una linea
	bra espera_presion_9 // mientras RD0 no sea 0 esta linea no se ejecuta 
    espera_soltar_9:
	btfss PORTD, 0, 1 // si es uno salta una linea
	bra espera_soltar_9  // mientras RD0 no sea 0 esta linea no se ejecuta
	
	bra bucle_main // regresa al inicio
	
	

	
	
	
	
	
    // subrutinas 	
    cero:
        bsf LATA, 1, 1 // RA1 es 1
	bsf LATA, 2, 1 // RA2 es 1
	bsf LATA, 3, 1 // RA3 es 1
        bsf LATA, 4, 1 // RA4 es 1
	bsf LATA, 5, 1 // RA5 es 1
	bsf LATA, 6, 1 // RA6 es 1
	bcf LATA, 7, 1 // RA7 es 0
	return  // regresa a la linea donde se quedo en el bucle principal
	
    uno:
        bcf LATA, 1, 1 // RA1 es 0
	bcf LATA, 2, 1 // RA2 es 0
	bsf LATA, 3, 1 // RA3 es 1
        bsf LATA, 4, 1 // RA4 es 1
	bcf LATA, 5, 1 // RA5 es 0
	bcf LATA, 6, 1 // RA6 es 0
	bcf LATA, 7, 1 // RA7 es 0
	return    
	

	
    dos:
        bsf LATA, 1, 1 // RA1 es 1
	bsf LATA, 2, 1 // RA2 es 1
	bcf LATA, 3, 1 // RA3 es 0
        bsf LATA, 4, 1 // RA4 es 1
	bsf LATA, 5, 1 // RA5 es 1
	bcf LATA, 6, 1 // RA6 es 0
	bsf LATA, 7, 1 // RA7 es 1
	return    
    tres:
        bcf LATA, 1, 1 // RA1 es 0
	bsf LATA, 2, 1 // RA2 es 1
	bsf LATA, 3, 1 // RA3 es 1
        bsf LATA, 4, 1 // RA4 es 1
	bsf LATA, 5, 1 // RA5 es 1
	bcf LATA, 6, 1 // RA6 es 0
	bsf LATA, 7, 1 // RA7 es 1
	return   
    cuatro:
        bcf LATA, 1, 1 // RA1 es 0
	bcf LATA, 2, 1 // RA2 es 0
	bsf LATA, 3, 1 // RA3 es 1
        bsf LATA, 4, 1 // RA4 es 1
	bcf LATA, 5, 1 // RA5 es 0
	bsf LATA, 6, 1 // RA6 es 1
	bsf LATA, 7, 1 // RA7 es 1
	return 
	
    cinco:
        bcf LATA, 1, 1 // RA1 es 0
	bsf LATA, 2, 1 // RA2 es 1
	bsf LATA, 3, 1 // RA3 es 1
        bcf LATA, 4, 1 // RA4 es 0
	bsf LATA, 5, 1 // RA5 es 1
	bsf LATA, 6, 1 // RA6 es 1
	bsf LATA, 7, 1 // RA7 es 1
	return  

    seis:
        bsf LATA, 1, 1 // RA1 es 1
	bsf LATA, 2, 1 // RA2 es 1
	bsf LATA, 3, 1 // RA3 es 1
        bcf LATA, 4, 1 // RA4 es 0
	bsf LATA, 5, 1 // RA5 es 1
	bsf LATA, 6, 1 // RA6 es 1
	bsf LATA, 7, 1 // RA7 es 1
	return
	
    siete:
        bcf LATA, 1, 1 // RA1 es 0
	bcf LATA, 2, 1 // RA2 es 0
	bsf LATA, 3, 1 // RA3 es 1
        bsf LATA, 4, 1 // RA4 es 1
	bsf LATA, 5, 1 // RA5 es 1
	bcf LATA, 6, 1 // RA6 es 0
	bsf LATA, 7, 1 // RA7 es 1
	return 
	
    ocho:
        bsf LATA, 1, 1 // RA1 es 1
	bsf LATA, 2, 1 // RA2 es 1
	bsf LATA, 3, 1 // RA3 es 1
        bsf LATA, 4, 1 // RA4 es 1
	bsf LATA, 5, 1 // RA5 es 1
	bsf LATA, 6, 1 // RA6 es 1
	bsf LATA, 7, 1 // RA7 es 1
	return
	
    nueve:
        bcf LATA, 1, 1 // RA1 es 0
	bsf LATA, 2, 1 // RA2 es 1
	bsf LATA, 3, 1 // RA3 es 1
        bsf LATA, 4, 1 // RA4 es 1
	bsf LATA, 5, 1 // RA5 es 1
	bsf LATA, 6, 1 // RA6 es 1
	bsf LATA, 7, 1 // RA7 es 1
	return
	
	
        end upcino
	
 


