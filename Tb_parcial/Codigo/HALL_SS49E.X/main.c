#include <xc.h>
#include "header.h" // Tu archivo de configuración del PIC
#include "LCD.h"      // Tu librería de LCD de clase
#define _XTAL_FREQ 4000000UL

void configuracion(void) {
    // 1. Oscilador interno HFINTOSC a 4 MHz
    OSCCON1 = 0x60; // HFINTOSC[span_4](start_span)[span_4](end_span)
    OSCFRQ  = 0x02; // 4 MHz[span_5](start_span)[span_5](end_span)
    OSCEN   = 0x40; // Habilitar HFINTOSC[span_6](start_span)[span_6](end_span)
    
    // 2. Pin RA0 como entrada analógica para el sensor
    TRISAbits.TRISA0 = 1;   // RA0 como entrada[span_7](start_span)[span_7](end_span)
    ANSELAbits.ANSELA0 = 1; // RA0 en modo analógico[span_8](start_span)[span_8](end_span)
    
    // 3. Inicializar LCD
    LCD_INIT();
    
    // 4. Configurar ADC (basado en la pizarra, adaptado al rango de 1V a 4V del SS49E)
    FVRCON = 0x83; // FVR activado a 4.096V (1 paso del ADC = 4 mV)[span_9](start_span)[span_9](end_span)[span_10](start_span)[span_10](end_span)
    ADCON0 = 0x94; // ADC encendido, reloj ADCRC, justificado a la derecha[span_11](start_span)[span_11](end_span)
    ADREF  = 0x03; // Referencia positiva conectada al FVR[span_12](start_span)[span_12](end_span)
    ADPCH  = 0x00; // Canal analógico ANA0 (RA0)[span_13](start_span)[span_13](end_span)[span_14](start_span)[span_14](end_span)
}

void main(void) {
    configuracion();   
    
    while (1) {
        // 1. Iniciar conversión y leer el ADC (0 a 1023)
        ADCON0bits.GO_nDONE = 1;
        while(ADCON0bits.GO_nDONE == 1);
        unsigned int adc_raw = (unsigned int)((ADRESH << 8) + ADRESL); //[span_15](start_span)[span_15](end_span)
        
        // 2. Regla de 3: Pasar de lectura ADC a milivoltios
        // Como FVR = 4096 mV y el ADC tiene 1024 niveles: cada nivel vale 4 mV
        long voltaje_mV = (long)adc_raw * 4L;
        
        // 3. Regla de 3: Pasar de milivoltios a Gauss
        // En 0 Gauss el SS49E da 2500 mV (2.5V) y cambia 1.4 mV por cada 1 Gauss[span_16](start_span)[span_16](end_span)
        // Gauss = (voltaje_mV - 2500) / 1.4  --> equivale a: ((voltaje_mV - 2500) * 10) / 14
        int campo_gauss = (int)(((voltaje_mV - 2500L) * 10L) / 14L);
        
        // Obtener el valor positivo para imprimirlo con LCD_ESCRIBE_VAR_INT
        unsigned int magnitud = (campo_gauss < 0) ? (unsigned int)(-campo_gauss) : (unsigned int)campo_gauss;
        
        // 4. Mostrar en el LCD
        POS_CURSOR(1, 0);
        ESCRIBE_MENSAJE2("Campo Magnetico:");
        
        POS_CURSOR(2, 0);
        if (campo_gauss < 0) {
            ENVIA_CHAR('-'); // Polo Norte[span_17](start_span)[span_17](end_span)
        } else {
            ENVIA_CHAR('+'); // Polo Sur[span_18](start_span)[span_18](end_span)
        }
        
        LCD_ESCRIBE_VAR_INT(magnitud, 4); // Muestra 4 dígitos (ej. 0500)
        ESCRIBE_MENSAJE2(" Gauss     ");  // Limpia caracteres sobrantes
        
        __delay_ms(200);
    }
}
