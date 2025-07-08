Proyecto: Repositorio Web Simple con PHP, Nginx y MariaDB

Este proyecto implementa una aplicación web sencilla que permite a los usuarios subir y descargar archivos, asociando cada archivo con un usuario. Utiliza PHP para la lógica de negocio, MariaDB para la base de datos y Nginx como servidor web y proxy.

Características

Interfaz web para subida y descarga de archivos.

Archivos almacenados en el sistema de archivos por usuario.

Relación entre usuarios y archivos en base de datos.

Backend en PHP con servidor embebido.

Nginx configurado como frontend que enruta a PHP.

Tecnologías

Ubuntu 20.04+

PHP 7.4+

MariaDB 10.3+

Nginx

Bash Script

Estructura del Proyecto

.
├── deploy_repositorio.sh        # Script de instalación y despliegue completo
└── README.md                    # Documentación del proyecto

Instalación (local o VM)

Clona este repositorio o descarga el archivo deploy_repositorio.sh.

Cópialo a una máquina Ubuntu 20.04+ (física, VM o EC2).

chmod +x deploy_repositorio.sh
./deploy_repositorio.sh

Una vez finalizado, accede desde tu navegador a http://<IP-DE-TU-SERVIDOR>.

Funcionalidad

Subir archivo:

Usuario ingresa su nombre y selecciona un archivo.

Se crea una carpeta para el usuario si no existe.

El archivo se guarda y se registra en la base de datos.

Descargar archivo:

El usuario ingresa su nombre y el nombre del archivo.

El sistema busca el archivo en su carpeta y lo entrega para descarga.

Base de Datos

CREATE DATABASE repo;
CREATE USER 'repo_user'@'localhost' IDENTIFIED BY 'repo_pass';
GRANT ALL PRIVILEGES ON repo.* TO 'repo_user'@'localhost';

USE repo;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE
);

CREATE TABLE files (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    filename VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

Seguridad

Este proyecto es una prueba de concepto (PoC) y no implementa controles de autenticación, autorización ni validaciones de seguridad. No usar en producción sin fortificar.

Requisitos Previos

Acceso sudo

Conexión a Internet

Ubuntu 20.04+ limpio o equivalente

Si deseas subir el proyecto a GitHub desde Windows:

Instala Git para Windows:

Descarga desde: https://git-scm.com/download/win

Sigue el instalador y acepta las opciones por defecto.

Verifica la instalación desde PowerShell o CMD:

git --version

Deberías ver algo como git version 2.x.x

Inicializa y sube tu repositorio a GitHub:

git init
git add .
git commit -m "Primer commit"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/TU_REPOSITORIO.git
git push -u origin main

Diagrama de Arquitectura
