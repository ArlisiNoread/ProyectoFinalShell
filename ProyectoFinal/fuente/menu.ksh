#!/bin/ksh

#(cd ./BaseDeDatos/ ; ./databaseManager.ksh -t usuarios)
#print "$(./databaseManager.ksh -t 'usuarios')"

################################################
#     Nomas ando probando las librerías        #
################################################
#export FPATH="$(pwd)/../lib"
#autoload imprimirHola
#imprimirHola
################################################
# A no ma si funciona                          #
# Reglas para las librerías:                   #
# El archivo debe llamarse igual a la función. #
# No se porqué, si no no lo detecta            #
################################################

# Función para mostrar las opciones del menu principal
mostrarMenu() {
	echo Menu Principal
	echo 1. Detalles de articulos
	echo 2. Detalles de clientes
	echo 3. Detalles de insumos
	echo 4. Ventas
	echo 5. Ventas de producto
	echo 6. Salir
	echo -n "Selecciona una opción: "
	read opcion
}

# Menu principal
while true; do
	mostrarMenu

	case $opcion in
	1)
		source ./Scripts/Articulos.ksh
		;;
	2)
		source ./Scripts/Clientes.ksh
		;;
	3)
		source ./Scripts/Insumos.ksh
		;;
	4)
		source ./Scripts/Ventas.ksh
		;;
	5)
		source ./Scripts/Ventas_Productos.ksh
		;;
	6)
		clear
		exit
		;;
	*)
		tput setaf 1
		print "\nIngresa una opción valida\n"
		tput sgr0
		;;

	esac
done
