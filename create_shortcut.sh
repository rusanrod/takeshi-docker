#!/bin/bash

# ----------------------
# CONFIGURACIÓN
# ----------------------
SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
DIR="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
BINDING="<Shift><Alt>d"
NAME="Abrir Terminator ROS"
COMMAND="gnome-terminal -- bash -lc 'docker exec -it ros_noetic terminator'"

# ----------------------
# OBTENER LISTA ACTUAL
# ----------------------
current=$(gsettings get $SCHEMA custom-keybindings | sed -e "s/^@as \[//" -e "s/\]$//" -e "s/, /,/g" | tr -d "'")
IFS=',' read -ra entries <<< "$current"

# ----------------------
# BUSCAR EXISTENTE CON ESA TECLA
# ----------------------
found=false
for entry in "${entries[@]}"; do
    keypath="${entry}/"
    keybind=$(gsettings get "$SCHEMA.custom-keybinding:$keypath" binding 2>/dev/null | tr -d "'")
    if [[ "$keybind" == "$BINDING" ]]; then
        echo "🔁 Sobrescribiendo shortcut existente en $keypath"
        gsettings set "$SCHEMA.custom-keybinding:$keypath" name "$NAME"
        gsettings set "$SCHEMA.custom-keybinding:$keypath" command "$COMMAND"
        gsettings set "$SCHEMA.custom-keybinding:$keypath" binding "$BINDING"
        found=true
        break
    fi
done

# ----------------------
# SI NO EXISTÍA, AGREGAR UNO NUEVO
# ----------------------
if [ "$found" = false ]; then
    index=${#entries[@]}
    keyname="custom$index"
    keypath="$DIR/$keyname/"
    echo "➕ Creando nuevo shortcut en $keypath"

    # Agregar a la lista
    if [ -z "$current" ]; then
        newlist="['$keypath']"
    else
        newlist="[$(printf "'%s'," "${entries[@]}")'$keypath']"
    fi
    gsettings set $SCHEMA custom-keybindings "$newlist"

    # Configurar propiedades
    gsettings set "$SCHEMA.custom-keybinding:$keypath" name "$NAME"
    gsettings set "$SCHEMA.custom-keybinding:$keypath" command "$COMMAND"
    gsettings set "$SCHEMA.custom-keybinding:$keypath" binding "$BINDING"
fi

echo "✅ Shortcut activo: $BINDING → $COMMAND"
