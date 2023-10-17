#!/bin/ksh
# Nombre script: punto_de_venta.ksh
# Descripcion:
# 	  
#	Este script es el encargado mandar las ordenes de altas, bajas, actualizar y de consultar
#	en la base de datos del sistema, asi como de brindar un acceso simplificado a la informacion
#	que se presenta.


# Menú principal
while true; do
	printf "\n\n\t\t============ Control de Punto de Venta ==========\n"
	printf "\n\t\t                      MU & ME  		         \n"
	printf "\n\n\t\t=================================================\n"
	printf "\n\n\n"


	printf "\t 1. Gestor de productos \n"
	printf "\t 2. Mostrar total \n"
	printf "\t 3. Salir \n"
	printf "\t ======================\n"
	printf "\t Total: \$$total \n"
	printf "\t Productos: $productos \n"
	printf "\t ====================== \n"

	printf "\t\n"
   	print -n "Seleccione una opción:"
   	read opcion

	case $opcion in
		1)	
		   source ./gestorProductos.ksh
		   ;;
	  	2)
		   ;;
	  	3)
		   echo "Gracias por su compra. Hasta luego."
		   exit 0
		   ;;
	   	*)
		   echo "Opción no válida. Intente de nuevo."
		   read -p "Presione Enter para continuar..."
		   ;;
	esac
done








