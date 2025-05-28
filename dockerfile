FROM nvidia/cuda:12.1.1-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive \
    ROS_DISTRO=noetic \
    ROS_VERSION=1 \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=all \
    LANG=C.UTF-8 LC_ALL=C.UTF-8

# -------------------------------
# Dependencias base
# -------------------------------
RUN rm -f /etc/apt/sources.list.d/cuda*.list /etc/apt/sources.list.d/nvidia-ml.list

RUN apt-get update && apt-get install -y \
    wget curl sudo nano git python3-pip python3-dev terminator \
    pulseaudio portaudio19-dev  libpulse-dev \
    x11-xserver-utils libx11-dev dbus-x11 \
    libgl1-mesa-glx libgl1-mesa-dri \
    iproute2 iputils-ping net-tools \
    lsb-release gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# -------------------------------
# Usuario
# -------------------------------
ARG USERNAME=takeshi
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd -g $USER_GID $USERNAME && \
    useradd -m -u $USER_UID -g $USER_GID -s /bin/bash $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME

# -------------------------------
# ROS Noetic
# -------------------------------
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt-get update && apt-get install -y ros-noetic-desktop-full

RUN echo "source /opt/ros/noetic/setup.bash" >> /home/$USERNAME/.bashrc

RUN apt-get install -y \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    build-essential
    
RUN rosdep init && rosdep update

# -------------------------------
# Paquetes HSR
# -------------------------------
RUN sh -c 'echo "deb [arch=amd64] https://hsr-user:jD3k4G2e@packages.hsr.io/ros/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/tmc.list'
RUN sh -c 'echo "deb [arch=amd64] https://hsr-user:jD3k4G2e@packages.hsr.io/tmc/ubuntu `lsb_release -cs` multiverse main" >> /etc/apt/sources.list.d/tmc.list'
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget https://hsr-user:jD3k4G2e@packages.hsr.io/tmc.key -O - | apt-key add -
RUN wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc -O - | apt-key add -
RUN wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN sh -c 'mkdir -p /etc/apt/auth.conf.d'
RUN sh -c '/bin/echo -e "machine packages.hsr.io\nlogin hsr-user\npassword jD3k4G2e" >/etc/apt/auth.conf.d/auth.conf'
RUN sh -c '/bin/echo -e "Package: ros-noetic-laser-ortho-projector\nPin: version 0.3.3*\nPin-Priority: 1001\n\nPackage: ros-noetic-laser-scan-matcher\nPin: version 0.3.3*\nPin-Priority: 1001\n\nPackage: ros-noetic-laser-scan-sparsifier\nPin: version 0.3.3*\nPin-Priority: 1001\n\nPackage: ros-noetic-laser-scan-splitter\nPin: version 0.3.3*\nPin-Priority: 1001\n\nPackage: ros-noetic-ncd-parser\nPin: version 0.3.3*\nPin-Priority: 1001\n\nPackage: ros-noetic-polar-scan-matcher\nPin: version 0.3.3*\nPin-Priority: 1001\n\nPackage: ros-noetic-scan-to-cloud-converter\nPin: version 0.3.3*\nPin-Priority: 1001\n\nPackage: ros-noetic-scan-tools\nPin: version 0.3.3*\nPin-Priority: 1001" > /etc/apt/preferences'
RUN apt-get update
RUN apt-get install -y --no-install-recommends ros-noetic-tmc-desktop-full \
    && rm -rf /var/lib/apt/lists/*

# -------------------------------
# Python Packages
# -------------------------------
    RUN pip3 install --no-cache-dir \
    rosnumpy opencv-python numpy==1.23.5 rospkg setuptools \
    pyaudio scipy vosk sounddevice spacy==3.7.4 jinja2==3.0.3 \
    torch torchvision torchaudio transformers==4.40.0

# -------------------------------
# Alias y entorno
# -------------------------------
# RUN echo 'alias hsrc_mode="export ROS_MASTER_URI=http://hsrc.local:11311; export PS1=\"\[\033[41;1;37m\]<hsrb>\[\033[0m\]\w$ \""' >> /home/$USERNAME/.bashrc && \
#     echo "alias hsrc_ip='export ROS_IP=192.168.11.220'" >> /home/$USERNAME/.bashrc && \
#     echo "alias et='hsrc_mode;hsrc_ip'" >> /home/$USERNAME/.bashrc

# -------------------------------
# Instalar paquetes adicionales de ROS
# -------------------------------
RUN apt-get update && apt-get install -y \
    ros-noetic-graph-msgs \
    ros-noetic-random-numbers \
    ros-noetic-tf2-sensor-msgs \
    ros-noetic-moveit \
    && rm -rf /var/lib/apt/lists/*

# -------------------------------
# Permisos finales
# -------------------------------
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME


RUN mkdir -p /home/$USERNAME/.config/terminator && \
echo "[global_config]\ntitle_transmit_bg_color = \"#d30102\"\n[keybindings]\n[layouts]\n  [[default]]\n    [[[child1]]]\n      type = Terminal\n      parent = window0\n    [[[window0]]]\n      type = Window\n      parent = \"\"\n[plugins]" \
> /home/$USERNAME/.config/terminator/config && \
chown -R $USERNAME:$USERNAME /home/$USERNAME/.config

# Copiar archivos al contenedor
COPY .env /home/$USERNAME/.env
COPY source_me.sh /home/$USERNAME/source_me.sh

# Dar permisos
RUN chmod +x /home/$USERNAME/source_me.sh && \
chown $USERNAME:$USERNAME /home/$USERNAME/.env /home/$USERNAME/source_me.sh

USER $USERNAME
WORKDIR /home/$USERNAME

CMD ["/usr/bin/terminator"]
