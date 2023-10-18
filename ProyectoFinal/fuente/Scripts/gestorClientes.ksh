#!/bin/ksh

# Nombre de script: gestorProductos.ksh
# Descripcion:
# 	
#	Script encargado de realizar operaciones que tienen que ver con altas, bajas, actualizaciones 
#	de la tabla "Productos" de la base de datos.

# Menu principal 

while true; do
	printf "\n\n\t\t===================  MU & ME ====================\n"
	printf "\n\t\t                 Gestor de Usuarios  		 \n"
	printf "\n\n\t\t=================================================\n"
	printf "\n\n\n"


	printf "\t 1. Dar de alta un usuario \n"
	printf "\t 2. Consultar informacion de un usuario \n"
	printf "\t 3. Visualizar los usuarios \n"
	printf "\t 4. Volver al menu principal \n"
	printf "\t ======================\n"

	printf "\t\n"
   	print -n "Seleccione una opción:"
   	read opcion

	case $opcion in
		1)
			while ((op != 1 )); do
				print -n "Nombre del usuario: "
				read nombre_usuario
				print -n "Contraseña: "
				read password_usuario
				print -n "Nivel de usuario: "
				read nivel_usuario			
				(cd .. ; cd ./BaseDeDatos/ ; ksh ./databaseManager.ksh -a usuarios:"$nombre_usuario":"$password_usuario":"$nivel_usuario")
				print "$?"
				print "Presione 1 para salir "
				print "Presione 0 para seguir agregando"
				print -n "Digite una opcion: "
				read op
			done
			clear
			op=0
		   ;;
	  	2)
		#	while ((op != 1 )); do
				
		#	done
		   ;;
	  	3)
		   ;;
	   	4)	clear
			source ./punto_de_venta.ksh	
			op=0
		   ;;
	   	*)
		   	echo "Opción no válida. Intente de nuevo."
		   	read -p "Presione Enter para continuar..."
		   ;;
	esac
done

