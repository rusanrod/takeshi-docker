# 🐳 ROS Noetic Docker - HSR Toolkit

Este contenedor Docker portátil está listo para usarse con el robot HSR y cuenta con:

- ROS Noetic completo
- Soporte para CUDA y GUI
- Terminales con **Terminator**
- Alias útiles (`hsrb_mode`, `hsrb_ip`)
- Configuración automática de entorno ROS con `.env`
- Workspace precargado (`catkin_extras`)

---

## 🚀 Instrucciones rápidas

### 1. 📁 Estructura esperada

Asegúrate de tener esta estructura de carpetas en el **host**:

```
.
├── docker/
│   ├── Dockerfile
│   ├── .env             # Lo puedes editar
│   └── source_me.sh     # Script para cargar entorno
└── repos/
    └── catkin_extras/   # Tu workspace ROS personalizado
```

> Si `catkin_extras` no existe aún, clónalo o créalo. Es el workspace ROS que quieres usar.

---

### 2. ⚙️ Edita el archivo `.env`

Este archivo contiene las IPs para conectarte al robot.

```env
# .env
ROBOT_IP=hsrc.local
HOST_IP=192.168.1.100
```

> Puedes editar este archivo desde dentro o fuera del contenedor. Se guarda y persiste.

---

### 3. 🛠 Build del contenedor

Desde la carpeta donde esté tu `docker-compose.yml`:

```bash
docker compose build
```

---

### 4. 🧩 Corre el contenedor

```bash
docker compose up
```

> Se abrirá una terminal gráfica con **Terminator**.

---

### 5. 🧪 Carga el entorno ROS

Una vez dentro del contenedor, ejecuta:

```bash
source ~/source_me.sh
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