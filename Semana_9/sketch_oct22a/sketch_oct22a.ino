unsigned char PUERTOS_LED[] = {2, 3, 4, 5, 6, 7, 8, 9};



unsigned char AUTO_FANT[] = {

 0x01, 0x02, 0x04, 0x08,

 0x10, 0x20, 0x40, 0x80

};



void setup() {

 Serial1.begin(115200);

 Serial1.println("Hello, Roger!");

 Serial1.println("Cambiate de carrera !");



 for (unsigned char x_var = 0; x_var < 8; x_var++) {

  pinMode(PUERTOS_LED[x_var], OUTPUT);

 }



 pinMode(17, INPUT_PULLUP);

 pinMode(16, INPUT_PULLUP);

}



void ESCRIBIR_LEDS(unsigned char numero) {

 for (unsigned char y_var = 0; y_var < 8; y_var++) {

  bool estado = (numero >> y_var) & 1;

  digitalWrite(PUERTOS_LED[y_var], estado ? HIGH : LOW);

 }

}



void loop() {

 for (unsigned char z_var = 0; z_var < 8; z_var++) {

  ESCRIBIR_LEDS(AUTO_FANT[z_var]);

  delay(300);

 }

}
