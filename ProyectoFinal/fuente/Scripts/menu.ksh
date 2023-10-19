#!/bin/ksh

nivelUsuario="$(print "$usuario" | awk -F: '{print $2}')"

clear

if [ "$0" =~ ^*menu.ksh$ ]; then
	libreriaDesdeScript=true
	export FPATH="$(pwd)/../../lib"
	autoload easyTput
	autoload bd
	autoload log
fi

# Función para mostrar las opciones del menu principal
mostrarMenu() {
	echo Menu Principal
	echo 1. Gestor de Ventas
	echo 2. Gestor de Clientes
	if ((nivelUsuario == 2)); then
		echo 3. Gestor Producto
		echo 4. Gestor de Usuarios
		echo 5. Salir
	else
		echo 3. Salir
	fi

	echo -n "Selecciona una opción: "
	read opcion

}

#mostrarMenu

# Menu principal
while true; do
	mostrarMenu
	if ((nivelUsuario == 2)); then
		case $opcion in
		1)
			source ./Scripts/gestorVentas.ksh
			;;
		2)
			source ./Scripts/gestorClientes.ksh
			;;
		3)
			source ./Scripts/gestorProductos.ksh
			;;
		4)
			source ./Scripts/gestorUsuarios.ksh
			;;
		5)
			clear
			exit
			;;
		*)
			tput setaf 1
			print "\nIngresa una opción valida\n"
			tput sgr0
			;;
		esac
	else
		case $opcion in
		1)
			source ./Scripts/gestorVentas.ksh
			;;
		2)
			source ./Scripts/gestorClientes.ksh
			;;
		3)
			clear
			exit
			;;
		*)
			tput setaf 1
			print "\nIngresa una opción valida\n"
			tput sgr0
			;;
		esac
	fi

done
