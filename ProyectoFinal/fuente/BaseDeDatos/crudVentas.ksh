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

readonly nombreArchivo="Ventas.txt"

function agregar {
	venta="$1"

	# Se verifican que sea de tipo fk-idCliente:dateTime["%d-%m-%y/%H-%M-%S"]
	if [[ ! "$venta" =~ ^[^:]+:[^:]+$ ]]; then
		# Para obtener las ventas con este formato se usa 'date +"%d-%m-%y/%H-%M-%S"'
		print "La Ventas debe ser del tipo fk-Cliente:dateTime["%d-%m-%y/%H-%M-%S"]\n"
		exit 1
	fi

	respuestaAnalisis="$(checkVentaLine "$venta")"

	if (($? != 0)); then
		print "$respuestaAnalisis"
		exit 1
	fi

	fkCliente="$(echo "$venta" | awk -F: '{print $1}')"
	revisarSiExisteCliente="$(./crudClientes.ksh -g "$fkCliente")"

	if [ -z "$revisarSiExisteCliente" ]; then
		print "Cliente no existe en base de datos."
		exit 1
	fi

	if [[ ! -s "$nombreArchivo" ]]; then
		idMayor=1
		printf "1:%s\n" "$venta" >>"$nombreArchivo"
	else
		idMayor="$(sed '/^$/d' "$nombreArchivo" | tail -n 1 | awk -F: '{print $1}')"
		((idMayor++))
		printf "\n%d:%s\n" "$idMayor" "$venta" >>"$nombreArchivo"
		sed -i '/^$/d' "$nombreArchivo"
	fi
	print "$idMayor"
}

function getElement {
	# En este caso el identificador es el id de la venta.
	# Si la venta existe regresa la linea.
	# En caso contrario no regresa nada
	print "$(cat "$nombreArchivo" | awk -F: -v venta="$1" '(venta == $1) {print $0; exit;}')"
}

function getAllElements {
	# Regresa todos las ventas
	print "$(cat "$nombreArchivo")"
}

function remover {

	idVenta="$1"

	if [[ ! "$idVenta" =~ ^\d+$ ]]; then
		print "Id de la venta debe ser un número natural."
		exit 1
	fi

	# Se borran las lineas de VentasProductos de esta venta.
	./crudVentasProductos.ksh -k "$idVenta"

	sed -i "/^$idVenta/d" "$nombreArchivo"
}

function checkVentaLine {
	if [[ "$1" =~ ^[^:]+:[^:]+:[^:]+$ ]]; then
		#Formato id:fk-cliente:dateTime["%d-%m-%Y/%H-%M-%S"]
		id="$(echo "$1" | awk -F: '{print $1}')"
		fkCliente="$(echo "$1" | awk -F: '{print $2}')"
		dateTime="$(echo "$1" | awk -F: '{print $3}')"
	elif [[ "$1" =~ ^[^:]+:[^:]+$ ]]; then
		#Formato nombre:celular:direccion
		id=0
		fkCliente="$(echo "$1" | awk -F: '{print $1}')"
		dateTime="$(echo "$1" | awk -F: '{print $2}')"
	else
		print "Una venta debe ser del tipo id?:fk-cliente:dateTime["%d-%m-%Y/%H-%M-%S"]"
		exit 1
	fi

	if [[ ! "$id" =~ ^\d+$ ]]; then
		print "El id debe ser un número natural."
		exit 1
	fi

	if [[ ! "$fkCliente" =~ ^\d+$ ]]; then
		print "El fk-cliente debe ser un número natural."
		exit 1
	fi

	if [[ ! "$dateTime" =~ ^\d+-\d+-\d+\/\d+-\d+-\d+$ ]]; then
		print "El dateTime debe tener formato de "%d-%m-%Y/%H-%M-%S"."
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
		if [[ ! "$linea" =~ ^[^:]+:[^:]+:[^:]+$ ]]; then
			errores+="Error en linea $cnt : Una venta debe ser del tipo id:fk-cliente:dateTime[día-mes-año/hora-minuto-segundo]\n"
			banderaError=true
		else
			resultado=$(checkVentaLine "$linea")
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
