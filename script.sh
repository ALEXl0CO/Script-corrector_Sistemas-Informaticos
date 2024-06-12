#!/bin/bash

############ Menús dinámicos ############

# Variable global para comprobar si el menú será dinámico o no.
opSeleccionada=0

# Variable global que almacenará todas las carpetas con zips.
carpetasConZips=()

# Variable global que almacenará un valor u otro en caso de que el menú sea dinámico o no y la selección del usuario.
#  Esto serivrá para no repetir código en caso de que el usuario quiera formatear todas las carpetas/clases, se
#  usará el mismo método que para formatear una clase pero para cáda carpeta/clase dentro del directorio actual.
textoUnicaClase=0

## Método que muestra el menú para formatear una clase.
menuOpcionUnaClase() {

    echo -e "\n\e[1m¿Qué quieres hacer?\e[0m\n"
    echo "  1. Formatear clase"
    echo "  2. Salir"

    opSeleccionada=1
}

## Método que muestra el menú completo.
menuCompleto() {

    # Todas las opciones del menú.
    opciones=("Elegir una clase" "Todas las clases con zips" "Salir")
    contador=0

    echo -e "\n\e[1m¿Qué quieres hacer?\e[0m\n"
    for opcion in "${opciones[@]}"
    do
        contador=$((contador+1))
        echo "  $contador. $opcion"
    done
}

## Método que lee la opción elegida del usuario y realiza las acciones necesarias para ella.
opcionSeleccionadaUsuario() {

    read -p $'\nOpción: ' seleccion

    # Si el menú es inferior al completo, se modifica la selección para poder salir del scrpit en caso de seleccionar 2.
    if [ $opSeleccionada -eq 1 -a $seleccion -eq 2 ]
    then
        seleccion=3
    elif [ $opSeleccionada -eq 1 -a $seleccion -eq 3 ]
    then
        seleccion=-1
    fi

    # Configuración necesaria para mejorar la usabilidad.
    if [ $opSeleccionada -eq 0 -a $seleccion -eq 1 ]
    then
        textoUnicaClase=1
    else
        textoUnicaClase=0
    fi


    # Switch de las opciones.
    case $seleccion in
        1)
            formatearUnaCarpetaVisual
        ;;
        2)
            formatearTodasLasCarpetas
        ;;
        3)
            echo "¡Adíos!"
            exit 0
        ;;
        *)
            clear
            echo -e "\e[1;31mOpción incorrecta\e[0m"
            sleep 1
            clear
        ;;
    esac
}

## Método que comprueba si hay o no carpetas en el directorio actia y si estas tienen 
##  archivos .zip o no en su interior para poder realizar el formateo.
mostrarCarpetasYContenido() {
    
    # Limpia el array de carpetas con zips para evitar errores.
    carpetasConZips=()

    # Comprueba si hay carpetas en el directorio actual.
    cantidadDirectorios=$(find . -type d | cut -d "/" -f "2" | uniq | sort -n | tail -n +2 | wc -l)

    # Comprueba si hay una carpeta de respuestas en el directorio actual para excluirla del formateador.
    if [ -d "Respuestas" ]
    then
        cantidadDirectorios=$((cantidadDirectorios-1))
    fi

    if [ $cantidadDirectorios -le '0' ]
    then
        echo "No hay carpetas en el directorio actual."
        exit 0
    else
        echo -e "Tienes estas carpetas en el directorio actual:\n"
        
        # Variables necesarias para las comprobaciones y los bucles.
        contador=0
        directoriosConZips=0

        # Bucle que recorre las carpetas y comprueba si tienen zips dentro o no.
        for carpeta in *
        do
            if [ -d "$carpeta" -a "$carpeta" != "Respuestas" ]
            then
                # Variable que almacena la cantidad de archivos .zip del directorio seleccionado.
                cantidadZipsDirectorio=$(find "$carpeta" -type f -name "*.zip" | wc -l)
                contador=$((contador+1))

                # Formateador del texto para una mejor experiencia de uso.
                if [ $cantidadZipsDirectorio -eq 0 ]
                then
                    cantidadZipsDirectorio="\e[1;31mVACÍA\e[0m"
                else
                    cantidadZipsDirectorio="\e[1;32m$cantidadZipsDirectorio \e[0;32mzips\e[0m"
                    directoriosConZips=$((directoriosConZips+1))

                    carpetasConZips+=("$carpeta")
                fi

                # Finalmente, se muestra la carpeta y la cantidad de zips que tiene si es que tiene junto con un índice.
                echo -e "  $contador. $carpeta | $cantidadZipsDirectorio"
            fi
        done

        # Si no contiene carpetas con zips, se mostrará un mensaje y se saldrá del script.
        if [ $directoriosConZips -eq 0 ]
        then
            echo -e "\nLas carpetas están vacías, añade .zips para poder formatear."
            exit 0
        fi

        # En caso de tener, se comprueba si son varias carpetas las que hay y llama al método correspondiente.
        echo -e "\n\n\e[1;33m¡ATENCIÓN! la ejeccución de este script eliminará, en caso de haber, correcciones previas.\e[0m"
        if [ $directoriosConZips -gt 1 ]
        then
            menuCompleto
        else
            menuOpcionUnaClase
        fi
    fi
}


