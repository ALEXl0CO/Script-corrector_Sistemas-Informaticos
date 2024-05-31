#/bin/bash

############ Menús dinámicos ############

# Variable para comprobar si el menú es de tamaño inferior.
opSeleccionada=0
# Variable global que almacenará todas las carpetas con zips.
carpetasConZips=()

## Método que muestra el menú para formatear una clase.
menuOpcionUnaClase() {

    echo -e "\n\n\e[1m¿Qué quieres hacer?\e[0m\n"
    echo "  1. Formatear clase"
    echo "  2. Salir"

    opSeleccionada=1
}

## Método que muestra el menú completo.
menuCompleto() {

    # Todas las opciones del menú.
    opciones=("Elegir una clase" "Todas las clases" "Salir")
    contador=0

    echo -e "\n\n\e[1m¿Qué quieres hacer?\e[0m\n"
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

    # Switch de las opciones.
    case $seleccion in
        1)
            formatearUnaCarpeta
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
    
    # Comprueba si hay carpetas en el directorio actual.
    cantidadDirectorios=$(find -type d | cut -d "/" -f "2" | uniq | sort -n | tail -n +2 | wc -l)

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
            if [ -d "$carpeta" ]
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

        # Aquí se comprueba si todas las carpetas contienen archivos .zip o no y llama al método correspondiente. 
        if [ $directoriosConZips -eq $cantidadDirectorios ]
        then
            menuCompleto
        elif [ $directoriosConZips -eq 0 ]
        then
            echo -e "\nLas carpetas están vacías, añade .zips para poder formatear."
            exit 0
        else
            menuOpcionUnaClase
        fi
    fi
}


## Por implementar.
formatearUnaCarpeta() {
    clear
}

## Por implementar.
formatearTodasLasCarpetas() {
    clear
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