#!/bin/ksh

# Importanción de librerías
export FPATH="$(pwd)/../lib"
autoload easyTput
autoload bd

# Ejecución de checkeos de precaución
# por hacer

# Ejecución de Login

source ./Scripts/login.ksh

if [ ! -z "$usuario" ];then
# Si llegamos aquí usuario usuario:nivel ya existe
    #Ejecución de menú.
    source ./Scripts/menu.ksh
fi

