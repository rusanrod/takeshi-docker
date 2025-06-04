# 🐳 ROS Noetic Docker - HSR Toolkit

Este contenedor Docker portátil está listo para usarse con el robot HSR y cuenta con:

- ROS Noetic completo
- Soporte para CUDA y GUI
- Terminales con **Terminator**
- Configuración automática de entorno ROS desde `.env`
- Workspace precargado (`catkin_extras`)
- Layout visual con 4 paneles configurados automáticamente

---

## 🚀 Instrucciones rápidas

### 1. 📁 Estructura esperada

Asegúrate de tener esta estructura de carpetas en el **host**:

```
.
|
└── takeshi_home/        # En el home de tu PC
    └── catkin_extras/   # Tu workspace ROS personalizado
```

> Si `catkin_extras` no existe aún, clónalo o créalo. Es el workspace ROS que quieres usar.

---

### 2. ⚙️ Edita el archivo `.env`

Este archivo contiene las IPs para conectarte al robot.

```env
# .env
ROBOT_IP=192.168.11.220 <----Es la IP del Robot1
HOST_IP=192.168.1.100<---- Es la IP de tu PC
```

> Modifica este archivo antes de compilar el contenedor.

---

### 3. 🛠 Build del contenedor

Desde la carpeta donde esté el `docker-compose.yml`:

```bash
docker compose build
```

---

### 4. 🧩 Corre el contenedor

```bash
docker compose up -d
```

> Se abrirá una terminal gráfica con **Terminator**.

---

### 5. 🧪 Carga el entorno ROS

Una vez dentro del contenedor, se ejecuta automaticamente:

```bash
source /ros_entrypoint.sh
```

Esto hará:

- `source` del workspace `catkin_extras`
- Exportará `ROS_MASTER_URI` y `ROS_IP` según `.env`
- Mostrará un prompt personalizado: `<hsrb> ~/ruta$`

---

## 🧠 Tips

- Puedes modificar `.env` en cualquier momento.
- El prompt te indica que estás en entorno del HSR.
- Usa Terminator para múltiples paneles.