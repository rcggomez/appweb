## 🖥️ Despliegue en VirtualBox (Ubuntu 20.04)

Puedes probar esta aplicación en una máquina virtual local usando VirtualBox y Ubuntu 20.04+.

### ✅ Requisitos

- [VirtualBox](https://www.virtualbox.org/)
- Imagen ISO de **Ubuntu Server 20.04+**
- Conexión a Internet
- Usuario con permisos `sudo`

---

### 🧱 Pasos de Instalación

1. **Crear una VM en VirtualBox**
   - Asigna al menos **1 CPU, 1.5 GB de RAM y 10 GB de disco**.
   - Usa la ISO de Ubuntu Server 20.04.
   - Configura la red como **Adaptador puente** o **NAT con redirección de puertos**.

2. **Instalar Ubuntu normalmente**

3. **Conectarte vía terminal o VirtualBox GUI**

4. **Descargar el script de despliegue**

Puedes copiarlo manualmente o descargarlo desde GitHub (reemplaza la URL real de tu script):

```bash
wget https://raw.githubusercontent.com/TU_USUARIO/TU_REPOSITORIO/main/deploy_repositorio.sh

### Permisos y ejecucion
chmod +x deploy_repositorio.sh
./deploy_repositorio.sh

### Acceder al sitio
http://<IP_DE_TU_VM>


