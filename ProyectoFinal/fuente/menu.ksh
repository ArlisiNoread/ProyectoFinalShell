#!/bin/ksh
clear
#(cd ./BaseDeDatos/ ; ./databaseManager.ksh -t usuarios)
#print "$(./databaseManager.ksh -t 'usuarios')"

################################################
#     Nomas ando probando las librerías        #
################################################
export FPATH="$(pwd)/../lib"
autoload imprimirHola
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
	echo 1. Gestor Producto
	echo 2. Gestor de Clientes
	echo 3. Gestor de Ventas
	echo 4. Gestor de Ventas de producto
	echo 5. Gestor de Usuarios
	echo 6. Salir
	echo -n "Selecciona una opción: "
        read opcion
	#printf "\n\n"
	#printf "%-15s %-20s %-20s\n" "Name" "Age" "Site" "----" "---" "----"
	#printf "\033[35m"
	#printf "%-15s %-20s %-20s\n" "Bob Actor" "30" "Orange County"
	#printf "\033[36m"
	#printf "%-15s %-20s %-20s\n" "Bob Actor" "300000" "Orange County"
	#printf "\033[35m"
	#printf "%-15s %-20s %-20s\n" "Bob Actor" "30" "Orange County"
	#printf "\033[36m"
	#printf "%-15s %-20s %-20s\n" "Bob Actor" "30" "Orange County"
	#printf "\033[35m"
	#printf "%-15s %-20s %-20s\n" "Bob Actor" "30" "Orange County"

	
}



#mostrarMenu

# Menu principal
while true; do
	mostrarMenu

	case $opcion in
	1)
		source ./Scripts/gestorProductos.ksh
		;;
	2)
		source ./Scripts/gestorClientes.ksh
		;;
	3)
		source ./Scripts/gestorVentas.ksh
		;;
	4)
		source ./Scripts/gestorVentasProductos.ksh
		;;
	5)
		source ./Scripts/gestorUsuarios.ksh
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
