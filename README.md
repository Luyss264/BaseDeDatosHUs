# StreamHub - Base de Datos No Relacional

Este proyecto contiene la estructura inicial y la automatización de la base de datos para la plataforma **StreamHub** corriendo en un entorno local.

## Estructura del Proyecto

La carpeta del proyecto consta únicamente de un archivo estructurado:
└── script.js      # Contiene la inicialización de datos, consultas, índices y agregaciones.

---

## Tecnologías Utilizadas

* **MongoDB Compass:** Interfaz gráfica oficial utilizada para visualizar, auditar y revisar de forma intuitiva las colecciones (`usuarios`, `contenido`, `valoraciones`) y sus respectivos índices sin necesidad de interactuar únicamente con código.
* **MongoDB Shell (mongosh):** Consola de comandos donde se procesa e interpreta el script. MongoDB utiliza un modelo de "creación perezosa" (lazy creation), lo que significa que la base de datos y sus tablas no relacionales se generan dinámicamente en el almacenamiento local en el milisegundo exacto en que `mongosh` ejecuta la primera inserción de datos.

---

## Instrucciones de Ejecución

Puedes correr el script utilizando cualquiera de los siguientes dos métodos, dependiendo de la disponibilidad de la interfaz gráfica:

### Opción 1: Desde la terminal integrada de MongoDB Compass
1. Abre **MongoDB Compass** y conéctate al servidor local (`mongodb://localhost:27017`).
2. Despliega la consola **_mongosh** ubicada en la barra inferior de la interfaz.
3. Copia el contenido completo de `script.js`, pégalo en la casilla negra y presiona `Enter`.
4. Haz clic en el botón de actualización (*refresh*) en el panel izquierdo de Compass para ver aparecer la base de datos y sus datos de forma visual.

### Opción 2: Desde la Terminal del Sistema (Consola Pura)
Si la interfaz gráfica presenta problemas de carga, la consola permite una ejecución directa y automatizada:
1. Abre la terminal de tu sistema operativo (CMD o PowerShell) directamente en la carpeta donde se encuentra el archivo `script.js`.
2. Ejecuta el siguiente comando para que el motor procese el archivo:
   ```bash
   mongosh script.js