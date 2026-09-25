 PROCESSOR 18F57Q43 // DIRECTIVA DEL PROCESADOR, PARA INDICARLE EL MODELO AL COMPILADOR
 #include "header.inc" // llamada a archivo header (cabecera)
   
   // crear una seccion de programa ()
   
   PSECT seccion1, class=CODE, reloc=2, abs
   
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
	btfss PORTD, 0, 1 // si es cero salta una linea
	bra bucle_main
        call delay_1s // espera 0.99 segundos
    p1:
	call uno
	btfss PORTD, 0, 1
	bra p1
        call delay_1s // espera 0.99 segundos
    p2:
        call dos
	btfss PORTD, 0, 1
	bra p2
        call delay_1s // espera 0.99 segundos
    p3:
	call tres 
	btfss PORTD, 0, 1
	bra p3
        call delay_1s // espera 0.99 segundos
  
	
    p4:
	call cuatro
	btfss PORTD, 0, 1
	bra p4
        call delay_1s // espera 0.99 segundos
    p5:
        call cinco
	btfss PORTD, 0, 1
	bra p5
        call delay_1s // espera 0.99 segundos
    p6:
	call seis 
	btfss PORTD, 0, 1
	bra p6
        call delay_1s // espera 0.99 segundos	
    p7:
        call siete
	btfss PORTD, 0, 1
	bra p7
        call delay_1s // espera 0.99 segundos
    p8:
        call ocho
	btfss PORTD, 0, 1
	bra p8
	call delay_1s // espera 0.99 segundos
    p9:
        call nueve
	btfss PORTD, 0, 1
	bra p9
	call delay_1s // espera 0.99 segundos
	
	bra bucle_main // regresa al inicio	
	
    // subrutinas 
    
    //------------------------------------------------------------
    //1. codificador display 7 segmentos catodo comun
    //------------------------------------------------------------
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
	
    //------------------------------------------------------------
    //2. delay 0.99 segundos 
    //------------------------------------------------------------
    
    contador_1 EQU 0x00
    contador_2 EQU 0x01
    contador_3 EQU 0x02

	
	
    //------------------------------------------------------------
    //2. delay 0.99 segundos 
    //------------------------------------------------------------

    contador_1 EQU 0x00
    contador_2 EQU 0x01
    contador_3 EQU 0x02
    
    delay_1s:
	// Rueda lenta
	movlw   33             
	movwf   contador_3, 0

    bucle_ext:
	// Rueda media
	movlw   100            
	movwf   contador_2, 0  

    bucle_med:
	// Rueda rápida
	movlw   100           
	movwf   contador_1, 0 
    
    bucle_int:
	// Restas
	decfsz  contador_1, 1, 0 
	bra     bucle_int       // Rueda rápida gira sobre sí misma

	decfsz  contador_2, 1, 0
	bra     bucle_med       // Rueda media recarga a la rápida

	decfsz  contador_3, 1, 0
	bra     bucle_ext       // Rueda lenta recarga a la media

	return                  // Fin del tiempo
	end 
