#!/bin/bash
set -e

echo "[+] Actualizando paquetes..."
sudo apt update && sudo apt upgrade -y

echo "[+] Instalando NGINX, PHP, MariaDB..."
sudo apt install -y nginx php php-mysql mariadb-server unzip

echo "[+] Habilitando servicios..."
sudo systemctl enable --now nginx
sudo systemctl enable --now mariadb

echo "[+] Configurando base de datos..."
sudo mysql -e "CREATE DATABASE IF NOT EXISTS repo;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'repo_user'@'localhost' IDENTIFIED BY 'repo_pass';"
sudo mysql -e "GRANT ALL PRIVILEGES ON repo.* TO 'repo_user'@'localhost'; FLUSH PRIVILEGES;"
sudo mysql repo -e "CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50));"
sudo mysql repo -e "CREATE TABLE IF NOT EXISTS files (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT, filename VARCHAR(255));"

echo "[+] Preparando directorios..."
sudo mkdir -p /opt/app /opt/uploads
sudo chmod -R 777 /opt/uploads

echo "[+] Creando archivo upload.php..."
cat <<EOF | sudo tee /opt/app/upload.php > /dev/null
<?php
\$conn = new mysqli("localhost", "repo_user", "repo_pass", "repo");
if (\$conn->connect_error) die("DB error");

\$username = \$_POST['username'];
\$conn->query("INSERT IGNORE INTO users (username) VALUES ('\$username')");
\$userid = \$conn->query("SELECT id FROM users WHERE username='\$username'")->fetch_assoc()['id'];

\$dir = "/opt/uploads/\$username";
if (!is_dir(\$dir)) mkdir(\$dir, 0777, true);
\$dest = "\$dir/" . basename(\$_FILES["archivo"]["name"]);
move_uploaded_file(\$_FILES["archivo"]["tmp_name"], \$dest);

\$conn->query("INSERT INTO files (user_id, filename) VALUES (\$userid, '".basename(\$dest)."')");
echo "Archivo subido correctamente.";
?>
EOF

echo "[+] Creando archivo download.php..."
cat <<EOF | sudo tee /opt/app/download.php > /dev/null
<?php
\$username = \$_GET['username'];
\$filename = \$_GET['filename'];
\$filepath = "/opt/uploads/\$username/\$filename";
if (file_exists(\$filepath)) {
    header('Content-Description: File Transfer');
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="'.basename(\$filepath).'"');
    readfile(\$filepath);
    exit;
} else {
    echo "Archivo no encontrado.";
}
?>
EOF

echo "[+] Iniciando servidor PHP..."
nohup php -S 0.0.0.0:8080 -t /opt/app > /dev/null 2>&1 &

echo "[+] Creando frontend HTML..."
cat <<EOF | sudo tee /var/www/html/index.html > /dev/null
<!DOCTYPE html>
<html>
<head><title>Repositorio</title></head>
<body>
<h2>Subir archivo</h2>
<form action="/upload" method="post" enctype="multipart/form-data">
  Usuario: <input type="text" name="username" required><br>
  Archivo: <input type="file" name="archivo" required><br>
  <input type="submit" value="Subir">
</form>

<h2>Descargar archivo</h2>
<form action="/download" method="get">
  Usuario: <input type="text" name="username" required><br>
  Archivo: <input type="text" name="filename" required><br>
  <input type="submit" value="Descargar">
</form>
</body>
</html>
EOF

echo "[+] Configurando NGINX..."
cat <<CONF | sudo tee /etc/nginx/sites-available/default > /dev/null
server {
    listen 80;
    root /var/www/html;
    index index.html;

    location /upload {
        proxy_pass http://127.0.0.1:8080/upload.php;
    }

    location /download {
        proxy_pass http://127.0.0.1:8080/download.php;
    }
}
CONF

sudo systemctl reload nginx
echo "[✓] Despliegue completado. Accede vía navegador a http://<IP-DEL-SERVIDOR>"
