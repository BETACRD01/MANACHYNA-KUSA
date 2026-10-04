# 🚀 Infraestructura, Despliegue y CI/CD

Esta guía documenta la infraestructura en la nube, el servidor web y el flujo de integración y entrega continua (CI/CD) automatizado para **MANACHYNA KUSA**.

---

## 🏗️ Arquitectura de Despliegue

```text
               [ Desarrollador ]
                       │
                       │ git push origin main
                       ▼
            [ GitHub Actions CI/CD ]
         (Compilación + Pruebas + SSH)
                       │
                       │ rsync atómico (dist.tgz)
                       ▼
          [ Google Cloud Platform ]
     VM: free-ubuntu-vm (35.225.109.121)
                       │
                       ▼
                  [ Nginx ]
             Puerto 80 / 443 (SSL)
                       │
                       ▼
         [ manachynakusa.duckdns.org ]
```

---

## 🖥️ Servidor en la Nube (Google Cloud VM)

* **Proveedor:** Google Cloud Platform (GCP)
* **Proyecto:** `delivery-109f4`
* **Instancia:** `free-ubuntu-vm`
* **Tipo de máquina:** `e2-micro` (Capa Siempre Gratuita / Always Free Tier)
* **Sistema Operativo:** Ubuntu 22.04 LTS (x86_64)
* **Zona:** `us-central1-a`
* **IP Pública:** **`35.225.109.121`**
* **Directorio de la Web:** `/var/www/manachyna-kusa`

---

## 🌐 Configuración de Servidor Web (Nginx)

El servidor Nginx en la máquina virtual atiende las peticiones del dominio bajo `/etc/nginx/sites-available/manachyna-kusa`:

```nginx
server {
    listen 80;
    server_name manachynakusa.duckdns.org;

    root /var/www/manachyna-kusa;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Caché optimizada para assets estáticos
    location ~* \.(?:css|js|jpg|jpeg|png|gif|ico|svg|webp|woff|woff2|ttf|eot)$ {
        expires 30d;
        add_header Cache-Control "public, max-age=2592000, immutable";
        try_files $uri =404;
    }
}
```

Para recargar Nginx tras cambios manuales:
```bash
sudo nginx -t && sudo systemctl reload nginx
```

---

## 🔒 Certificado SSL / HTTPS (Certbot)

Una vez que el subdominio en DuckDNS apunte a la IP `35.225.109.121`, se genera el certificado SSL con:

```bash
sudo certbot --nginx -d manachynakusa.duckdns.org --non-interactive --agree-tos -m wd1501074@gmail.com
```

---

## ⚡ Pipeline de GitHub Actions (`deploy-frontend.yml`)

El flujo automatizado se encuentra en [`.github/workflows/deploy-frontend.yml`](../../.github/workflows/deploy-frontend.yml) y se activa automáticamente con cada `push` a la rama `main` en la carpeta `frontend/`.

### Características del Pipeline:
1. **Separación en 2 fases (`validate` y `deploy`):**  
   - Primero valida la compilación de TypeScript y empaqueta el artefacto.  
   - Solo si el build es exitoso, procede a la fase de despliegue.
2. **Seguridad SSH con `webfactory/ssh-agent@v0.10.0`:**  
   - Utiliza claves privadas protegidas en los secretos de GitHub (`SSH_PRIVATE_KEY`).  
   - Valida la identidad del servidor contra `SSH_KNOWN_HOSTS`.
3. **Resistencia de Red y Transferencia Atómica:**  
   - Empaqueta el build en un archivo comprimido `tar.tgz`.  
   - Emplea una función de reintentos (`retry`) con 4 intentos en caso de latencia o microcortes de red.
4. **Verificación de Salud:**  
   - Comprueba mediante `curl` que Nginx responda con código `HTTP/1.1 200 OK` antes de marcar el despliegue como exitoso.

### Secretos Configurados en GitHub:
* `SSH_HOST` / `VM_HOST`: `35.225.109.121`
* `SSH_USER` / `VM_USER`: `ubuntu`
* `SSH_PRIVATE_KEY` / `VM_SSH_KEY`: Clave ED25519 privada del servidor.
* `SSH_KNOWN_HOSTS`: Huella criptográfica del servidor.
