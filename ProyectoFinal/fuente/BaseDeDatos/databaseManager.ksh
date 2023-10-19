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
        exit 1
    fi
    database="$(echo "$addQuery" | sed 's/:.*$//')"
    objeto="$(echo "$addQuery" | sed 's/^[^:]*://g')"

    case "$database" in
    usuarios)
        respuesta="$(./crudUsuarios.ksh -a "$objeto")"
        print "$respuesta"
        if (($? != 0)); then
            exit 1
        fi
        ;;
    productos)
        respuesta="$(./crudProductos.ksh -a "$objeto")"
        print "$respuesta"
        if (($? != 0)); then
            exit 1
        fi
        ;;
    clientes)
        respuesta="$(./crudClientes.ksh -a "$objeto")"
        print "$respuesta"
        if (($? != 0)); then
            exit 1
        fi
        ;;
    ventas)
        #Solo requiere el id del cliente
        if [[ ! "$objeto" =~ ^\d+$ ]]; then
            print "El id del cliente debe ser un número natural."
            exit 1
        fi
        respuesta="$(./crudVentas.ksh -a "$objeto:$(date +"%d-%m-%y/%H-%M-%S")")"
        print "$respuesta"
        if (($? != 0)); then
            exit 1
        fi
        ;;
    ventasproductos)
        respuesta="$(./crudVentasProductos.ksh -a "$objeto")"
        print "$respuesta"
        if (($? != 0)); then
            exit 1
        fi
        ;;
    insumos)
        print "To do"
        ;;
    [?])
        print "Opción de base datos inválida."
        exit 1
        ;;
    esac
}

function obtenerElemento {
    query="$1"
    if [[ ! "$query" =~ ^[^:]+:[^:]+ ]]; then
        print "Formato de query basedatos:llave"
        exit 1
    fi

    basedatos="$(echo "$query" | awk -F: '{print $1}')"
    idElemento="$(echo "$query" | awk -F: '{print $2}')"

    case "$basedatos" in
    usuarios)
        print "$(./crudUsuarios.ksh -g "$idElemento")"
        ;;
    productos)
        print "$(./crudProductos.ksh -g "$idElemento")"
        ;;
    clientes)
        print "$(./crudClientes.ksh -g "$idElemento")"
        ;;
    [?])
        print "Opción de base datos inválida."
        exit 1
        ;;
    esac

}

function obtenerTodosElementos {
    case "$1" in
    usuarios)
        print "$(./crudUsuarios.ksh -t)"
        ;;
    productos)
        print "$(./crudProductos.ksh -t)"
        ;;
    clientes)
        print "$(./crudClientes.ksh -t)"
        ;;
    [?])
        print "Opción de base datos inválida."
        exit 1
        ;;
    esac
}

function checarUsuarioPassword {
    # Regresa usuario:nivel si es correcta la autenticación.
    # Si no lo es no regresa nada.
    # Revisar retorno de error en caso de mal parámetro
    # Nivel usuario normal: 1
    # Nivel usuario admin: 2

    usuarioPassword="$1"

    if [[ ! "$usuarioPassword" =~ ^[^:]+:[^:]+$ ]]; then
        print "El parámetro debe ser de tipo usuario:password"
        exit 1
    fi

    usuarioPorChecar="$(echo "$usuarioPassword" | awk -F: '{print $1}')"
    passwordPorChecar="$(echo "$usuarioPassword" | awk -F: '{print $2}')"

    usuarioEnBD="$(./crudUsuarios.ksh -g "$usuarioPorChecar")"

    if [[ -z "$usuarioEnBD" ]]; then
        exit
    fi

    passwordUsuarioEnBD="$(echo "$usuarioEnBD" | awk -F: '{print $3}')"
    nivelUsuarioEnBD="$(echo "$usuarioEnBD" | awk -F: '{print $4}')"

    if [ "$passwordPorChecar" = "$passwordUsuarioEnBD" ]; then
        printf "%s:%d" "$usuarioPorChecar" "$nivelUsuarioEnBD"
    fi
}

function checarSaludGeneral {
    ./crudClientes.ksh -c
    ./crudProductos.ksh -c
    ./crudUsuarios.ksh -c
    ./crudVentas.ksh -c
    ./crudVentasProductos.ksh -c
}

while getopts a:g:t:l:cu:r: o; do
    case "$o" in
    a)
        # Agregar - add
        aFlag=true
        aFlagArg="$OPTARG"

        ;;
    g)
        # Obtener - get
        gFlag=true
        gFlagArg="$OPTARG"
        ;;
    t)
        # Obtener todos
        tFlag=true
        tFlagArg="$OPTARG"
        ;;
    c)
        # Checar salud de todos los archivos
        cFlag=true
        ;;
    u)
        # update 
        ;;
    r)
        # remover - remove
        ;;
    l)
        # Checar usuario PassWord
        lFlag=true
        lFlagArg="$OPTARG"
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

if [[ $lFlag ]]; then
    # login
    checarUsuarioPassword "$lFlagArg"
fi
if [[ $aFlag ]]; then
    addElement "$aFlagArg"
fi
if [[ $gFlag ]]; then
    obtenerElemento "$gFlagArg"
fi
if [[ $tFlag ]]; then
    obtenerTodosElementos "$tFlagArg"
fi

if [[ $cFlag ]]; then
    checarSaludGeneral
fi

