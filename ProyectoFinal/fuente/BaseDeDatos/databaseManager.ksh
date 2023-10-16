#!/bin/ksh
#
# Script que unifica las solicitudes a bases de datos.
#
# Banderas:
# -a: checar usuario:password -> -a "usuario:password"

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

    if (("$passwordPorChecar" == "$passwordUsuarioEnBD")); then
        printf "%s:%d" "$usuarioPorChecar" "$nivelUsuarioEnBD"
    fi

}

while getopts a: o; do
    case "$o" in
    a)
        aFlag=true
        aFlagArg="$OPTARG"
        ;;
    [?])
        print >&2 "Error Usage: $0 [-s] [-d seplist] file ..."
        exit 1
        ;;
    esac
done
shift $OPTIND-1

if [[ $aFlag ]]; then
    checarUsuarioPassword "$aFlagArg"
fi
