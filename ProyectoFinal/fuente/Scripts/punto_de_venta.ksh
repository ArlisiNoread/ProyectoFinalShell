#!/bin/ksh


# Inicializar variables
total=0
productos=""

# Función para agregar productos
function agregar_producto {
    echo "Ingrese el nombre del producto:"
    read nombre
    echo "Ingrese el precio del producto:"
    read precio
    productos="$productos$nombre (\$$precio) "
    total=$((total + precio))
}


# Menú principal
while true; do
    clear
    printf "\t\t === Punto de Venta === \n"
    printf "\t 1. Agregar producto \n"
    printf "\t 2. Mostrar total \n"
    printf "\t 3. Salir \n"
    printf "\t ======================\n"
    printf "\t Total: \$$total \n"
    printf "\t Productos: $productos \n"
    printf "\t ====================== \n"



    for file in articulos.txt insumos.txt
    do
        awk '{for (i = 1; i <= NF; i++) $i = sprintf("%-20s", $i)} 1' "$file"
    done




   # awk '{for (i = 1; i <= NF; i++) $i = sprintf("%-20s", $i)} 1' prueba.txt, articulos.txt
    print -n "Seleccione una opción:"
    read opcion





    case $opcion in
        1)
            agregar_producto
            ;;
        2)
            echo "Total de la venta: \$$total"
            echo "Productos: $productos"

            read salida

            ;;
        3)
            echo "Gracias por su compra. Hasta luego."
            exit 0
            ;;
        *)
            echo "Opción no válida. Intente de nuevo."
            read -p "Presione Enter para continuar..."
            ;;
    esac
done








