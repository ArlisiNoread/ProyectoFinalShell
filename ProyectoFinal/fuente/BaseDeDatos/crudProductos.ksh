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
	
}


function checkFile {
	./checkeoGeneralDeArchivo.ksh "$nombreArchivo"
	if [[ ! $? ]]; then
		print "$?"
		#exit
	fi

	# Todas las lineas de la base de datos deben tener este patrón
	# id:nombre:costo:cantidadEnAlmacén
	# honestamente luego le creo uno de awk que verifique los números....
	comprobadorDeLineas="$(sed -n '/^[^:]*:[^:]*:[^:]*:[^:]*$/!p' $nombreArchivo)"

	if [[ -n "$comprobadorDeLineas" ]]; then
		print "Archivo $nombreArchivo corrupto."
		print "$comprobadorDeLineas"
		exit 1
	fi

}

while getopts a:g:u:r:c o; do
	case "$o" in
	a)
		aFlag=true
		valorNuevo="$OPTARG"
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

fi