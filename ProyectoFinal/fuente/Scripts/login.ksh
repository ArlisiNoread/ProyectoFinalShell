#!/bin/ksh

# Realizamos login

cntIntentos=0
checkUser=""

while ((cntIntentos < 3)); do
    printf "Usuario: "
    read usuario
    old=$(stty -g)
    stty -echo # Silenciamos terminal.
    printf "Contraseña: "
    read contrasena #La pass está escondida
    print ""
    stty "$old" # Lo regresamos a como estaba.
    print "$usuario-$contrasena"
    if [[ ! -z "$usuario" && ! -z "$contrasena" ]]; then
        print "entramos"
        checkUser="$(bd -c "$usuario:$contrasena")"
    fi
    print "$checkUser"
    if [ ! -z "$checkUser" ]; then
        print "############# $chekUser"
        usuario="$checkUser"
        break
    fi
    ((cntIntentos++))
    unset usuario
    unset contrasena
done

if ((cntIntentos >= 3)); then
    print "Apestas, perdedor."
    exit
fi
