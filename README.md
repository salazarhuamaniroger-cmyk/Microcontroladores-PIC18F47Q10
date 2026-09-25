# Microcontroladores PIC18F47Q10 - UPC

Repositorio unificado de prácticas de laboratorio, simulaciones electrónicas y proyectos autónomos del curso de **Microcontroladores** en la carrera de Ingeniería Mecatrónica (Ciclo 5) de la **Universidad Peruana de Ciencias Aplicadas (UPC)**.

##   Descripción del Repositorio

Este repositorio reúne las soluciones de firmware, algoritmos y circuitos esquemáticos desarrollados a lo largo del ciclo. Los proyectos abarcan programación en **Ensamblador (Assembler)** y **C** sobre microcontroladores PIC de arquitectura de 8 bits de Microchip (familias **PIC18F47Q10**, **PIC18F27Q10** y **PIC18F57Q43**), integrando:

* Entorno de desarrollo oficial: **MPLAB X IDE** con compiladores/ensambladores **pic-as / XC8**.

* Validación y simulación circuital: **Proteus Design Suite (ISIS)**.

* Documentación de hojas de datos oficiales (*datasheets*).

## 📁 Estructura del Repositorio

La jerarquía del proyecto se organiza por módulos temáticos, laboratorios calificados y avances semanales:

```
.
├── PIC18F27Q10.PDF                                      # Hoja de datos (Datasheet) de referencia técnica
├── README.md                                            # Documentación principal del repositorio
│
├── Semana_2/                                            # Práctica de compuertas lógicas y puertos I/O
│   ├── minilab_semana_2.X/                              # Proyecto MPLAB X IDE
│   ├── compuerta_not.pdsprj                             # Simulación en Proteus (compuerta NOT)
│   ├── compuerta_not.pdsprj.LAPTOP-...workspace         # Configuración de entorno local Proteus
│   └── Semana_2.zip                                     # Respaldo comprimido del minilaboratorio
│
├── Semana_3/                                            # Lógica combinacional y control secuencial
│   └── semana_3.X/                                      # Proyecto MPLAB X IDE
│       ├── header.inc                                   # Cabeceras y configuración de fusibles/registros
│       ├── body.s                                       # Rutina principal y lógica en ensamblador
│       ├── Makefile                                     # Reglas de compilación automatizadas
│       └── nbproject/                                   # Metadatos del entorno MPLAB X
│
├── labs/                                                # Evaluaciones de laboratorio calificado
│   ├── LB1_202620_8517_Salazar_Roger.../                # Entregables y reportes de Laboratorio 1
│   └── lab_01_v2.0/                                     # Proyecto revisado de Laboratorio 1
│       └── LAB_1_V2.0.X/                                # Proyecto MPLAB X IDE
│           ├── header.inc                               # Definición de puertos y registros
│           ├── maincode.s                               # Código fuente principal en Ensamblador
│           ├── Makefile                                 # Script de construcción
│           └── nbproject/                               # Configuraciones de compilador y depurador
│
├── ptc_autonomas_asember-PIC18F.../                     # Prácticas autónomas de consolidación en Ensamblador
│   ├── first_program_pic.X/                             # Primer programa formativo PIC
│   ├── primer_programa_asember.X/                       # Fundamentos de sintaxis y directivas pic-as
│   ├── segundo_programa_asember.X/                      # Estructuras de control y saltos condicionales
│   ├── contador 0-9 .X/                                 # Lógica de conteo incremental BCD básico
│   ├── contador 0-9_v.1000.X/                           # Contador con optimización de retardos
│   └── Display-7-segments.X/                            # Control directo de display de 7 segmentos
│
└── semana_5/display_multiplex/                          # Módulo de multiplexación temporal
    ├── display_multiplexado.X/                          # Proyecto MPLAB X IDE
    │   ├── header.inc                                   # Mapeo de puertos para segmentos y habilitadores
    │   ├── dist/                                        # Archivos binarios (.hex, .map, .sym)
    │   └── nbproject/                                   # Configuración de compilación
    └── esquematico_proteus/                             # Simulación circuital
        ├── DISPLAYX4.pdsprj                             # Simulación Proteus con display 4x7 segmentos
        ├── DISPLAYX4.pdsprj.LAPTOP-...workspace         # Espacio de trabajo Proteus
        └── Project Backups/                             # Respaldos de simulación

```

##  Herramientas y Requisitos

* **MPLAB X IDE**: v6.00 o superior.

* **Compilador/Ensamblador**: Microchip **XC8** / **pic-as**.

* **Simulador**: **Proteus ISIS** v8.10 o superior.

* **Dispositivos Objetivo**:

  * Microchip PIC18F47Q10

  * Microchip PIC18F57Q43

##  Flujo de Trabajo y Simulación

1. **Abrir el proyecto en MPLAB X:**

   Dirígete a `File -> Open Project...` y selecciona cualquiera de los directorios `.X`.

2. **Compilar el código:**

   Haz clic en **Clean and Build Project** (`Shift + F11`) para compilar el firmware y generar el binario `.hex` en la carpeta `dist/`.

3. **Ejecutar la simulación en Proteus:**

   Abre el archivo `.pdsprj` correspondiente, haz doble clic sobre el microcontrolador en el esquema y carga el archivo `.hex` generado.

## 👥 Autores y Colaboradores

* **Roger Salazar Huamani** - [salazarhuamaniroger-cmyk](https://github.com/salazarhuamaniroger-cmyk?utm_source=gemini) - *Estudiante de Ingeniería Mecatrónica, UPC*

* **Cristhoper Huamán** - *Colaborador / Estudiante de Ingeniería Mecatrónica, UPC*