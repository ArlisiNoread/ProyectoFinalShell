#!/bin/ksh

# Nombre de script: gestorUsuarios.ksh
# Descripción:
#    
#       Script encargado de realizar operaciones que tiene que ver con altas, bajas, actualizaciones
#       de la tabla de "Usuarios" de la base de datos.
#
#export FPATH="$(pwd)/../../lib"
#autoload easyTput

# Menu principal


while true; do
	easyTput colortexto verde
	printf "\n\n\t===================  MU & ME ====================\n"
	easyTput reset
	easyTput subrayado
	printf "\n\t                 Gestor de usuarios  		 \n"
	easyTput reset
	easyTput colortexto verde
	printf "\n\n\t=================================================\n"
	easyTput reset
	printf "\n\n\n"


	printf "\t 1. Dar de alta un usuario \n"
	printf "\t 2. Consultar datos de un usuario \n"
	printf "\t 3. Visualizar todos los usuarios \n"
	printf "\t 4. Remover un usuario \n"
	printf "\t 5. Volver al menu principal \n"
	printf "\t ================================\n"
	printf "\t\n"
   	print -n "\t Seleccione una opción:"
   	read opcion

	case $opcion in
		1)
			print -n "\t Nombre: "
		        read nombre
	                print -n "\t Contraseña: "
	                read password
	                print -n "\t Nivel: "
	                read nivel
			#cd ../BaseDeDatos/
			#./databaseManager.ksh -a usuarios:$nombre:$password:$nivel
			bd -a usuarios:$nombre:$password:$nivel		
			easyTput colortexto rojo
		        print "\tUsuario agregado"
			easyTput reset
		   ;;
	  	2)
		   ;;
	  	3)
		   ;;
		4)
		   ;;
		5)
			source ./menu.ksh
			;;
	   	*)
		   	echo "Opción no válida. Intente de nuevo."
		   	read -p "Presione Enter para continuar..."
		   ;;
	esac
done

