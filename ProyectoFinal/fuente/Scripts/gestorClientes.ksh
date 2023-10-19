#!/bin/ksh

# Nombre de script: gestorProductos.ksh
# Descripcion:
# 	
#	Script encargado de realizar operaciones que tienen que ver con altas, bajas, actualizaciones 
#	de la tabla "Productos" de la base de datos.

# Menu principal 

if [ "$0" =~ ^*gestorClientes.ksh$ ]; then
    libreriaDesdeScript=true
    export FPATH="$(pwd)/../../lib"
    autoload easyTput
    autoload bd
fi

function getUsuario {
	typeset nombre="$1"
	consulta="$(cd .. ; cd ./BaseDeDatos/ ; ksh ./databaseManager.ksh -g usuarios:"$nombre")"
  	echo "$consulta"
}

function getAllUsuario {
	consulta="$(cd .. ; cd ./BaseDeDatos/ ; ksh ./databaseManager.ksh -t usuarios)"
  	echo "$consulta"
}

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
				
				printf "\t ======================\n"
				printf "\t Presione 1 para salir \n"
				printf "\t Presione 0 para seguir agregando\n"
				print -n "Digite una opcion: "
				read op
			done
			clear
			op=0
		   ;;
	  	2)
			while ((op != 1 )); do
				print -n "Ingrese el id del usuario a desplegar la informacion: "
				read nombre_usuario	
				#consulta="$(cd .. ; cd ./BaseDeDatos/ ; ksh ./databaseManager.ksh -g usuarios:"$nombre_usuario")"
				
				consultaUsuario="$(getUsuario "$nombre_usuario")"
				
				
				if [[ -z "$consultaUsuario" ]]; then
					echo "Usuario no encontrado."
				else
 					echo "Usuario encontrado: "	
					print "$consultaUsuario"
					echo  "$consultaUsuario" | awk 'BEGIN {FS=":"} {printf "%-15s %-20s %-20s\n", "id usuario", "nombre de usuario", "nivel", "---", "---", "---";
				       					      printf "%-15s %-20s %-20s\n", "-------", "-------------", "--------";
								              printf "%-15s %-20s %-20s\n", $1, $2, $4}'	

					#id_usuario=$(echo "$consultaUsuario" | sed 's/:/ /' | awk '{print $1}')
					
					#nombre_usuario=$(echo "$consultaUsuario" | sed 's/:/ /' | awk '{print $2}')
					#nivel1=$(echo "$consultaUsuario" | sed 's/:/ /' | awk '{print $3}')
					#nivel2=$(echo "$consultaUsuario" | sed 's/:/ /' | awk '{print $4}')


					printf "\n\n"
					printf "%-15s %-20s %-20s\n" "Name" "Age" "Site" "----" "---" "----"
					printf "\033[35m"
					printf "%-15s %-20s %-20s\n" "Bob Actor" "30" "Orange County"
					printf "\033[36m"
					printf "%-15s %-20s %-20s\n" "Bob Actor" "300000" "Orange County"
					printf "\033[35m"
					printf "%-15s %-20s %-20s\n" "Bob Actor" "30" "Orange County"
					printf "\033[36m"
					printf "%-15s %-20s %-20s\n" "Bob Actor" "30" "Orange County"
					printf "\033[35m"
					printf "%-15s %-20s %-20s\n" "Bob Actor" "30" "Orange County"
					printf "\033[0m"
				fi
				printf "\t ======================\n"
				printf "\t Presione 1 para salir \n"
				printf "\t Presione 0 para seguir consultando\n"
				print -n "Digite una opcion: "
				read op
			done
		   ;;
	  	3)	

			while ((op != 1 )); do

				consultaUsuario="$(getAllUsuario)"


				if [[ -z "$consultaUsuario" ]]; then
					echo "El usuario no existe."
				else
					#echo "Usuario encontrado."	
					#print "$consultaUsuario"
					printf "\t %-5s %-15s %-20s %-20s\n" "     " "id usuario" "nombre de usuario" "nivel" "     " "-------" "-------------" "--------"
					echo  "$consultaUsuario" | awk 'BEGIN {FS=":"} 
					{
					
					printf "\t %-5s %-15-s %-20s %-20s\n", " + ", $1, $2, $4}'	

					#id_usuario=$(echo "$consultaUsuario" | sed 's/:/ /' | awk '{print $1}')

					#nombre_usuario=$(echo "$consultaUsuario" | sed 's/:/ /' | awk '{print $2}')
					#nivel1=$(echo "$consultaUsuario" | sed 's/:/ /' | awk '{print $3}')
					#nivel2=$(echo "$consultaUsuario" | sed 's/:/ /' | awk '{print $4}')


				#	printf "\n\n"
				#	printf "%-15s %-20s %-20s\n" "Name" "Age" "Site" "----" "---" "----"
				#	printf "\033[35m"
				#	printf "%-15s %-20s %-20s\n" "Bob Actor" "30" "Orange County"
				#	printf "\033[36m"
				#	printf "%-15s %-20s %-20s\n" "Bob Actor" "300000" "Orange County"
				#	printf "\033[35m"
				#	printf "%-15s %-20s %-20s\n" "Bob Actor" "30" "Orange County"
				#	printf "\033[36m"
				#	printf "%-15s %-20s %-20s\n" "Bob Actor" "30" "Orange County"
				#	printf "\033[35m"
				#	printf "%-15s %-20s %-20s\n" "Bob Actor" "30" "Orange County"
				#	printf "\033[0m"
				fi
				printf "\t ======================\n"
				printf "\t Presione 1 para salir \n"
				printf "\t Presione 0 para seguir consultando\n"
				print -n "Digite una opcion: "
				read op
			done
			;;
	   	4)	clear
			source ./menu.ksh
		   ;;
	   	*)
		   	echo "Opción no válida. Intente de nuevo."
		   	read -p "Presione Enter para continuar..."
		   ;;
	esac
done

