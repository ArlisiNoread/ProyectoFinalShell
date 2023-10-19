#!/bin/ksh

#Uso este script para probar libs

export FPATH="$(pwd)/../../lib"
autoload easyTput

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


