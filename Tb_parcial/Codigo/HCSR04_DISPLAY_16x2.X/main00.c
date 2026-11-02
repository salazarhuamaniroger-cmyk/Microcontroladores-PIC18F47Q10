#include <xc.h>
#include "header.h"
#include "LCD.h"
#define _XTAL_FREQ 4000000UL

void configuro(void){
    // Configuración a 4 MHz (OSCEN corregido a 0x40 para HFOEN)
    OSCCON1 = 0x60;
    OSCFRQ = 0x02;
    OSCEN = 0x40; // CORREGIDO: Habilita el oscilador principal
    
    // Salida para el Trigger de HC-SR04 en RB0
    TRISBbits.TRISB0 = 0;   // RB0 como salida
    ANSELBbits.ANSELB0 = 0; // RB0 digital
    LATBbits.LATB0 = 0;     // Apagar RB0 inicialmente
    
    // Entrada para el Echo de HC-SR04 en RB1
    TRISBbits.TRISB1 = 1;   // RB1 como entrada
    ANSELBbits.ANSELB1 = 0; // RB1 digital
    
    // Inicializa el LCD
    LCD_INIT();
    
    // Mensaje fijo en la primera fila
    POS_CURSOR(1, 0);
    ESCRIBE_MENSAJE2("Distancia en cm:");
}

void main(void) {
    configuro();
    
    while(1){
        // 1. Disparo del Trigger (10 us)
        LATBbits.LATB0 = 1;
        __delay_us(10);
        LATBbits.LATB0 = 0;
        
        unsigned int contador = 0;
        unsigned int espera = 0;
        
        // 2. Esperar a que Echo (RB1) se active (con protección de tiempo)
        while(PORTBbits.RB1 == 0){
            espera++;
            __delay_us(10);
            if(espera > 2000) break; // Si en ~20 ms no responde, sale y reintenta
        }
        
        // 3. Mientras Echo (RB1) está en alto contamos
        while(PORTBbits.RB1 == 1){
            contador++;
            __delay_us(10);
            if(contador > 3000) break; // Límite de seguridad contra desbordamiento
        }
        
        // 4. Cálculo de distancia
        //float distancia_real = (contador * 10.0f * 0.0343f) / (2.0f * 3.0f);
        float distancia_real = (contador * 10.0 * 0.0343) / (2.0);
        unsigned int distancia_entera = (unsigned int)distancia_real;
        
        // 5. Escribir el resultado en el LCD
        POS_CURSOR(2, 0);
        LCD_ESCRIBE_VAR_INT(distancia_entera, 3);
        ESCRIBE_MENSAJE2(" cm  ");
        
        // 6. Pausa antes del siguiente disparo
        __delay_ms(60);
    }
}