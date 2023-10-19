#!/bin/ksh

# Nombre de script: gestorVentas.ksh
# Descripcion:
# 	
#	Script encargado de realizar operaciones que tienen que ver con altas, bajas, actualizaciones 
#	de la tabla "Ventas" de la base de datos.


if [ "$0" =~ ^*gestorVentas.ksh$ ]; then
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
    printf "\n\t                 Gestor de ventas  		 \n"
    easyTput colortexto verde
    printf "\n\n\t=================================================\n"
    easyTput reset
    printf "\n\n\n"


	printf "\t 1. Agregar una venta \n"
	printf "\t 2. Consultar informacion de una venta \n"
	printf "\t 3. Visualizar todas las  ventas \n"
	printf "\t 4. Borrar una venta \n"
	printf "\t 5. Volver al menu principal \n"
	printf "\t ======================\n"
	printf "\t\n"
   	print -n "Seleccione una opción:"
   	read opcion

	case $opcion in
		1)
                # punto de venta y agrenado ventas a clientes
				print -n "\t Digite el ID del cliente que se le  agregara la venta: "
				read id
				print -n "\t Nombre producto: "
				read nombre
				print -n "\t Cantidad: "
				read cantidad
				print -n "\t Precio: "
				read precio
				respuesta="$(bd -a ventas:"$id")"
				easyTput colortexto rojo
                print "\n\t Numero de venta: $respuesta"
                easyTput reset

        ;;

	  	2)
            easyTput colortexto verde
			print -n "\t Ingresa el ID de la venta a buscar: "
			read venta
			easyTput reset
			easyTput colortexto rojo
			venta="$(bd -g "ventas:$venta")"
            print "\t $venta:" |  sed 's/:/\t/g'
			easyTput reset
		;;

		3)
            easyTput colortexto verde
			print -n "\t Todas las ventas\n"
			easyTput reset
			easyTput colortexto rojo
			venta="$(bd -t "ventas")"
			print "$venta" | sed -e 's/:/\t/g' -e '1,$s/^/\t/g'
			easyTput reset
		;;

	
	   	4)	
            easyTput colortexto verde
			print -n "\t Ingresa el id de la venta a borrar: "
			easyTput reset
			read rventa
			print "\t $(bd -r "ventas:$rventa")"
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

