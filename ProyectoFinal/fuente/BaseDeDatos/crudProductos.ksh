#!/bin/ksh
#
# Script con las definiciones básicas de
# crud para la base de datos de artículos.
#
# Banderas:
# -a: add -> -a "id:nombre:costo:almacen"
# -g: get -> -g "por ver"
# -u: update -> -u "por ver"
# -r: remove -> -r "por ver"
# -c: checar salud del archivo.

readonly nombreArchivo="Productos.txt"

function agregar {
	#to do
	print ""
}

function checkProductoLine {

	if [[ "$1" =~ ^[^:]+:[^:]+:[^:]+:[^:]+$ ]]; then
		#Formato id:nombre:costo:cantidadEnAlmacen
		id="$(echo "$1" | awk -F: '{print $1}')"
		cantidadEnAlmacen="$(echo "$1" | awk -F: '{print $4}')"
	elif [[ "$1" =~ ^[^:]+:[^:]+:[^:]+$ ]]; then
		#Formato nombre:costo:cantidadEnAlmacen
		id=0
		cantidadEnAlmacen="$(echo "$1" | awk -F: '{print $3}')"
	else
		print "Un producto debe ser del tipo id?:nombre:costo:cantidadEnAlmacen" >&2
		return 1
	fi

	if [[ ! "$id" =~ ^\d+$ ]]; then
		print "El id debe ser un número natural." >&2
		return 1
	fi

	if [[ ! "$cantidadEnAlmacen" =~ ^\d+$ ]]; then
		print "La cantidad en almacén debe ser un número natural." >&2
		return 1
	fi
}

function checkFile {
	./checkeoGeneralDeArchivo.ksh "$nombreArchivo"
	if [[ ! $? ]]; then
		print "$?"
		#exit
	fi

	# Todas las lineas de la base de datos deben tener este patrón
	# id:nombre:costo:cantidadEnAlmacén
	# comprobadorDeLineas="$(sed -n '/^[^:]*:[^:]*:[^:]*:[^:]*$/!p' $nombreArchivo)"

	if [[ -n "$comprobadorDeLineas" ]]; then
		print "Archivo $nombreArchivo corrupto."
		print "$comprobadorDeLineas"
		exit 1
	fi

	cnt=0
	while read line; do
		((cnt++))
		checkProductoLine
	done <"$nombreArchivo"

}

while getopts a:g:u:r:cn: o; do
	case "$o" in
	a)
		aFlag=true
		aFlagArg="$OPTARG"
		;;
	g)
		print "get"
		# paste=hpaste
		;;
	u)
		print "update"
		;;
	r)
		print "remove"
		;;
	c)
		cFlag=true
		;;
	n)
		nFlag=true
		nFlagArg="$OPTARG"
		;;
	[?])
		print >&2 "Error Usage: $0 [-s] [-d seplist] file ..."
		exit 1
		;;
	esac
done
shift $OPTIND-1

if [[ $cFlag ]]; then
	checkFile
fi
if [[ $aFlag ]]; then
	print "a"
fi
if [[ $nFlag ]]; then
	checkProductoLine "$nFlagArg"
fi
