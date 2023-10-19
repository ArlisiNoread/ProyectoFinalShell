#!bin/ksh

if [ "$0" =~ ^*gestorVentasProductos.ksh$ ]; then
    libreriaDesdeScript=true
    export FPATH="$(pwd)/../../lib"
    autoload easyTput
    autoload bd
fi