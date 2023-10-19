#!/bin/ksh

#Uso este script para probar libs

print $0
#if [ -z "$main" ]; then
if [ "$0" =~ ^*test.ksh$ ]; then
    print "Check"
    export FPATH="$(pwd)/../../lib"
    autoload easyTput
fi

print "Esta es una prueba."

easyTput negritas

print "Esta es una prueba en negritas."

easyTput subrayado

print "Esta es una prueba de subrayado."

easyTput reset

print "Regreso todo a lo normal"

easyTput colortexto rojo

print "Esto es una prueba de texto rojo"

easyTput colortexto verde

print "Esto es una prueba de texto verde"

printf "VIVA "

easyTput colortexto blanco

printf "MÉXICO "

easyTput colortexto rojo

printf "CABRONES\n"

easyTput colortexto blanco
easyTput colorfondo magenta

printf "Ejemplo color fondo magenta"

easyTput reset

printf "\n"

easyTput debil

print "Ejemplo con texto debil"

easyTput reset
