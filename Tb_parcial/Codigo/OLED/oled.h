
#ifndef OLED_H
#define OLED_H
 
// Libreria para OLED 128x64 (SSD1306) por I2C con MSSP1 del PIC18F47Q10
// SCL -> RC3, SDA -> RC4
 
#define OLED_DIR    0x78            // direccion 0x3C desplazada 1 bit (escritura)
 
// ---------- I2C POR HARDWARE (MSSP1) ----------
void I2C_Iniciar(void);                     // configura pines, PPS y el modulo MSSP1
void I2C_Esperar(void);                     // espera a que el hardware termine
void I2C_Inicio(void);                      // genera START
void I2C_Fin(void);                         // genera STOP
unsigned char I2C_Escribir(unsigned char dato);   // envia un byte, devuelve 0 si hubo ACK
 
// ---------- OLED (SSD1306) ----------
void OLED_Comando(unsigned char cmd);       // envia un comando
void OLED_Posicion(unsigned char columna, unsigned char pagina);   // columna 0-127, pagina 0-7
void OLED_Limpiar(void);                    // borra toda la pantalla
void OLED_Linea(unsigned char pagina);      // barra horizontal en una pagina
void OLED_Texto(unsigned char columna, unsigned char pagina, const char *texto);
void OLED_Iniciar(void);                    // inicia I2C, configura el SSD1306 y limpia la pantalla
 
#endif
 