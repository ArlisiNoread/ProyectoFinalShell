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

readonly nombreArchivo="VentasProductos.txt"

function agregar {
	ventaProducto="$1"

	# Se verifican que sea de tipo fk-Venta:fk-Producto:cantidad
	reg="^[^:]+:[^:]+:[^:]+$"
	if [[ ! "$ventaProducto" =~ $reg ]]; then
		print "La ventaProducto debe ser del tipo fk-Venta:fk-Producto:cantidad\n"
		exit 1
	fi

	respuestaAnalisis="$(checkVentaProductoLine "$ventaProducto")"

	if (($? != 0)); then
		print "$respuestaAnalisis"
		exit 1
	fi

	fkVenta="$(echo "$ventaProducto" | awk -F: '{print $1}')"
	revisarSiExisteVenta="$(./crudVentas.ksh -g "$fkVenta")"

	if [ -z "$revisarSiExisteVenta" ]; then
		print "Venta $fkVenta no existe en base de datos."
		exit 1
	fi

	fkProducto="$(echo "$ventaProducto" | awk -F: '{print $2}')"
	revisarSiExisteProducto="$(./crudProductos.ksh -g "$fkProducto")"

	if [ -z "$revisarSiExisteProducto" ]; then
		print "Producto $fkProducto no existe en base de datos."
		exit 1
	fi

	nombreProducto="$(echo "$revisarSiExisteProducto" | awk -F: '{print $2}')"
	costo="$(echo "$revisarSiExisteProducto" | awk -F: '{print $3}')"

	productoConcatenado="$nombreProducto-$costo"

	ventaProductoCorregido="$(echo "$ventaProducto" | sed "s/:.*:/:$productoConcatenado:/")"

	if [[ ! -s "$nombreArchivo" ]]; then
		idMayor=1
		printf "1:%s\n" "$ventaProductoCorregido" >>"$nombreArchivo"
	else
		idMayor="$(sed '/^$/d' "$nombreArchivo" | tail -n 1 | awk -F: '{print $1}')"
		((idMayor++))
		printf "\n%d:%s\n" "$idMayor" "$ventaProductoCorregido" >>"$nombreArchivo"
		sed -i '/^$/d' "$nombreArchivo"
	fi
	print "$idMayor"
}

function getElement {
	# En este caso el identificador es el id de la venta.
	# Si la venta existe regresa la linea.
	# En caso contrario no regresa nada
	print "$(cat "$nombreArchivo" | awk -F: -v ventaProducto="$1" '(ventaProducto == $1) {print $0; exit;}')"
}

function getAllElements {
	# Regresa todos las ventas
	print "$(cat "$nombreArchivo")"
}

function remover {

	idVentaProducto="$1"

	if [[ ! "$idVentaProducto" =~ ^\d+$ ]]; then
		print "Id de la venta debe ser un número natural."
		exit 1
	fi

	sed -i "/^$idVentaProducto/d" "$nombreArchivo"
}

function removerTodosDeUnaVenta {

	idVenta="$1"
	if [[ ! "$idVenta" =~ ^\d+$ ]]; then
		print "Id de la venta debe ser un número natural."
		exit 1
	fi

	sed -i "/^[^:]:$idVenta:.*$/d" "$nombreArchivo"
}


function checkVentaProductoLine {

	reg="^[^:]+:[^:]+:[^:-]+-[^:-]+:[^:]+$"
	reg2="^[^:]+:[^:]+:[^:]+$"
	if [[ "$1" =~ $reg ]]; then
		#Formato id:fk-Venta:nombreProducto-costo:cantidad
		id="$(echo "$1" | awk -F: '{print $1}')"
		fkVenta="$(echo "$1" | awk -F: '{print $2}')"
		nombreProductoCosto="$(echo "$1" | awk -F: '{print $3}')"
		costo="$(echo "$nombreProductoCosto" | awk -F '-' '{print $2}')"
		cantidad="$(echo "$1" | awk -F: '{print $4}')"

		if [[ ! "$id" =~ ^\d+$ ]]; then
			print "El id debe ser un número natural."
			exit 1
		fi
		if [[ ! "$fkVenta" =~ ^\d+$ ]]; then
			print "La fk-venta debe ser un número natural."
			exit 1
		fi
		if [[ ! "$costo" =~ ^\d+(.\d+)?$ ]]; then
			print "El costo debe ser un número real."
			exit 1
		fi
		if [[ ! "$cantidad" =~ ^\d+$ ]]; then
			print "La cantidad debe ser un número natural."
			exit 1
		fi
		exit
	elif [[ "$1" =~ $reg2 ]]; then
		#Formato fk-Venta:fk-Producto:cantidad
		id=0
		fkVenta="$(echo "$1" | awk -F: '{print $1}')"
		fkProducto="$(echo "$1" | awk -F: '{print $2}')"
		cantidad="$(echo "$1" | awk -F: '{print $3}')"
	else
		print "Una ventaProducto debe ser del tipo id?:fk-venta:fk-producto:cantidad"
		exit 1
	fi

	if [[ ! "$id" =~ ^\d+$ ]]; then
		print "El id debe ser un número natural."
		exit 1
	fi
	if [[ ! "$fkVenta" =~ ^\d+$ ]]; then
		print "La fk-venta debe ser un número natural."
		exit 1
	fi
	if [[ ! "$fkProducto" =~ ^\d+$ ]]; then
		print "La fk-producto debe ser un número natural."
		exit 1
	fi
	if [[ ! "$cantidad" =~ ^\d+$ ]]; then
		print "La cantidad debe ser un número natural."
		exit 1
	fi
}

function checkFile {

	respuesta="$(./checkeoGeneralDeArchivo.ksh "$nombreArchivo")"
	if (($? != 0)); then
		print "$Respuesta"
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
		reg="^[^:]+:[^:]+:[^:-]+-[^:-]+:[^:]+$"
		if [[ ! "$linea" =~ $reg ]]; then
			errores+="Error en linea $cnt : Una ventaProducto debe ser del tipo id:fk-venta:nombreProducto-costo:cantidad\n"
			banderaError=true
		else
			resultado=$(checkVentaProductoLine "$linea")
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

while getopts a:g:tu:r:k:cn: o; do
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
	k)
		kFlag=true
		kFlagArg="$OPTARG"
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
if [[ $kFlag ]]; then
	removerTodosDeUnaVenta "$kFlagArg"
fi
if [[ $nFlag ]]; then
	checkClienteLine "$nFlagArg"
fi
