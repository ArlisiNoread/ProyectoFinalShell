#!/bin/ksh

# Nombre de script: gestorReportes.ksh
# Descripción:
#
#       Script encargado de mostrar reportes y da
#       la opción de mandarlos por correo.
#

if [ "$0" =~ ^*gestorUsuarios.ksh$ ]; then
    libreriaDesdeScript=true
    export FPATH="$(pwd)/../../lib"
    autoload easyTput
    autoload bd
    autoload log
fi