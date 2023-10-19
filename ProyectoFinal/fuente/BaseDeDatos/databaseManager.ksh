#!/bin/ksh
#
# Script que unifica las solicitudes a bases de datos.
#
# Banderas:
# -c: checar usuario:password -> -c "usuario:password"

if [ "$0" =~ ^*databaseManager.ksh$ ]; then
    libreriaDesdeScript=true
    export FPATH="$(pwd)/../../lib"
    autoload easyTput
    autoload bd
    autoload log
fi

function cleanup {
    #Se realizan procesos de salida.
    codigoSalida="$?"
    exit "$codigoSalida"
}

#Traps
trap 'cleanup' EXIT
trap 'cleanup' INT HUP QUIT TERM ALRM USR1



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
        if (($? != 0)); then
            print "$respuesta"
            exit 1
        fi

        ;;
    productos)
        respuesta="$(./crudProductos.ksh -a "$objeto")"
        if (($? != 0)); then
            print "$respuesta"
            exit 1
        fi
        ;;
    clientes)
        print "Test"

        respuesta="$(./crudClientes.ksh -a "$objeto")"
        if (($? != 0)); then
            print "$respuesta"
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
        if (($? != 0)); then
            print "$respuesta"
            exit 1
        fi
        ;;
    ventasproductos)
        respuesta="$(./crudVentasProductos.ksh -a "$objeto")"
        if (($? != 0)); then
            print "$respuesta"
            exit 1
        fi
        ;;
    *)
        print "Opción de base datos inválida."
        exit 1
        ;;
    esac
    print "$respuesta"

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
    ventas)
        print "$(./crudVentas.ksh -g "$idElemento")"
        ;;
    ventasproductos)
        print "$(./crudVentasProductos.ksh -g "$idElemento")"
        ;;
    *)
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
    ventas)
        print "$(./crudVentas.ksh -t)"
        ;;
    ventasproductos)
        print "$(./crudVentasProductos.ksh -t)"
        ;;
    *)
        print "Opción de base datos inválida."
        exit 1
        ;;
    esac
}

function update {
    query="$1"
    if [[ ! "$query" =~ ^[^:]+:[^:]+ ]]; then
        print "Formato de query basedatos:[datos-sustitución]"
        exit 1
    fi

    basedatos="$(echo "$query" | awk -F: '{print $1}')"
    objeto="$(echo "$query" | awk -F: '
        {
            i=2
            limit=NF
            while(i < limit){
                printf "%s:", $i
                i++
            }
            printf "%s\n", $i
        }')"

    case "$basedatos" in
    usuarios)
        print "$(./crudUsuarios.ksh -u "$objeto")"
        ;;
    productos)
        print "$(./crudProductos.ksh -u "$objeto")"
        ;;
    clientes)
        print "$(./crudClientes.ksh -u "$objeto")"
        ;;
    *)
        print "Opción de base datos inválida."
        exit 1
        ;;
    esac
}

function remover {
    query="$1"
    if [[ ! "$query" =~ ^[^:]+:[^:]+ ]]; then
        print "Formato de query basedatos:llave"
        exit 1
    fi

    basedatos="$(echo "$query" | awk -F: '{print $1}')"
    idElemento="$(echo "$query" | awk -F: '{print $2}')"

    case "$basedatos" in
    usuarios)
        print "$(./crudUsuarios.ksh -r "$idElemento")"
        ;;
    productos)
        print "$(./crudProductos.ksh -r "$idElemento")"
        ;;
    clientes)
        print "$(./crudClientes.ksh -r "$idElemento")"
        ;;
    ventas)
        print "$(./crudVentas.ksh -r "$idElemento")"
        ;;
    *)
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
    errorRespuesta=""
    errorRespuesta+="$(./crudClientes.ksh -c)"
    if (($? != 0)); then
        error=true
    fi
    errorRespuesta+="$(./crudProductos.ksh -c)"
    if (($? != 0)); then
        error=true
    fi
    errorRespuesta+="$(./crudUsuarios.ksh -c)"
    if (($? != 0)); then
        error=true
    fi
    errorRespuesta+="$(./crudVentasProductos.ksh -c)"
    if (($? != 0)); then
        error=true
    fi
    if [ ! -z "$error" ]; then
        print "$errorRespuesta"
        return 1
    fi

}

