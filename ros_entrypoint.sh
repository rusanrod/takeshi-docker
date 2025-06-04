#!/bin/bash
# set -e  # Detiene en caso de error

# Cargar variables de entorno desde .env
ENV_FILE="$HOME/.env"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo ".env file not found at $ENV_FILE"
    exit 1
fi

# Validar que se hayan definido las variables
if [[ -z "$ROBOT_IP" || -z "$HOST_IP" ]]; then
    echo "ROBOT_IP or HOST_IP not defined in .env"
    exit 1
fi

# Exportar variables de ROS
export DISABLE_ROS1_EOL_WARNINGS=1
export ROS_MASTER_URI=http://$ROBOT_IP:11311
export ROS_IP=$HOST_IP
export PS1="\[\033[41;1;37m\]<hsrb>\[\033[0m\] \w\$ "

# Mostrar confirmación
echo "ROS_MASTER_URI set to $ROS_MASTER_URI"
echo "ROS_IP set to $ROS_IP"

# Source ROS base
source /opt/ros/noetic/setup.bash

# Hacer source del workspace si existe
if [ -f "$HOME/takeshi_home/catkin_extras/devel/setup.bash" ]; then
    source "$HOME/takeshi_home/catkin_extras/devel/setup.bash"
    echo "Sourced $HOME/takeshi_home/catkin_extras/devel/setup.bash"
else
    echo "No se encontró $HOME/takeshi_home/catkin_extras/devel/setup.bash"
fi

# Ejecutar el comando original (terminator o lo que sea)
if [ "$#" -gt 0 ]; then
    exec "$@"
fi