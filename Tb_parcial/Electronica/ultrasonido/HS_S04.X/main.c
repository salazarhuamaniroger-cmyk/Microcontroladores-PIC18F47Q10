/*
 * File:   main.c
 * Author: Roger salazar
 *
 * Created on 23 de octubre de 2026, 08:58 AM
 */


#include <xc.h>
#include "header.h"

#define _XTAL_FREQ 4000000UL


const unsigned char display_ca[10] = {0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90};


void configuro(void){
    // configuracion a 4Mz
    OSCCON1=0x60;
    OSCFRQ=0x02;
    OSCEN=0x20;
    
    TRISA=0x00;//todos los puesrtos A como salida
    ANSELA=0x00;// todos los puetos A seran digitales
    LATA=0x00; // todos los puertos A conectados a GND
    
    
    
    //=================================
    // habilitadores del display multiplexado
    //==================================
    
    TRISBbits.TRISB0=0;// el puerto RB0 sera salida
    ANSELBbits.ANSELB0=0;// el puerto RB0 sera digital
    
    TRISBbits.TRISB1=0;// el puerto RB1 sera salida
    ANSELBbits.ANSELB1=0;// el puerto RB1 sera digital
    
    // para evitar encendidos sin control 
    //apagamos los habilitadores
    LATBbits.LATB0=0;// la salida RB0 apagado
    LATBbits.LATB1=0;//la salida RB1 apagado
    
    //==============================
    //la salida para el triger de HC-S04 
    //===============================
    TRISDbits.TRISD0=0;// el RD0 es salida
    ANSELDbits.ANSELD0=0;// el RD0 es digital 
    LATDbits.LATD0=0;// pagar RD0 por el momento
   
    
    //==============================
    //la entrada para el echo de HC-S04 
    //===============================
    TRISDbits.TRISD1=1;// RD1 como entrada(alta impedancia)
    ANSELDbits.ANSELD1=0;// RD1 como digital

    
    
    
}



void main(void) {
    configuro();
    unsigned int unidad, decena;
    
    while(1){
    LATDbits.LATD0=1; // activar el triger, por recomendacion del fabricante por 60ms (aunque con que sea mayor a 10uS es suficiente)
    __delay_us(10);
    LATDbits.LATD0=0; // apagamos el traiger
    
    unsigned int contador=0;
    
    
    while(PORTDbits.RD1==0){// pic esperando a que el echo se active
    }
    
    while(PORTDbits.RD1==1){  // mientras en echo esta en 5V contamos
    contador++;
    __delay_us(10); // cada cada incremento tendra 10uS
    
        }
    
    // son 60ms por ciclo
    // eltimpo total t_total=contador*60
    // ditancia =(343/10)*(60*contador)
    
   // Calculamos la distancia en coma flotante (centímetros)
   float distancia_real = (contador * 10.0 * 0.0343) / (2.0*3);// 0.0343cm/us la velocidad del sonido
    
    unsigned int distancia_entera=(unsigned int)distancia_real*5; // hacemos un casting de datos
    if(distancia_entera<80){
    decena=distancia_entera/10;
    LATA=display_ca[decena];
    LATBbits.LATB1=1;
    __delay_ms(5);
    
  
    LATBbits.LATB1=0; // apagar decenas
    
    unidad=distancia_entera%10; // el resto
    LATA=display_ca[unidad];
    LATBbits.LATB0=1;
    __delay_ms(5);
    
      LATBbits.LATB0=0; //apagar unidades
      
    __delay_ms(10);// timepo de espera recomendado entre cada medidad
    }
    else{
        LATA=display_ca[8];
        LATBbits.LATB0=1;
        LATBbits.LATB1=0;
        __delay_ms(5);
        LATBbits.LATB0=0;
        
        LATBbits.LATB0=0;
        LATBbits.LATB1=1;
        __delay_ms(5);
        
        LATBbits.LATB1=0;
        
    }
    
    }
    
    
   
}
