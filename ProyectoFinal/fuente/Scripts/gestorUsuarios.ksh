#!/bin/ksh

# Nombre de script: gestorUsuarios.ksh
# Descripción:
#    
#       Script encargado de realizar operaciones que tiene que ver con altas, bajas, actualizaciones
#       de la tabla de "Usuarios" de la base de datos.
#

if [ "$0" =~ ^*gestorUsuarios.ksh$ ]; then
    libreriaDesdeScript=true
    export FPATH="$(pwd)/../../lib"
    autoload easyTput
    autoload bd
fi


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
			cd ../BaseDeDatos/
			./databaseManager.ksh -a usuarios:$nombre:$password:$nivel
			#bd -a usuarios:$nombre:$password:$nivel		
			easyTput colortexto rojo
		        print "\t Usuario agregado"
			easyTput reset
		   ;;
	  	2)
			print -n "\t Ingresa el nombre del usuario a buscar: "
			read snombre
                        cd ../BaseDeDatos/
                        ./databaseManager.ksh -g usuarios:$snombre
			#bd -a usuarios:$nombre:$password:$nivel		
		   ;;
	  	3)
			print -n "\t Todos los usuarios\n"
			cd ../BaseDeDatos/
			./databaseManager.ksh -t usuarios
			#bd -t usuarios
		   ;;
		4)
			print -n "\t Ingresa el nombre del usuario a borrar: "
			read rnombre
			cd ../BaseDeDatos/
			./databaseManager.ksh -r usuarios:$rnombre
			#bd -r usuarios:$rnombre
	                easyTput colortexto rojo
			print "\t Usuario borrado"
                        easyTput reset		
		   ;;

		5) 
			source ./menu.ksh
			break
			;;
	   	*)
		   	echo "Opción no válida. Intente de nuevo."
		   	read -p "Presione Enter para continuar..."
		   ;;
	esac
done

