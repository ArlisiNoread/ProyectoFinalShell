#!/bin/ksh

function cleanup {
    #Se realizan procesos de salida.
    salidaConError= "$?"
    print "Procesos de salida por definir"
    exit 1
}

#Traps
trap 'cleanup' EXIT
trap 'cleanup' INT HUP QUIT TERM ALRM USR1

# Importanción de librerías
export FPATH="$(pwd)/../lib"
autoload easyTput
autoload bd

# Ejecución de checkeos de precaución
bd -c

# Ejecución de Login

source ./Scripts/login.ksh

if [ ! -z "$usuario" ]; then
    # Si llegamos aquí usuario usuario:nivel ya existe
    #Ejecución de menú.
    source ./Scripts/menu.ksh
fi


