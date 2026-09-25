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
	 
        // configurar las E/S 
	movlb 4H  //me voy al BANK4
	
	;========================================================
	bsf TRISA, 0, 1  // RA0 como entrada
	bcf ANSELA,0 , 1 // RA0 como digital
	bsf WPUA, 0, 1 //conectar RA0 con una resistencia PULL-UP
	
	;========================================================
	bsf TRISB,0 ,1   // RB0 como entrada
	bcf ANSELB, 0, 1 // RB0 como digital
	bsf WPUB, 0, 1 // conectar RB0 a una resistencia PULL-UP
	
	bcf TRISD, 0, 1 //RD0 como salida
	bcf ANSELD, 0, 1 //RD0 como digital
	
	
   // Loop Manin
    inicio:
        call compuerta_and // llamando a la compuerta AND
	bra inicio // retornar al inicio
	
    // rutina
    //compuerta AND
    compuerta_and:
        btfsc PORTA, 0, 1 //pregunto si RA0 es uno, si es verdad continua la secunecia si es falso, salta una linea
	bra esfalso //es falso, salta a etiqueta es falso

        btfsc PORTB, 0,1 //pregunta si RB0 es 1 , si es verdad salta una linea
	bra esfalso    //si es falso regresa a 'esfalso'
	
        bsf LATD, 0, 1  //RD0 es 0
	return //regresa al bucle
    esfalso:
        bcf LATD , 0, 1  //RD0 es 1
	return // regresa al bucle
	
	end upcino
	


  