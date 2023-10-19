#!/bin/ksh

# Nombre de script: gestorProductos.ksh
# Descripcion:
# 	
#	Script encargado de realizar operaciones que tienen que ver con altas, bajas, actualizaciones 
#	de la tabla "Productos" de la base de datos.

# Menu principal 

if [ "$0" =~ ^*gestorProductos.ksh$ ]; then
    libreriaDesdeScript=true
    export FPATH="$(pwd)/../../lib"
    autoload easyTput
    autoload bd
    autoload log
fi

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
	printf "\t\n"
   	print -n "Seleccione una opción:"
   	read opcion

	case $opcion in
		1)
                # 
                print -n "Nombre del producto: "
				read nombre_producto
				print -n "Precio: "
				read precio_producto
				print -n "Cantidad: "
				read cantidad_producto	

#			-a productos:"$nombre_producto":"$precio_producto":"$cantidad_producto"
				respuesta="$(bd -a productos:"$nombre_producto":"$precio_producto":"$cantidad_producto")"
				easyTput colortexto rojo
                print "\n\t Numero de producto: $respuesta"
                easyTput reset

        ;;

	  	2)
            easyTput colortexto verde
			print -n "\t Ingresa el ID del producto a buscar: "
			read prod
			easyTput reset
			easyTput colortexto rojo
			venta="$(bd -g "productos:$prod")"
            print "\t $venta:" |  sed 's/:/\t/g'
			easyTput reset
		;;

		3)
            easyTput colortexto verde
			print -n "\t Todos los productos\n"
			easyTput reset
			easyTput colortexto rojo
			venta="$(bd -t "productos")"
			print "$venta" | sed -e 's/:/\t/g' -e '1,$s/^/\t/g'
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

