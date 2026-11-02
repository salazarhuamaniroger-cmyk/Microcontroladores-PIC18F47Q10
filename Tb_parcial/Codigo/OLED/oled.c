
#include <xc.h>
#include "oled.h" 
#define _XTAL_FREQ    4000000UL    // debe coincidir con la frecuencia real del PIC (cabecita.h)
#define I2C_VELOCIDAD 100000UL      // 100 kHz
 
// ---------- FUENTE 5x7 ----------
// Tabla en orden ASCII desde el espacio (32) hasta la Z (90).
// Índice = carácter - 32. Cada carácter son 5 columnas de 8 píxeles (bit 0 = arriba).
const unsigned char fuente[][5] = {
    {0x00,0x00,0x00,0x00,0x00},  // ' '
    {0x00,0x00,0x5F,0x00,0x00},  // !
    {0x00,0x07,0x00,0x07,0x00},  // "
    {0x14,0x7F,0x14,0x7F,0x14},  // #
    {0x24,0x2A,0x7F,0x2A,0x12},  // $
    {0x23,0x13,0x08,0x64,0x62},  // %
    {0x36,0x49,0x56,0x20,0x50},  // &
    {0x00,0x08,0x07,0x03,0x00},  // '
    {0x00,0x1C,0x22,0x41,0x00},  // (
    {0x00,0x41,0x22,0x1C,0x00},  // )
    {0x2A,0x1C,0x7F,0x1C,0x2A},  // *
    {0x08,0x08,0x3E,0x08,0x08},  // +
    {0x00,0x80,0x70,0x30,0x00},  // ,
    {0x08,0x08,0x08,0x08,0x08},  // -
    {0x00,0x00,0x60,0x60,0x00},  // .
    {0x20,0x10,0x08,0x04,0x02},  // /
    {0x3E,0x51,0x49,0x45,0x3E},  // 0
    {0x00,0x42,0x7F,0x40,0x00},  // 1
    {0x72,0x49,0x49,0x49,0x46},  // 2
    {0x21,0x41,0x49,0x4D,0x33},  // 3
    {0x18,0x14,0x12,0x7F,0x10},  // 4
    {0x27,0x45,0x45,0x45,0x39},  // 5
    {0x3C,0x4A,0x49,0x49,0x31},  // 6
    {0x41,0x21,0x11,0x09,0x07},  // 7
    {0x36,0x49,0x49,0x49,0x36},  // 8
    {0x46,0x49,0x49,0x29,0x1E},  // 9
    {0x00,0x00,0x14,0x00,0x00},  // :
    {0x00,0x40,0x34,0x00,0x00},  // ;
    {0x00,0x08,0x14,0x22,0x41},  // <
    {0x14,0x14,0x14,0x14,0x14},  // =
    {0x00,0x41,0x22,0x14,0x08},  // >
    {0x02,0x01,0x59,0x09,0x06},  // ?
    {0x3E,0x41,0x5D,0x59,0x4E},  // @
    {0x7C,0x12,0x11,0x12,0x7C},  // A
    {0x7F,0x49,0x49,0x49,0x36},  // B
    {0x3E,0x41,0x41,0x41,0x22},  // C
    {0x7F,0x41,0x41,0x41,0x3E},  // D
    {0x7F,0x49,0x49,0x49,0x41},  // E
    {0x7F,0x09,0x09,0x09,0x01},  // F
    {0x3E,0x41,0x41,0x51,0x73},  // G
    {0x7F,0x08,0x08,0x08,0x7F},  // H
    {0x00,0x41,0x7F,0x41,0x00},  // I
    {0x20,0x40,0x41,0x3F,0x01},  // J
    {0x7F,0x08,0x14,0x22,0x41},  // K
    {0x7F,0x40,0x40,0x40,0x40},  // L
    {0x7F,0x02,0x1C,0x02,0x7F},  // M
    {0x7F,0x04,0x08,0x10,0x7F},  // N
    {0x3E,0x41,0x41,0x41,0x3E},  // O
    {0x7F,0x09,0x09,0x09,0x06},  // P
    {0x3E,0x41,0x51,0x21,0x5E},  // Q
    {0x7F,0x09,0x19,0x29,0x46},  // R
    {0x26,0x49,0x49,0x49,0x32},  // S
    {0x03,0x01,0x7F,0x01,0x03},  // T
    {0x3F,0x40,0x40,0x40,0x3F},  // U
    {0x1F,0x20,0x40,0x20,0x1F},  // V
    {0x3F,0x40,0x38,0x40,0x3F},  // W
    {0x63,0x14,0x08,0x14,0x63},  // X
    {0x03,0x04,0x78,0x04,0x03},  // Y
    {0x61,0x59,0x49,0x4D,0x43}   // Z
};
 
