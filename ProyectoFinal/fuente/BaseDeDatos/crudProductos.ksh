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
	producto="$1"
	
	if [[ ! "$producto" =~ ^[^:]+:[^:]+:[^:]+$ ]]; then
			print "El producto debe ser del tipo nombre:costo:cantidadEnAlmacen \n"
			return 1
	fi 

	respuestaAnalisis=$(checkProductoLine "$producto")

	if (($? != 0)); then
		print "$respuestaAnalisis"
		return 1
	fi

	if [[ ! -s "$nombreArchivo" ]]; then
		printf "1:%s\n" "$producto" >> "$nombreArchivo"
	else
		idMayor="$(sed '/^$/d' "$nombreArchivo" | tail -n 1 | awk -F: '{print $1}')"
		((idMayor++))
		print "$idMayor"
		printf "\n%d:%s\n" "$idMayor" "$producto" >> "$nombreArchivo"
		sed -i '/^$/d' "$nombreArchivo"
	fi
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
		print "Un producto debe ser del tipo id?:nombre:costo:cantidadEnAlmacen"
		return 1
	fi

	if [[ ! "$id" =~ ^\d+$ ]]; then
		print "El id debe ser un número natural."
		return 1
	fi

	if [[ ! "$cantidadEnAlmacen" =~ ^\d+$ ]]; then
		print "La cantidad en almacén debe ser un número natural."
		return 1
	fi
}

function checkFile {
	./checkeoGeneralDeArchivo.ksh "$nombreArchivo"
	if [[ ! $? ]]; then
		print "$?"
		#exit
	fi

	cnt=0
	errores=""
	banderaError=false
	(
		cat $nombreArchivo
		echo
	) | while read linea; do
		((cnt++))
		if [[ -z "$linea" ]]; then
			continue
		fi
		if [[ ! "$linea" =~ ^[^:]+:[^:]+:[^:]+:[^:]+$ ]]; then
			errores+="Error en linea $cnt : Un producto debe ser del tipo id?:nombre:costo:cantidadEnAlmacen \n"
			banderaError=true
		else
			resultado=$(checkProductoLine "$linea")
			if (($? == 1)); then
				errores+="Error en linea $cnt : $resultado \n"
				banderaError=true
			fi
		fi
	done

	#Checkeo de identificadores únicos.
	(
		cat $nombreArchivo
		echo
	) | while read linea; do
		id="$(echo $linea | awk -F: '{print $1}')"
		idCnt="$(cat $nombreArchivo | awk -F: -v id="$id" '
			BEGIN{cnt=0}
			{if(id == $1){cnt++}}
			END{print cnt}')"
		if ((idCnt > 1)); then
			idErrores[id]="id $id se repite $idCnt veces."
		fi
	done

	if (( ${#idErrores[*]} > 0)); then
		banderaError=true
		errores+="Los identificadores deben ser únicos\n"
		for error in "${idErrores[*]}"; do
		errores+="$error\n"
		done
	fi

	if $banderaError; then
		print "Archivo $nombreArchivo corrupto."
		print "$errores"
	fi

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
	agregar "$aFlagArg"
fi
if [[ $nFlag ]]; then
	checkProductoLine "$nFlagArg"
fi
