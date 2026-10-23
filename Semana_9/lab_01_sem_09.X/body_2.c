#include <xc.h>
#include "cabecera.h"

#define _XTAL_FREQ 4000000UL


const unsigned char display_ca[10] = {0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90};

const unsigned char primos[]={2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,57,59,61,67,71};

void configuro(void){
// ocilador a 4MHz
    OSCCON1=0x60;
    OSCFRQ=0x02;
    OSCEN=0x40;
    
    //PORTA para los segmetos del display
    
    TRISA=0x00; // los registros A como salida(es decir; el tinen la capacidad de conectar a 5V o 0V(GND)))
    ANSELA=0x00; // las salidas seran digitales
    LATA=0x00; // tendran un valor de 0
    
    // los habilitadores
    TRISBbits.TRISB0=0;// RB0 como salida
    ANSELBbits.ANSELB0=0;//RB0 como digital
    /*en resumen declaramos a RB0 como una salida digital de 5V*/
    
    
    
    TRISBbits.TRISB1=0;// RB1 salida
    ANSELBbits.ANSELB1=0;//RB1 digital
    /*en resumen declaramos a RB1 como salida digital (cuando se active con lAT a 1 sera 5V)*/
    
    // en unicio estaran apagados
    LATBbits.LATB0=0;
    LATBbits.LATB1=0;
    
}

int main(void){
    configuro();
    unsigned char indice=0;
    unsigned char decenas, unidades;
    unsigned int contador=0;
    
    while(1){
        decenas = primos[indice]/10;
        unidades =primos[indice]%10;
        
        
        // mutiplexacion
        //apgar para evitar parpadeos fantasma
        LATBbits.LATB0=0;
        LATBbits.LATB1=0;
       
        
        LATA=display_ca[decenas];
        LATBbits.LATB0=1; // encender el habiltador de decenas
        __delay_ms(5);
        
        LATBbits.LATB0=0;
        LATBbits.LATB1=0;
        LATA=display_ca[unidades];
        LATBbits.LATB1=1;
        __delay_ms(5);
        
         // --- TEMPORIZADOR DE 1 SEGUNDO ---
        // 5ms + 5ms = 10ms por ciclo. 100 ciclos = 1000ms = 1 segundo.
        contador++;
        if(contador>=100){
            contador=0;
            indice++;
            if(indice>=21){
                indice=0;
            }
        }
    }


return 0;}
