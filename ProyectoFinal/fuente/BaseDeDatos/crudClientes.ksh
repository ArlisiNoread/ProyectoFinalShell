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

readonly nombreArchivo="Clientes.txt"

function agregar {
	cliente="$1"
	
	# Se verifican que sea de tipo nombre:celular:dirección
	if [[ ! "$cliente" =~ ^[^:]+:[^:]+:[^:]+$ ]]; then
		print "El producto debe ser del tipo nombre:celular:dirección \n"
		exit 1
	fi

	respuestaAnalisis=$(checkClienteLine "$cliente")

	if (($? != 0)); then
		print "$respuestaAnalisis"
		exit 1
	fi

	if [[ ! -s "$nombreArchivo" ]]; then
		idMayor=1
		printf "1:%s\n" "$cliente" >>"$nombreArchivo"
	else
		idMayor="$(sed '/^$/d' "$nombreArchivo" | tail -n 1 | awk -F: '{print $1}')"
		((idMayor++))
		printf "\n%d:%s\n" "$idMayor" "$cliente" >>"$nombreArchivo"
		sed -i '/^$/d' "$nombreArchivo"
	fi
	print "$idMayor"
}

function getElement {
	# En este caso el identificador es el id del cliente.
	# Si el cliente existe regresa la linea.
	# En caso contrario no regresa nada
	print "$(cat "$nombreArchivo" | awk -F: -v cliente="$1" '(cliente == $1) {print $0; exit;}')"
}

function getAllElements {
	# Regresa todos los Productos
	print "$(cat "$nombreArchivo")"
}

function remover {

	idCliente="$1"

	if [[ ! "$idCliente" =~ ^\d+$ ]]; then
		print "Id del producto debe ser un número natural."
		exit 1
	fi

	sed -i "/^$idCliente/d" "$nombreArchivo"
}

function update {
	cliente="$1"
	
	# Se verifican que sea de tipo nombre:celular:dirección
	if [[ ! "$cliente" =~ ^[^:]+:[^:]+:[^:]+:[^:]+$ ]]; then
		print "El producto debe ser del tipo id:nombre:celular:dirección \n"
		exit 1
	fi

	respuestaAnalisis=$(checkClienteLine "$cliente")

	if (($? != 0)); then
		print "$respuestaAnalisis"
		exit 1
	fi

	if [[ ! -s "$nombreArchivo" ]]; then
		idMayor=1
		printf "1:%s\n" "$cliente" >>"$nombreArchivo"
	else
		idMayor="$(sed '/^$/d' "$nombreArchivo" | tail -n 1 | awk -F: '{print $1}')"
		((idMayor++))
		printf "\n%d:%s\n" "$idMayor" "$cliente" >>"$nombreArchivo"
		sed -i '/^$/d' "$nombreArchivo"
	fi
	print "$idMayor"
}


function checkClienteLine {
	if [[ "$1" =~ ^[^:]+:[^:]+:[^:]+:[^:]+$ ]]; then
		#Formato id:nombre:celular:direccion
		id="$(echo "$1" | awk -F: '{print $1}')"
		celular="$(echo "$1" | awk -F: '{print $3}')"
	elif [[ "$1" =~ ^[^:]+:[^:]+:[^:]+$ ]]; then
		#Formato nombre:celular:direccion
		id=0
		celular="$(echo "$1" | awk -F: '{print $2}')"
	else
		print "Un cliente debe ser del tipo id?:nombre:celular:dirección"
		exit 1
	fi

	if [[ ! "$id" =~ ^\d+$ ]]; then
		print "El id debe ser un número natural."
		exit 1
	fi

	if [[ ! "$celular" =~ ^(\+|\d)[0-9]{7,16}$ ]]; then
		print "El celular debe tener formato de número celular tradicional."
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
			errores+="Error en linea $cnt : Un cliente debe ser del tipo id?:nombre:celular:direccion \n"
			banderaError=true
		else
			resultado=$(checkClienteLine "$linea")
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
		print "update"
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
if [[ $rFlag ]]; then
	remover "$rFlagArg"
fi
if [[ $nFlag ]]; then
	checkClienteLine "$nFlagArg"
fi
