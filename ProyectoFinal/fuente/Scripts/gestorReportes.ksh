#!/bin/ksh

# Nombre de script: gestorReportes.ksh
# Descripción:
#
#       Script encargado de mostrar reportes y da
#       la opción de mandarlos por correo.
#

if [ "$0" =~ ^*gestorReportes.ksh$ ]; then
    libreriaDesdeScript=true
    export FPATH="$(pwd)/../../lib"
    autoload easyTput
    autoload bd
    autoload log
    usuario="admin:admin"
fi

log "$usuario:Entrada a gestor Reportes"

function generadorReportes {
    clear
    timeLapse=$1
    now="$(date "+%F")"
    case "$timeLapse" in
    1)
        # Semanal
        palabraTiempo="Semanal"
        backThen="$(date -d "$now - 7 days" "+%F")"
        ;;
    2)
        # Mensual
        palabraTiempo="Mensual"
        backThen="$(date -d "$now - 1 month" "+%F")"
        ;;
    3)
        # Anual
        palabraTiempo="Anual"
        backThen="$(date -d "$now - 12 month" "+%F")"
        ;;
    esac

    todasVentas="$(bd -t ventas)"
    todasVentasProductos="$(bd -t ventasproductos)"

    nowClean="$(print "$now" | sed 's/-//g')"
    backThenClean="$(print "$backThen" | sed 's/-//g')"

    ventasidEnRango=""
    ventasProductoEnRango=""
    (print "$todasVentas") | while read line; do
        if [ -z "$line" ]; then
            continue
        fi
        idVenta="$(print "$line" | awk -F: '{print $1}')"
        fechaHora="$(print "$line" | awk -F: '{print $3}')"
        fecha="$(print "$fechaHora" | awk -F "/" '{print $1}')"
        fechaClean="$(print "$fecha" | awk -F "-" '{printf "%d%02d%d", $3, $2, $1}')"

        if ((backThenClean <= fechaClean && fechaClean <= nowClean)); then
            ventasidEnRango+="$idVenta\n"
            ventasProductosEnRango+="$(print "$todasVentasProductos" | awk -F: -v idVenta="$idVenta" 'idVenta == $2 {print $0}')"
        fi
    done

    reporte=""
    
    print "$reporte"
    
    read ok
}

function tituloReportes {
    easyTput colortexto verde
    figlet -c "Reportes"
    easyTput reset
}

function opcionesReportes {
    print "\t1.- Reporte Semanal"
    print "\t2.- Reporte Mensual"
    print "\t3.- Reporte Anual"
    print "\t4.- Salir"
}

while true; do
    clear
    tituloReportes

    if [ ! -z "$err" ]; then
        easyTput colortexto rojo
        print "\tOpción incorrecta"
        easyTput reset
    else
        print ""
    fi
    opcionesReportes

    printf "\tOpción: "
    read opcion

    case "$opcion" in
    1) generadorReportes 1 ;;
    2) generadorReportes 2 ;;
    3) generadorReportes 3 ;;
    4) break ;;
    *) err=true ;;
    esac
done
