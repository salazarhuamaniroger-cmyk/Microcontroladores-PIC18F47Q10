#include <xc.h>
#include "cabecera.h"
#include "oled.h"
#define _XTAL_FREQ 4000000UL
 
void main(void){
 
    OLED_Iniciar();
 
    OLED_Texto(25, 1, "BIOMEDICA");
    OLED_Texto(20, 3, "CHISTE");
 
    while(1){
        // el programa solo muestra eso
    }
}
 
