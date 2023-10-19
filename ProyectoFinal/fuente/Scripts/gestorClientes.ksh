#!/bin/ksh

# Nombre de script: gestorClientes.ksh
# Descripcion:
# 	
#	Script encargado de realizar operaciones que tienen que ver con altas, bajas, actualizaciones 
#	de la tabla "Clientes" de la base de datos.

# Menu principal 

if [ "$0" =~ ^*gestorClientes.ksh$ ]; then
    libreriaDesdeScript=true
    export FPATH="$(pwd)/../../lib"
    autoload easyTput
    autoload bd
    autoload log
fi



# Menu principal 

while true; do
    easyTput colortexto verde
    printf "\n\n\t===================  MU & ME ====================\n"
    easyTput reset
    printf "\n\t                 Gestor de clientes  		 \n"
    easyTput colortexto verde
    printf "\n\n\t=================================================\n"
    easyTput reset
    printf "\n\n\n"


	printf "\t 1. Agregar una cliente \n"
	printf "\t 2. Visualizar todos los clientes   \n"
	printf "\t 3. Borrar un cliente \n"
	printf "\t 4. Volver al menu principal \n"
	printf "\t ======================\n"
	printf "\t\n"
   	print -n "Seleccione una opción:"
   	read opcion

	case $opcion in
		1)
                # punto de venta y agrenado ventas a clientes
				#print -n "\t Digite el ID del cliente: "
				#read id
				print -n "\t Nombre : "
				read nombre
				print -n "\t Telfono: "
				read telefono
				print -n "\t Direccion: "
				read dir
				respuesta="$(bd -a clientes:"$nombre":"$telefono":"$dir")"
				easyTput colortexto rojo
                print "\n\t Numero de cliente: $respuesta"
                easyTput reset

        ;;

		2)
            easyTput colortexto verde
			print -n "\t Todas las ventas\n"
			easyTput reset
			easyTput colortexto rojo
			clientes="$(bd -t "clientes")"
			print "$clientes" | sed -e 's/:/\t/g' -e '1,$s/^/\t/g'
			easyTput reset
		;;

	
	   	3)	
            easyTput colortexto verde
			print -n "\t Ingresa el id del cliente a borrar: "
			easyTput reset
			read rcliente
			print "\t $(bd -r "clientes:$rcliente")"
            easyTput colortexto rojo
            print "\t Cliente borrado"
            easyTput reset
		   ;;
		4)
            break
            ;;
	   	*)
		   	
		   	easyTput colortexto rojo
		    print "\t Ingresa una opción valida\n"
		    easyTput reset
		   	
		   ;;
	esac
done
