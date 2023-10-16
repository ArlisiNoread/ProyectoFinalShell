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

readonly nombreArchivo="Usuarios.txt"

function agregar {
	usuarioObject="$1"

	if [[ ! "$usuarioObject" =~ ^[^:]+:[^:]+:[^:]+$ ]]; then
		print "El Usuario debe ser del tipo usuario:password:nivel \n"
		exit 1
	fi

	respuestaAnalisis=$(checkUsuarioLine "$usuarioObject")

	if (($? != 0)); then
		print "$respuestaAnalisis"
		exit 1
	fi

	#Checkeo de usuarios únicos.
	usuario="$(echo $usuarioObject | awk -F: '{print $1}')"

	userCnt="$(cat $nombreArchivo | awk -F: -v usuario="$usuario" '
			BEGIN{cnt=0}
			{if(usuario == $2){cnt++}}
			END{print cnt}')"
	if ((userCnt > 0)); then
		print "Usuario $usuario ya existe en base de datos de usuarios."
		exit 1
	fi

	if [[ ! -s "$nombreArchivo" ]]; then
		printf "1:%s\n" "$usuarioObject" >>"$nombreArchivo"
	else
		idMayor="$(sed '/^$/d' "$nombreArchivo" | tail -n 1 | awk -F: '{print $1}')"
		((idMayor++))
		print "$idMayor"
		printf "\n%d:%s\n" "$idMayor" "$usuarioObject" >>"$nombreArchivo"
		sed -i '/^$/d' "$nombreArchivo"
	fi

}

function getElement {
	# En este caso el identificador es el usuario.
	# Si el usuario existe regresa la linea.
	# En caso contrario no regresa nada
	print "$(cat "$nombreArchivo" | awk -F: -v usuario="$1" '(usuario == $2) {print $0; exit;}')"
}

function checkUsuarioLine {
	if [[ "$1" =~ ^[^:]+:[^:]+:[^:]+:[^:]+$ ]]; then
		#Formato id:usuario:password:nivel
		id="$(echo "$1" | awk -F: '{print $1}')"
		nivel="$(echo "$1" | awk -F: '{print $4}')"
	elif [[ "$1" =~ ^[^:]+:[^:]+:[^:]+$ ]]; then
		#Formato usuario:password:nivel
		id=0
		nivel="$(echo "$1" | awk -F: '{print $3}')"
	else
		print "Un usuario debe ser del tipo id?:usuario:password:nivel"
		exit 1
	fi

	if [[ ! "$id" =~ ^\d+$ ]]; then
		print "El id debe ser un número natural."
		exit 1
	fi

	if [[ ! "$nivel" =~ ^\d+$ ]]; then
		print "El nivel debe ser un número natural."
		exit 1
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
			errores+="Error en linea $cnt : Un usuario debe ser del tipo id?:usuario:password:nivel \n"
			banderaError=true
		else
			resultado=$(checkUsuarioLine "$linea")
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

	#Checkeo de usuarios únicos.
	(
		cat $nombreArchivo
		echo
	) | while read linea; do
		usuario="$(echo $linea | awk -F: '{print $2}')"
		userCnt="$(cat $nombreArchivo | awk -F: -v usuario="$usuario" '
			BEGIN{cnt=0}
			{if(usuario == $2){cnt++}}
			END{print cnt}')"
		if ((userCnt > 1)); then
			idErrores[id]="Nombre de usuario $usuario se repite $userCnt veces."
		fi
	done

	if ((${#idErrores[*]} > 0)); then
		banderaError=true
		errores+="Los nombre de usuarios deben ser únicos\n"
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
		gFlag=true
		gFlagArg="$OPTARG"
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
if [[ $gFlag ]]; then
	getElement "$gFlagArg"
fi
if [[ $nFlag ]]; then
	checkProductoLine "$nFlagArg"
fi
