#!/bin/ksh

# Nombre de script: gestorProductos.ksh
# Descripcion:
# 	
#	Script encargado de realizar operaciones que tienen que ver con altas, bajas, actualizaciones 
#	de la tabla "Productos" de la base de datos.

# Menu principal 

while true; do
	printf "\n\n\t\t===================  MU & ME ====================\n"
	printf "\n\t\t                 Gestor de productos  		 \n"
	printf "\n\n\t\t=================================================\n"
	printf "\n\n\n"


	printf "\t 1. Dar de alta un producto \n"
	printf "\t 2. Consultar un producto \n"
	printf "\t 3. Visualizar los productos \n"
	printf "\t 4. Volver al menu principal \n"
	printf "\t ======================\n"
	printf "\t Total: \$$total \n"
	printf "\t Productos: $productos \n"
	printf "\t ====================== \n"

	printf "\t\n"
   	print -n "Seleccione una opción:"
   	read opcion

	case $opcion in
		1)
			while ((op != 1 )); do
				print -n "Nombre del producto: "
				read nombre_producto
				print -n "Precio: "
				read precio_producto
				print -n "Cantidad: "
				read cantidad_producto
				
				#source ../BaseDeDatos/databaseManager.ksh -a productos:"$nombre_producto":"$precio_producto":"$cantidad_producto"
				
				#(cd .. ; cd ./BaseDeDatos/ ; ksh ./databaseManager.ksh -a productos:"$nombre_producto":"$precio_producto":"$cantidad_producto")
				(cd .. ; cd ./BaseDeDatos/ ; ksh ./databaseManager.ksh -a productos:"$nombre_producto":"$precio_producto":"$cantidad_producto")
		
				#if (($? != 0)); then
				#	print "$respuesta"
				#fi
				#if (("$insertar" != 0 )); then
				#	print "Se ha realizado la insercion"
				#	print "$insertar"
				#else
				#	print "NO se ha realizado la insercion"
				#fi
				print "Presione 1 para salir "
				print "Presione 0 para seguir agregando"
				print -n "Digite una opcion: "
				read op
			done
			clear
			op=0
		   ;;
	  	2)
		   ;;
	  	3)
		   ;;
	   	4)	clear
			source ./punto_de_venta.ksh	
		   ;;
	   	*)
		   	echo "Opción no válida. Intente de nuevo."
		   	read -p "Presione Enter para continuar..."
		   ;;
	esac
done

