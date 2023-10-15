#!/bin/ksh

# Inicialización de variables

# Función para mostrar las opciones del menu principal
mostrarMenu(){
	echo Menu Principal
	echo 1. Detalles de articulos
	echo 2. Detalles de clientes
	echo 3. Detalles de insumos
	echo 4. Salir 
        echo -n "Selecciona una opción: "
        read opcion	
}


# Menu principal

#integer opcion=0
integer maximaOpcion=4
while true; do 
	mostrarMenu
        #read opcion

	case $opcion in 
		1)
	            source ./Detalles_Articulos.ksh
                    ;;
	        2)
		    source ./Detalles_Clientes.ksh
		    ;;
		3)
		    source ./Detalles_Insumos.ksh
		    ;;
	        *) 
		    echo saliendo
		    exit 
		    ;;

	esac
done

