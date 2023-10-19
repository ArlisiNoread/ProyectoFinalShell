#!/bin/ksh

# Realizamos login

cntIntentos=0
checkUser=""


while ((cntIntentos < 3))
do
    printf "Usuario: "; read usuario
    printf "Contraseña: "; read -s contrasena #La pass está escondida
    checkUser="$(bd -c "$usuario:$contrasena")"
    if [ ! -z "$checkUser" ];then
        usuario="$checkUser"
        break
    fi

done

if (( cntIntentos >= 3 )); then
    print "Apestas, perdedor."
    exit
fi