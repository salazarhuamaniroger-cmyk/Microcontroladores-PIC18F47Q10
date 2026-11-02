# 1 "LCD.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 295 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Program Files\\Microchip\\xc8\\v3.10\\pic\\include/language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "LCD.c" 2
# 11 "LCD.c"
void POS_CURSOR(unsigned char fila,unsigned char columna);
void DISPLAY_ONOFF(unsigned char estado);
void CURSOR_HOME(void);
void CURSOR_ONOFF(unsigned char estado);
void ENVIA_CHAR(unsigned char dato);
void BORRAR_LCD(void);
void LCD_CONFIG(void);
void ENVIA_NIBBLE(unsigned char dato);
void ENVIA_LCD_CMD(unsigned char dato);
void LEER_LCD(void);
void BLINK_CURSOR(unsigned char val);
void GENERACARACTER(const unsigned char *vector,unsigned char pos);
void ESCRIBE_MENSAJE(const char *cadena,unsigned char tam);
void ESCRIBE_MENSAJE2(const char *cadena);
void CURSOR_SHIFTLEFT(void);
void CURSOR_SHIFTRIGHT(void);
void DISPLAY_SHIFTLEFT(void);
void DISPLAY_SHIFTRIGHT(void);
void LCD_INIT(void);
void LCD_ESCRIBE_VAR_CHAR(unsigned char numero, unsigned char n_digitos);
void LCD_ESCRIBE_VAR_INT(unsigned int numero, unsigned char n_digitos);
void LCD_CHAR_GRADO(void);
void LCD_VARCHAR_BITS(unsigned char dato);
