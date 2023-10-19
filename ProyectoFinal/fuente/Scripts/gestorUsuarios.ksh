#!/bin/ksh

# Nombre de script: gestorUsuarios.ksh
# Descripción:
#
#       Script encargado de realizar operaciones que tiene que ver con altas, bajas, actualizaciones
#       de la tabla de "Usuarios" de la base de datos.
#

if [ "$0" =~ ^*gestorUsuarios.ksh$ ]; then
    print "AAAAAAAA"
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
    printf "\n\t                 Gestor de usuarios  		 \n"
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
			
			respuesta="$(bd -a "usuarios:$nombre:$password:$nivel")"
			
			if(($? != 0)); then
				easyTput colortexto rojo
				print "\n\t$repuesta"
				easyTput reset
			else 
				easyTput colortexto rojo
				print "\t Usario agregado"
				easyTput reset
			fi	
		   ;;
	  	2)
            easyTput colortexto verde
			print -n "\t Ingresa el nombre del usuario a buscar: "
			read snombre
			easyTput reset
			easyTput colortexto rojo
			usuario="$(bd -g "usuarios:$snombre")"
            print "\t $usuario" |  sed 's/:/\t/g'
			easyTput reset
		   ;;
	  	3)
            easyTput colortexto verde
			print -n "\t Todos los usuarios\n"
			easyTput reset
			lista="$(bd -t "usuarios")"
		    print "$lista" | sed -e 's/:/\t/g' -e '1,$s/^/\t/g'
		   ;;
		4)
            easyTput colortexto verde
			print -n "\t Ingresa el nombre del usuario a borrar: "
			easyTput reset
			read rnombre
			print "\t $(bd -r "usuarios:$rnombre")"
            easyTput colortexto rojo
            print "\t Usuario borrado"
            easyTput reset
		   ;;

		5) 
			break
			;;
	   	*)
		   	easyTput colortexto rojo
		    print "\t Ingresa una opción valida\n"
		    easyTput reset
		;;
	esac
done

