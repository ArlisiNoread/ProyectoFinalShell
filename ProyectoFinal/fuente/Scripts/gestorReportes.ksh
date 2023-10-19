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

function tituloReportes {
    easyTput colortexto verde
    figlet -c "Reportes"
    easyTput reset
}

function opcionesReportes {
    1.- Reporte Semanal
    2.- Reporte Mensual
    3.- Reporte Anual
}

while true; do
    opcionesReportes
done
tituloReportes
