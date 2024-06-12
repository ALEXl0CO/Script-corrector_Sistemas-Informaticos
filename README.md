# Script corrector Sistemas Informaticos

## Descripción
Este script de bash formatea los ejercicios de scripts de la asignatura de Sistemas Informáticos. Todo con el fin de facilitar la corrección de los scripts al profesorado y evitar la ejecución de posibles scripts maliciosos.


## Requerimientos
- Ejecutar el script en un entorno seguro para evitar posibles errores inesperados. Por ejemplo, una máquina virtual Linux.
- Tener `unzip` instalado en el sistema para poder descomprimir los zips.
- Instalar una extensión y aplicar la configuración mencionada para aumentar la velocidad de corrección. (Opcional pero altamente recomendado).


## Uso
Para poder usar este script primero deberás descargar dicho script. Después, deberás guardarlo en un directorio junto con las carpetas contenedoras de los zips.

Debería tener el siguiente aspecto:
IMAGEN

Una vez guardado en un archivo con las carpetas conetnedoras de los zips, deberás darle permisos de ejecución:
```bash
sudo chmod +x corrector.sh
```

Después de haber otorgado los permisos necesarios, ejecuta el script:
```bash
bash script.sh
```


## Funcionamiento
Este script tiene distintos menús en función de la cantidad de carpetas que hayan en el directorio con zips. Si hay más de una carpeta, se mostrará un menú con las carpetas disponibles para corregir. Si solo hay una carpeta, te mostrará sus respectivas opciones.

Una vez ejecutado el script, no habrá problema en ejecutar de nuevo dicho script con el directorio de Respuestas ya que este está configurado para no aparecer.

**¡IMPORTANTE**: Cada vez que se ejecute dicho script, sobreescibirá los archivos de la carpeta Respuestas. Por lo que si quieres conservar los resultados de una ejecución anterior, deberás moverlos a otra carpeta.

### Menú para distintas carpetas
IMAGEN

### Menú para una sola carpeta
IMAGEN


## Resultado
Una vez ejecutado el formateo, se creará un árbol de directorios en el cual se guardarán los directorios y ficheros de cada zip y todos archivos con cada script formateado para su posterior corrección. Adjunto el arbol de directorios de un ejemplo de ejecución:

```
.
├── 1º DAW - B
│   ├── Carmen_Hernández.zip
│   ├── Laura_Fernández.zip
│   ├── Luis_Martínez.zip
│   ├── Miguel_Rodríguez.zip
│   └── Pedro_López.zip
├── Respuestas
│   ├── CarpetasDescomprimidas
│   │   └── 1º DAW - B
│   │       ├── Carmen_Hernández
│   │       │   ├── script1.sh
│   │       │   ├── script2.sh
│   │       │   ├── script3.sh
│   │       │   ├── script4.sh
│   │       │   ├── script5.sh
│   │       │   ├── script6.sh
│   │       │   ├── script7.sh
│   │       │   ├── script8.sh
│   │       │   └── script9.sh
│   │       ├── Laura_Fernández
│   │       │   ├── script1.sh
│   │       │   ├── script2.sh
│   │       │   ├── script3.sh
│   │       │   ├── script4.sh
│   │       │   ├── script5.sh
│   │       │   ├── script6.sh
│   │       │   ├── script7.sh
│   │       │   ├── script8.sh
│   │       │   └── script9.sh
│   │       ├── Luis_Martínez
│   │       │   ├── script1.sh
│   │       │   ├── script2.sh
│   │       │   ├── script3.sh
│   │       │   ├── script4.sh
│   │       │   ├── script5.sh
│   │       │   ├── script6.sh
│   │       │   ├── script7.sh
│   │       │   ├── script8.sh
│   │       │   └── script9.sh
│   │       ├── Miguel_Rodríguez
│   │       │   ├── script1.sh
│   │       │   ├── script2.sh
│   │       │   ├── script3.sh
│   │       │   ├── script4.sh
│   │       │   ├── script5.sh
│   │       │   ├── script6.sh
│   │       │   ├── script7.sh
│   │       │   ├── script8.sh
│   │       │   └── script9.sh
│   │       └── Pedro_López
│   │           ├── script1.sh
│   │           ├── script2.sh
│   │           ├── script3.sh
│   │           ├── script4.sh
│   │           ├── script5.sh
│   │           ├── script6.sh
│   │           ├── script7.sh
│   │           ├── script8.sh
│   │           └── script9.sh
│   └── Resultados
│       └── 1º DAW - B
│           ├── Carmen_Hernández.md
│           ├── Laura_Fernández.md
│           ├── Luis_Martínez.md
│           ├── Miguel_Rodríguez.md
│           └── Pedro_López.md
└── script.sh

11 directories, 56 files
```


<br>

## Configuración de la extensión del navegador
Para aumentar la velocidad de corrección, se recomienda instalar la extensión de navegador [**Markdown Viewer**](https://chromewebstore.google.com/detail/ckkdlimhmcjmikdlpkmbgfkaikojcbjk) en el navegador Google Chrome. Esta extensión simplemente permite visualizar los archivos `.md` en el navegador sin necesidad de abrir un editor de texto.

Una vez instalada, para configurar la extensión deberás seguir los siguientes pasos:
1. Haz click izquierdo en el icono de la extensión.
2. Clica en "ADVANCED OPTIONS".
3. Dale permisos a la extensión para que pueda leer archivos locales, para ello clica en "ALLOW ACCESS" de la opción "File Access". Una vez dentro busca esta opción y actívala.
   IMAGEN
4. Finalmente, abre la configuración de la extensión de nuevo y en la barra de navegación de la parte superior clica en "Settings".
5. En el apartado de "Theme" pon estas opciones:
   IMAGEN