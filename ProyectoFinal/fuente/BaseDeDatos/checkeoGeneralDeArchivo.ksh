#!/bin/ksh
#
#
#


if [[ -z $1 ]]; then
    print "Ingrese archivo a analizar."
    exit 1
fi

nombreArchivo="$1"

if [[ ! -e "$nombreArchivo" ]]; then
    print "Archivo $nombreArchivo no fue encontrado. Creando archivo nuevo."
    touch "$nombreArchivo"
    exit 0    
fi

if [[ ! -f "$nombreArchivo" ]]; then
    print "Error: $nombreArchivo no es un file común."
    exit 1
fi

if [[ ! -f "$nombreArchivo" ]]; then
    print "Error: $nombreArchivo no es un file común."
    exit 1
fi

if [[ ! -s "$nombreArchivo" ]]; then
    print "Archivo $nombreArchivo vacío."
    exit 0
fi

if [[ ! -r "$nombreArchivo" ]]; then
    print "Archivo $nombreArchivo no tiene permisos de lectura."
    exit 1
fi

if [[ ! -w "$nombreArchivo" ]]; then
    print "Archivo $nombreArchivo no tiene permisos de escritura."
    return 1
fi
