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
		exit 1
	fi

	respuestaAnalisis=$(checkProductoLine "$producto")

	if (($? != 0)); then
		print "$respuestaAnalisis"
		exit 1
	fi

	if [[ ! -s "$nombreArchivo" ]]; then
		idMayor=1
		printf "1:%s\n" "$producto" >>"$nombreArchivo"
	else
		idMayor="$(sed '/^$/d' "$nombreArchivo" | tail -n 1 | awk -F: '{print $1}')"
		((idMayor++))
		printf "\n%d:%s\n" "$idMayor" "$producto" >>"$nombreArchivo"
		sed -i '/^$/d' "$nombreArchivo"
	fi
	print "$idMayor"

}

function getElement {
	# En este caso el identificador es el producto.
	# Si el pructo existe regresa la linea.
	# En caso contrario no regresa nada
	print "$(cat "$nombreArchivo" | awk -F: -v producto="$1" '(producto == $1) {print $0; exit;}')"
}

function getAllElements {
	# Regresa todos los Productos
	print "$(cat "$nombreArchivo")"
}

function remover {

	idProducto="$1"

	if [[ ! "$idProducto" =~ ^\d+$ ]]; then
		print "Id del producto debe ser un número natural."
		exit 1
	fi

	sed -i "/^$idProducto/d" "$nombreArchivo"
}

function update {
	producto="$1"

	# Se verifican que sea de tipo id:nombre:costo:cantidadEnAlmacen
	if [[ ! "$producto" =~ ^[^:]+:[^:]+:[^:]+:[^:]+$ ]]; then
		print "El producto debe ser del tipo id:nombre:costo:cantidadEnAlmacen"
		exit 1
	fi

	respuestaAnalisis=$(checkProductoLine "$producto")
	if (($? != 0)); then
		print "$respuestaAnalisis"
		exit 1
	fi

	idProducto="$(print "$producto" | awk -F: '{print $1}')"
	nuevaTabla="$(cat "$nombreArchivo" | awk -F: -v id="$idProducto" -v newval="$producto" '
		{
		if(id == $1)
			print newval
		else
			print $0
		}
	')" 
	print "$nuevaTabla" >"$nombreArchivo"
}

function checkProductoLine {
	if [[ "$1" =~ ^[^:]+:[^:]+:[^:]+:[^:]+$ ]]; then
		#Formato id:nombre:costo:cantidadEnAlmacen
		id="$(echo "$1" | awk -F: '{print $1}')"
		costo="$(echo "$1" | awk -F: '{print $3}')"
		cantidadEnAlmacen="$(echo "$1" | awk -F: '{print $4}')"
	elif [[ "$1" =~ ^[^:]+:[^:]+:[^:]+$ ]]; then
		#Formato nombre:costo:cantidadEnAlmacen
		id=0
		costo="$(echo "$1" | awk -F: '{print $2}')"
		cantidadEnAlmacen="$(echo "$1" | awk -F: '{print $3}')"
	else
		print "Un producto debe ser del tipo id?:nombre:costo:cantidadEnAlmacen"
		exit 1
	fi

	if [[ ! "$id" =~ ^\d+$ ]]; then
		print "El id debe ser un número natural."
		exit 1
	fi

	if [[ ! "$costo" =~ ^\d+(.\d+)?$ ]]; then
		print "El costo debe ser un número real."
		exit 1
	fi

	if [[ ! "$cantidadEnAlmacen" =~ ^\d+$ ]]; then
		print "La cantidad en almacén debe ser un número natural."
		exit 1
	fi
}

function checkFile {
	respuesta="$(./checkeoGeneralDeArchivo.ksh "$nombreArchivo")"
	if (($? != 0)); then
		print "$respuesta"
		exit 1
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

	if ((${#idErrores[*]} > 0)); then
		banderaError=true
		errores+="Los identificadores deben ser únicos\n"
		for error in "${idErrores[*]}"; do
			errores+="$error\n"
		done
	fi

	if $banderaError; then
		print "Archivo $nombreArchivo corrupto."
		print "$errores"
		exit 1
	fi

}

while getopts a:g:tu:r:cn: o; do
	case "$o" in
	a)
		aFlag=true
		aFlagArg="$OPTARG"
		;;
	g)
		gFlag=true
		gFlagArg="$OPTARG"
		;;
	t)
		tFlag=true
		;;
	u)
		uFlag=true
		uFlagArg="$OPTARG"
		;;
	r)
		rFlag=true
		rFlagArg="$OPTARG"
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
if [[ $gFlag ]]; then
	getElement "$gFlagArg"
fi
if [[ $tFlag ]]; then
	getAllElements
fi
if [[ $uFlag ]]; then
	update "$uFlagArg"
fi
if [[ $rFlag ]]; then
	remover "$rFlagArg"
fi
if [[ $nFlag ]]; then
	checkProductoLine "$nFlagArg"
fi