function llenadoInicialTesteo {

    print "Esto reiniciará las bases de datos"
    printf "¿Seguro? Escribe 'seguro': "
    read seguro
    print

    if [ "$seguro" = "seguro" ]; then
        print "Ok, si estás seguro."
        print ""
    else
        print "Regresa cuando estés seguro."
        exit 1
    fi

    print "Reiniciando bases de datos."
    rm *.txt
    checarSaludGeneral

    print "Insertando elementos."

    # Llenamos usuarios iniciales
    d="usuarios"
    usuarios="admin:admin:2\n"
    usuarios+="emanuel:123:2\n"
    usuarios+="jorge:256:2\n"
    usuarios+="roberto:789:2\n"

    print $usuarios | while read line; do
        if [ -z "$line" ]; then
            continue
        fi
        r=$(addElement "$d:$line")
        print "Agregado en $d: $line"
    done

    d="clientes"
    clientes="Alfredo Adame:55575859:Cerro del sombrero 431-3, Col. Pedregal.\n"
    clientes+="Yordi Rosado:55646968:Quiubole 1567, Col. Rollo.\n"
    clientes+="Santa Catarina De la pasión de nuestro señor:51777777:Convento de la sanación ramificada.\n"
    clientes+="Alesteir Crowley:01800666666:Camino al infierno 1408\n"
    clientes+="Dominero Pizza:018005522222:En tu esquina favorita\n"

    print $clientes | while read line; do
        if [ -z "$line" ]; then
            continue
        fi
        r=$(addElement "$d:$line")
        print "Agregado en $d: $line"
    done

    d="productos"
    productos="Acondicionador sólido, lavanda, 140g:129.0:1000\n"
    productos+="Acondicionador sólido, lavanda, 60g:74.90:1000\n"
    productos+="Acondicionador sólido, menta, 140g:129.0:500\n"
    productos+="Acondicionador sólido, eucalipto, 60g:74.90:500\n"
    productos+="Tableta pasta dental, menta, 25g:98.70:500\n"
    productos+="Tableta pasta dental, con fluoruro, 25g:98.70:500\n"

    print $productos | while read line; do
        if [ -z "$line" ]; then
            continue
        fi
        r=$(addElement "$d:$line")
        print "Agregado en $d: $line"
    done

    d="ventas"
    ((azarVentas = $RANDOM % 10 + 5))
    noClientes="$(obtenerTodosElementos "clientes" | wc -l)"
    cnt=0
    while ((cnt < azarVentas)); do
        ((randomId = 1 + $RANDOM % (noClientes - 1)))
        r=$(addElement "$d:$randomId")
        print "Agregado en $d: id-venta $r"
        ((cnt++))
    done

    d="ventasproductos"
    noProductos="$(obtenerTodosElementos "productos" | wc -l)"
    cnt=1
    ((noRandProductos = $RANDOM % 10 + 5))
    while ((cnt <= azarVentas)); do
        cntProducto=0
        while ((cntProducto < noRandProductos)); do
            ((cantidad = $RANDOM % 9 + 1))
            ((randomId = 1 + $RANDOM % (noProductos - 1)))
            r=$(addElement "$d:$cnt:$randomId:$cantidad")
            print "Agregado en $d: id-venta $r"
            ((cntProducto++))
        done
        ((cnt++))
    done

    print "Base de datos llenada correctamente."

}

while getopts a:g:t:l:cu:r:x o; do
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
        uFlag=true
        uFlagArg="$OPTARG"
        ;;
    r)
        # remover - remove
        rFlag=true
        rFlagArg="$OPTARG"
        ;;
    l)
        # Checar usuario PassWord
        lFlag=true
        lFlagArg="$OPTARG"
        #usuario:contraseñas
        #regresa usuario:nivel
        ;;
    x)
        # Llenado de arranque testeo
        xFlag=true
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

if [[ $uFlag ]]; then
    update "$uFlagArg"
fi

if [[ $rFlag ]]; then
    #Remove
    remover "$rFlagArg"
fi

if [[ $xFlag ]]; then
    llenadoInicialTesteo
fi
