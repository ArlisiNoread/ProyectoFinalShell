#!/bin/ksh
#
# Script que unifica las solicitudes a bases de datos.
#
# Banderas:
# -c: checar usuario:password -> -c "usuario:password"

function addElement {
    addQuery="$1"
    if [[ ! "$addQuery" =~ ^[^:]+:.*$ ]]; then
        print "Query de agregado debe tener estructura basedatos:[objetoPorAgregar]"
        return 1
    fi
    database="$(echo "$addQuery" | sed 's/:.*$//')"
    objeto="$(echo "$addQuery" | sed 's/^[^:]*://g')"

    case "$database" in
    usuarios)
        respuesta="$(./crudUsuarios.ksh -a "$objeto")"
        if (($? != 0)); then
            print "$respuesta"
            exit 1
        fi

        ;;
    [?]) ;;
    esac
}

function checarUsuarioPassword {
    # Regresa usuario:nivel si es correcta la autenticación.
    # Si no lo es no regresa nada.
    # Revisar retorno de error en caso de mal parámetro

    usuarioPassword="$1"

    if [[ ! "$usuarioPassword" =~ ^[^:]+:[^:]+$ ]]; then
        print "El parámetro debe ser de tipo usuario:password"
        return 1
    fi

    usuarioPorChecar="$(echo "$usuarioPassword" | awk -F: '{print $1}')"
    passwordPorChecar="$(echo "$usuarioPassword" | awk -F: '{print $2}')"

    usuarioEnBD="$(./crudUsuarios.ksh -g "$usuarioPorChecar")"

    if [[ -z "$usuarioEnBD" ]]; then
        return
    fi

    passwordUsuarioEnBD="$(echo "$usuarioEnBD" | awk -F: '{print $3}')"
    nivelUsuarioEnBD="$(echo "$usuarioEnBD" | awk -F: '{print $4}')"

    if [ "$passwordPorChecar" = "$passwordUsuarioEnBD" ]; then
        printf "%s:%d" "$usuarioPorChecar" "$nivelUsuarioEnBD"
    fi
}

while getopts a:c: o; do
    case "$o" in
    a)
        # Agregar
        aFlag=true
        aFlagArg="$OPTARG"

        ;;
    c)
        # Checar usuario PassWord
        cFlag=true
        cFlagArg="$OPTARG"
        #usuario:contraseñas
        #regresa usuario:nivel
        ;;
    [?])
        print >&2 "Error Usage: $0 [-s] [-d seplist] file ..."
        exit 1
        ;;
    esac
done
shift $OPTIND-1

if [[ $cFlag ]]; then
    checarUsuarioPassword "$cFlagArg"
fi
if [[ $aFlag ]]; then
    addElement "$aFlagArg"
fi
