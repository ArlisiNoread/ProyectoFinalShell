#!/bin/ksh

# Realizamos login

cntIntentos=0
checkUser=""

clear

while ((cntIntentos < 3)); do
    printf "Sistema Login" #presentación

    if [ ! -z "$loginFallido" ]; then
        easyTput colortexto rojo
        printf "\tCredenciales inválidas"
        easyTput reset
    fi

    print ""
    print ""

    printf "Usuario: "
    read usuario
    old=$(stty -g)
    stty -echo # Silenciamos terminal.
    printf "Contraseña: "
    read contrasena #La pass está escondida
    print ""
    stty "$old" # Lo regresamos a como estaba.
    if [[ ! -z "$usuario" && ! -z "$contrasena" ]]; then
        #Realizamos login
        checkUser="$(bd -l "$usuario:$contrasena")"
    fi
    if [ ! -z "$checkUser" ]; then
        usuario="$checkUser"
        break
    else
        loginFallido=true
    fi
    ((cntIntentos++))
    clear
    unset usuario
    unset contrasena
done

if ((cntIntentos >= 3)); then
    print "Apestas, perdedor."
    exit
fi
