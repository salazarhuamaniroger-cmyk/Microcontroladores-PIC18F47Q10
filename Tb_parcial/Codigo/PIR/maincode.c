#include <xc.h>
#include "cabecera.h"  // Aquí ya van incluidos los fuses de configuración
#define _XTAL_FREQ 4000000UL      // Frecuencia del oscilador

void configuracion(void) {
    OSCCON1 = 0x60;
    OSCFRQ  = 0x02;
    OSCEN   = 0x40;
    
    // 2. Sensor PIR (3.3V) en RA6 con umbral TTL
    TRISAbits.TRISA6   = 1; // RA6 como entrada
    ANSELAbits.ANSELA6 = 0; // RA6 como digital
    INLVLAbits.INLVLA6 = 0; // Umbral TTL en RA6
    
    // 3. LED indicador en RB0
    TRISBbits.TRISB0   = 0; // RB0 como salida
    ANSELBbits.ANSELB0 = 0; // RB0 como digital
    LATBbits.LATB0     = 0; // LED apagado al iniciar
}

void main(void) {
    configuracion();
    
    while(1) {
        // Lee el estado del sensor PIR en RA6
        if (PORTAbits.RA6 == 1) {
            LATBbits.LATB0 = 1; // Movimiento detectado: enciende LED en RB0
        } else {
            LATBbits.LATB0 = 0; // Sin movimiento: apaga LED
        }
        
        __delay_ms(50);
    }
}
