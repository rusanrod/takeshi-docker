#!/bin/bash

# Cargar variables de entorno desde .env
ENV_FILE="$HOME/.env"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo ".env file not found at $ENV_FILE"
    return 1
fi

# Validar que se hayan definido las variables
if [[ -z "$ROBOT_IP" || -z "$HOST_IP" ]]; then
    echo "ROBOT_IP or HOST_IP not defined in .env"
    return 1
fi

# Exportar variables ROS
export DISABLE_ROS1_EOL_WARNINGS=1
export ROS_MASTER_URI=http://$ROBOT_IP:11311
export ROS_IP=$HOST_IP
echo "ROS_MASTER_URI set to $ROS_MASTER_URI"
echo "ROS_IP set to $ROS_IP"
export PS1="\[\033[41;1;37m\]<hsrb>\[\033[0m\] \w\$ "

# Hacer source del catkin workspace
if [ -f ~/catkin_extras/devel/setup.bash ]; then
    source ~/catkin_extras/devel/setup.bash
    echo "Sourced ~/catkin_extras/devel/setup.bash"
else
    echo "No se encontró ~/catkin_extras/devel/setup.bash"
    return 1
fi
