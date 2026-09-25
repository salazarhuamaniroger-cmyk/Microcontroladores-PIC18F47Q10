/*
 * File:   new_main.c
 * Author: roger salazar
 *
 * Created on 10 de agosto de 2026, 04:41 PM
 */


#include <xc.h>

int main(void)
{

// configuracion inicial
// a qui configuramos los pines (TRIS, ANSEL) una sola vez
ANSELBbits.ANSELB1=0; // desactivando el modo analogico del pin RB1
TRISBbits.TRISB1=0;// estableciendo al pin RB1 como salida

ANSELCbits.ANSELC2=0;// desactivando el modo analogico del pin RC2
TRISCbits.TRISC2=1; // estableciendo el pin RC2 como entrada
WPUCbits.WPUC2 = 1; // activando la resistencia pull-up() del curiocity nano 

while(1)
{

if(PORTCbits.RC2==0)
   {
        
      // aqui ira el control continuo (LAT, PORT) para prender los leds o leer los botones
     LATBbits.LATB1=1;// encendiendo el pin RB1    
    }
else
   {

    LATBbits.LATB1=0;
    }
}

return 0;
}
