#!/bin/ksh


# Inicializar variables
total=0
productos=""

# Función para agregar productos
agregar_producto() {
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
    echo "=== Punto de Venta ==="
    echo "1. Agregar producto"
    echo "2. Mostrar total"
    echo "3. Salir"
    echo "======================"
    echo "Total: \$$total"
    echo "Productos: $productos"
    echo "======================"
    echo "Seleccione una opción:"
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