## Método que formatea una carpeta específica.
formatearUnaCarpetaVisual() {
    
    clear
    
    # Si el menú está completo quiere decir que hay más de una carpeta y el usuario deberá poder elegirla.
    #  En caso de ser un menú dinámico, ya que sólo hay una carpeta disponible para formatear, se formateará directamente.
    #  Esto también sirve para no repetir código y llamar tantas veces como carpetas haya en el directorio actual si el menú
    #  no es dinámico (hay muchas carpetas y se selecciona la opción "Todas las clases").
    if [ $textoUnicaClase -eq 1 ]
    then

        selected=0
        ESC=$(printf "\033")

        # Bucle que lee las teclas de flechas y Enter del tecaldo.
        while true
        do
            # Se limpia todo y se muestra el menú de nuevo con los cambios.
            clear
            echo -e "Selecciona una carpeta para formatearla \e[1m(Usa las flechas y la tecla 'Enter')\e[0m:\n"

            # Bucle que muestra las opciones para seleccionar.
            for i in "${!carpetasConZips[@]}"
            do
                if [ $i -eq $selected ]
                then
                    echo -e "\e[1;36m${carpetasConZips[i]}\e[0m"
                else
                    echo "${carpetasConZips[i]}"
                fi
            done

            # Aquí se lee la entrada del teclado.
            read -rsn1 key
            if [[ $key == $ESC ]]
            then
                read -rsn2 key

                # En caso de ser la tecla hacia arriba, se seleccionará la opción anterior.
                if [[ $key == "[A" ]]
                then
                    selected=$((selected - 1))

                    # Si estás en la primera opción y pulsas hacia arriba, bajará a la última.
                    if [ $selected -lt 0 ]
                    then
                        selected=$((${#carpetasConZips[@]} - 1))
                    fi

                # En caso de ser la tecla hacia abajo, se seleccionará la opción posterior.
                elif [[ $key == "[B" ]]
                then
                    selected=$((selected + 1))

                    # Al igual que antes, si estás en la última opción y pulsas hacia abajo, subirá a la primera.
                    if [ $selected -ge ${#carpetasConZips[@]} ]
                    then
                        selected=0
                    fi
                fi
            
            # Si se pulsa la tecla 'Enter', se mostrarán todas las opciones y la carpeta seleccionada resaltada.
            elif [[ $key == "" ]]
            then
                clear
                echo -e "Selecciona una carpeta para formatearla \e[1m(Usa las flechas y la tecla 'Enter')\e[0m:\n"
                
                for i in "${!carpetasConZips[@]}"
                do
                    if [ $i -eq $selected ]
                    then
                        echo -e "\e[1;32m${carpetasConZips[i]}\e[0m"
                    else
                        echo "${carpetasConZips[i]}"
                    fi
                done

                echo -e "\nHas seleccionado: \033[1;32m${carpetasConZips[selected]}\033[0m\n"
                formatearUnaCarpetaCodigo "${carpetasConZips[selected]}"
                break
            fi
        done
    else
        clear
        echo -e "Todas las carpetas se formatearán.\n"
        formatearUnaCarpetaCodigo "${carpetasConZips[@]}"
    fi
}

## Método pequeñito que complementa al métdo de formatear una carpeta visual general. Este se encarga de la parte del código.
formatearUnaCarpetaCodigo() {
    
    # Método que comprueba si existe o no la carpeta de respuestas.
    comprobarCarpetaRespuestas

    # Variable que guarda todas las carpetas con zips que se le pasan como parámetro.
    carpetas=("$@")

    echo -e "Formateando la/s carpeta/s:"

    for carpeta in "${carpetas[@]}"
    do
        echo -e "  \e[1;36m- $carpeta\e[0m"
        accesoCarpetaParámetro "$carpeta"
    done

    tput cup 31 0
    read -n1 -p "Pulsa cualquier tecla para continuar: "
    clear
}

## Método que complementa al método general. Este pasa como parámetro todas las carpetas con zips para formatearlas.
formatearTodasLasCarpetas() {
    formatearUnaCarpetaVisual "${carpetasConZips[@]}"
}

## Método encargado de comprobar la carpeta de respuestas.
comprobarCarpetaRespuestas() {
    
    # Comprueba si existe o no la carpeta de respuestas. Si no existe la crea.
    if [ ! -d "Respuestas" ]
    then
        mkdir Respuestas
        mkdir Respuestas/CarpetasDescomprimidas
        mkdir Respuestas/Resultados
    fi
}

## Método que accede a la carpeta pasada como parámetro, descomprime cada zip, accede a la dicha carpeta y formatea los archivos.
accesoCarpetaParámetro() {
    
    # Variable que guarda la carpeta pasada como parámetro.
    carpeta="$1"

    # Se crea la carpeta del alumno en el directorio de respuestas en caso de que no exista.
    if [ ! -d "Respuestas/Resultados/$carpeta" ]
    then
        mkdir "Respuestas/Resultados/$carpeta"
    fi

    # Bucle que recorre los zips de la carpeta y los descomprime.
    for zip in "$carpeta"/*.zip
    do
        # Extrae los zips en la carpeta de respuestas sin mostrar nada por pantalla.
        unzip -o "$zip" -d "Respuestas/CarpetasDescomprimidas/$carpeta/" > /dev/null 2>&1
    done

    # Bucle que recorre los archivos de la carpeta y los formatea.
    for carpetaAlumno in "Respuestas/CarpetasDescomprimidas/$carpeta"/*
    do
        if [ -d "$carpetaAlumno" ]
        then
            # Se obtiene el nombre del alumno.
            nombreCompletoAlumnoRAW=$(basename "$carpetaAlumno")
            nombreAlumno=$(echo "${nombreCompletoAlumnoRAW^}" | cut -d "_" -f 1)
            apellidoAlumno=$(echo "${nombreCompletoAlumnoRAW^}" | cut -d "_" -f 2)
            
            # Creación de archivo Markdown para cada alumno en la ruta especificada.
            markdownFile="Respuestas/Resultados/$carpeta/$nombreCompletoAlumnoRAW.md"
            echo "# Scripts de $nombreAlumno $apellidoAlumno." > "$markdownFile"

            # Bucle que recorre los archivos de la carpeta del alumno y añade al markdown.
            for archivo in $(ls "$carpetaAlumno" | sort -V)
            do
                archivoCompleto="$carpetaAlumno/$archivo"

                if [ -s "$archivoCompleto" ]
                then
                    echo -e "\n## $archivo" >> "$markdownFile"
                    echo -e "\n\`\`\`bash" >> "$markdownFile"
                    cat "$archivoCompleto" >> "$markdownFile"
                    echo -e "\n\`\`\`" >> "$markdownFile"
                else
                    echo -e "\n## $archivo" >> "$markdownFile"
                    echo "**¡SCRIPT NO REALIZADO!**" >> "$markdownFile"
                fi
            done
        fi
    done
}


############ Inicio del programa ############

# Limpia la pantalla y saluda al usuario.
clear
echo -e "¡Saludos \e[1;36m$(echo $USER | tr a-z A-Z)\e[0m! Estás ejecutando el script formateador de scripts.\n"

# El programa se ejecutará infinitamente hasta que el usuario salga de este.
while true
do
    mostrarCarpetasYContenido
    opcionSeleccionadaUsuario
done
