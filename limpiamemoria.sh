#! /bin/bash
echo "AYUDA: El script requiere de sudo para funcionar correctamente."
echo "Limpiando la caché..."
sync; echo 2 > /proc/sys/vm/drop_caches
echo "Memoria liberada."