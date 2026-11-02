/*
 * File:   main.c
 * Author: Grupo 04
 *
 * Created on 1 de noviembre de 2026, 06:08 PM
 */


#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 4000000UL

void configuro(void){
    // Configuración a 4 MHz (OSCEN corregido a 0x40 para HFOEN)
    OSCCON1 = 0x60;
    OSCFRQ = 0x02;
    OSCEN = 0x40; // Habilita el oscilador principal
    
    
    
    //-------------------------------------------------
    //puertos de los ultrasonicos
    //-------------------------------------------------
    
    //ultrasonico derecha
    // Salida para el Trigger de HC-SR04 d
    TRISDbits.TRISD0 = 0;   // RD0 como salida
    ANSELDbits.ANSELD0 = 0; // RD0 digital
    LATDbits.LATD0 = 0;     // Apagar RD0 inicialmente
    // Entrada para el Echo de HC-SR04 derecha
    TRISDbits.TRISD1 = 1;   // RD1 como entrada
    ANSELDbits.ANSELD1 = 0; // RD1 digital
    
    //ultrasonico izquierdo
    TRISDbits.TRISD2 = 0;   // RD2 como salida
    ANSELDbits.ANSELD2 = 0; // RD2 digital
    LATDbits.LATD2 = 0;     // Apagar RD2 inicialmente
    // Entrada para el Echo de HC-SR04
    TRISDbits.TRISD3 = 1;   // RD3 como entrada
    ANSELDbits.ANSELD3 = 0; // RD3 digital
   
    // ultrasonico delantero
    TRISDbits.TRISD4 = 0;   // RD4 como salida
    ANSELDbits.ANSELD4 = 0; // RD4 digital
    LATDbits.LATD4 = 0;     // Apagar RD4 inicialmente
    // Entrada para el Echo de HC-SR04
    TRISDbits.TRISD5 = 1;   // RD5 como entrada
    ANSELDbits.ANSELD5 = 0; // RD5 digital
    
    
    
    //-------------------------------------------------
    //puertos del VL53L0x
    //-------------------------------------------------
    
    
    //-------------------------------------------------
    //puertos del PIR
    //-------------------------------------------------
    
    
    //-------------------------------------------------
    //puertos del HALL MC-38
    //-------------------------------------------------
    
    
    //-------------------------------------------------
    //puertos del HALL SS49E
    //-------------------------------------------------
    TRISCbits.TRISC0 = 1;    // RC0 como entrada
    ANSELCbits.ANSELC0 = 1;  // RC0 como entrada analógica
    
    //-------------------------------------------------
    //puertos del LDR
    //-------------------------------------------------
    
    
    //-------------------------------------------------
    //puertos del LM35
    //-------------------------------------------------
    
    
    //-------------------------------------------------
    //puertos del divisor de tension(voltimetro))
    //-------------------------------------------------
    
    
    //-------------------------------------------------
    //puertos de los DRIVERS TB6612FNG
    //-------------------------------------------------
    
    
    //-------------------------------------------------
    //Puertos de protocolo UART
    //-------------------------------------------------


    // CONFIGURACIÓN ADC
    FVRCON = 0x81;
    ADCON0 = 0x94;
    ADREF  = 0x03;
    ADPCH  = 0x00;    
}


// prototipos

float d_HCSR04(void);
float HCSR501(void);
float VL53L0X(void);
int HALL_SS49E(void);
float LM35(void);
float LDR(void);
float VOLTAJE(void);
// falta las funciones cinematicas




void main(void) {
    
    while(1){
    
    
    
    
    
    
    
    
    }
    
}



//===================================
//Funciones
//===================================


float d_HCSR04(void)
{
    unsigned int contador = 0;
    unsigned int espera = 0;

    // 1. Disparo del Trigger
    LATBbits.LATB0 = 1;
    __delay_us(10);
    LATBbits.LATB0 = 0;

    // 2. Esperar a que Echo se active
    while(PORTBbits.RB1 == 0)
    {
        espera++;
        __delay_us(10);

        if(espera > 2000)
            return -1.0f;  // Error: no recibió respuesta
    }

    // 3. Medir duración del pulso Echo
    while(PORTBbits.RB1 == 1)
    {
        contador++;
        __delay_us(10);

        if(contador > 3000)
            return -1.0f;  // Error: tiempo excedido
    }

    // 4. Calcular distancia
    float distancia_real = (contador * 10.0f * 0.0343f) / 2.0f;

    return distancia_real;
}

int HALL_SS49E(void)
{
    ADCON0bits.GO_nDONE = 1;
    while(ADCON0bits.GO_nDONE == 1);

    unsigned int adc_raw = ((unsigned int)ADRESH << 8) | ADRESL;

    long voltaje_mV = (long)adc_raw * 4L;

    int campo_gauss = (int)(((voltaje_mV - 2500L) * 10L) / 14L);

    return campo_gauss;
}