// ---------- I2C POR HARDWARE (MSSP1) ----------
void I2C_Iniciar(void)
{
    ANSELCbits.ANSELC3 = 0;     // RC3 digital
    ANSELCbits.ANSELC4 = 0;     // RC4 digital
    TRISCbits.TRISC3 = 1;       // el MSSP controla la dirección, los dejamos como entrada
    TRISCbits.TRISC4 = 1;
    ODCONCbits.ODCC3 = 1;       // RC3 en drenador abierto (obligatorio en I2C)
    ODCONCbits.ODCC4 = 1;       // RC4 en drenador abierto (obligatorio en I2C)
 
    // Conectar el MSSP1 a los pines RC3 y RC4 (PPS)
    PPSLOCK = 0x55;             // secuencia de desbloqueo
    PPSLOCK = 0xAA;
    PPSLOCKbits.PPSLOCKED = 0;  //desbloqueado
    //manipulo los registros de entrada del pps
    SSP1CLKPPS = 0x13;          // entrada de reloj SCL1 viene de RC3
    SSP1DATPPS = 0x14;          // entrada de datos SDA1 viene de RC4
    RC3PPS = 0x0F;              // salida SCL1 sale por RC3
    RC4PPS = 0x10;              // salida SDA1 sale por RC4
    //manipulo registros de salida del pps
    PPSLOCK = 0x55;             
    PPSLOCK = 0xAA;
   //////////////////////////////////
    PPSLOCKbits.PPSLOCKED = 1;   // volver a bloquear
 
    SSP1STAT = 0x80;            // SMP = 1: velocidad estándar (100 kHz)
    SSP1CON1 = 0x28;            // SSPEN = 1 y modo maestro I2C (SSPM = 1000)
    SSP1CON2 = 0x00;
    SSP1ADD  = (_XTAL_FREQ / (4UL * I2C_VELOCIDAD)) - 1;   // Fscl = Fosc / (4 x (SSP1ADD + 1))
    PIR3bits.SSP1IF = 0;        // limpiar bandera
}
 
void I2C_Esperar(void)
{
    while (!PIR3bits.SSP1IF);   // espera a que el hardware termine
    PIR3bits.SSP1IF = 0;        // bajar la bandera para la siguiente operación
}
 
void I2C_Inicio(void)
{
    SSP1CON2bits.SEN = 1;       // el hardware genera el START
    I2C_Esperar();
}
 
void I2C_Fin(void)
{
    SSP1CON2bits.PEN = 1;       // el hardware genera el STOP
    I2C_Esperar();
}
 
unsigned char I2C_Escribir(unsigned char dato)
{
    SSP1BUF = dato;             // al escribir aquí, el hardware saca los 8 bits
    I2C_Esperar();              // y también el noveno pulso (ACK)
    return SSP1CON2bits.ACKSTAT;   // 0 = el OLED respondió, 1 = nadie respondió
}
 
// ---------- OLED (SSD1306) ----------
void OLED_Comando(unsigned char cmd)
{
    I2C_Inicio();
    I2C_Escribir(OLED_DIR);
    I2C_Escribir(0x00);         // 0x00 = lo que sigue es un comando
    I2C_Escribir(cmd);
    I2C_Fin();
}
 
void OLED_Posicion(unsigned char columna, unsigned char pagina)
{
    OLED_Comando(0xB0 | pagina);            // página (fila de 8 píxeles) 0-7
    OLED_Comando(0x00 | (columna & 0x0F));  // columna, nibble bajo
    OLED_Comando(0x10 | (columna >> 4));    // columna, nibble alto
}
 
void OLED_Limpiar(void)
{
    for (unsigned char p = 0; p < 8; p++)
    {
        OLED_Posicion(0, p);
        I2C_Inicio();
        I2C_Escribir(OLED_DIR);
        I2C_Escribir(0x40);                 // 0x40 = lo que sigue son datos
        for (unsigned char c = 0; c < 128; c++)
            I2C_Escribir(0x00);
        I2C_Fin();
    }
}
 
void OLED_Linea(unsigned char pagina)       // barra horizontal decorativa
{
    OLED_Posicion(0, pagina);
    I2C_Inicio();
    I2C_Escribir(OLED_DIR);
    I2C_Escribir(0x40);
    for (unsigned char c = 0; c < 128; c++)
        I2C_Escribir(0x18);
    I2C_Fin();
}
 
void OLED_Texto(unsigned char columna, unsigned char pagina, const char *texto)
{
    unsigned char c, k;
 
    OLED_Posicion(columna, pagina);
    I2C_Inicio();
    I2C_Escribir(OLED_DIR);
    I2C_Escribir(0x40);
 
    while (*texto != '\0')
    {
        c = *texto;
        if (c >= 'a' && c <= 'z')               // minúscula -> mayúscula
            c = c - 32;
        if (c < ' ' || c > 'Z')                 // si no está en la tabla, se muestra un espacio
            c = ' ';
        c = c - ' ';                            // índice en la tabla (el espacio es el 0)
 
        for (k = 0; k < 5; k++)
            I2C_Escribir(fuente[c][k]);
        I2C_Escribir(0x00);                     // columna vacía entre letras
        texto++;
    }
    I2C_Fin();
}
 
void OLED_Iniciar(void)
{
    I2C_Iniciar();
    __delay_ms(100);
    OLED_Comando(0xAE);                     // pantalla apagada
    OLED_Comando(0xD5); OLED_Comando(0x80); // reloj
    OLED_Comando(0xA8); OLED_Comando(0x3F); // 64 filas
    OLED_Comando(0xD3); OLED_Comando(0x00); // sin desplazamiento
    OLED_Comando(0x40);                     // inicio de línea 0
    OLED_Comando(0x8D); OLED_Comando(0x14); // bomba de carga activada
    OLED_Comando(0x20); OLED_Comando(0x02); // modo de direccionamiento por páginas
    OLED_Comando(0xA0);                     // orientación de columnas
    OLED_Comando(0xC0);                     // orientación de filas
    OLED_Comando(0xDA); OLED_Comando(0x12);
    OLED_Comando(0x81); OLED_Comando(0xCF); // contraste
    OLED_Comando(0xD9); OLED_Comando(0xF1);
    OLED_Comando(0xDB); OLED_Comando(0x40);
    OLED_Comando(0xA4);                     // mostrar contenido de la RAM
    OLED_Comando(0xA6);                     // imagen normal (no invertida)
    OLED_Comando(0xAF);                     // pantalla encendida
    OLED_Limpiar();                         // empezar con la pantalla en blanco
}
 