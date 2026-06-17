# Jokin Hub

Reverse proxy centralizado que expone 14 aplicaciones del laboratorio bajo un único dominio Railway, ocultando por completo las URLs `*.up.railway.app` individuales.

---

## Despliegue en Railway (3 pasos)

1. **Conecta el repositorio** en Railway → *New Project → Deploy from GitHub repo* → selecciona `Jokin1969/jokin-hub`.
2. **Define las 14 variables de entorno** en *Settings → Variables* (tabla completa abajo).
3. **Asigna un dominio personalizado** en *Settings → Networking* (o usa el dominio `.up.railway.app` que Railway genera para este servicio).

Railway detectará el `Dockerfile` y construirá la imagen automáticamente. El `railway.json` ya configura el builder y la política de reinicio.

---

## Variables de entorno

| Variable | Valor (sin `https://`) |
|---|---|
| `RESEARCH_TOOLS_URL` | `research-tools-production.up.railway.app` |
| `ANTIBUROCRATA_URL` | `rincon-antiburocrata-production.up.railway.app` |
| `BROCHURES_URL` | `brochures-production-5c8c.up.railway.app` |
| `PRION_SURVEY_URL` | `server-production-b16f.up.railway.app` |
| `PRIOCOHORT_URL` | `priocohort-ci-production.up.railway.app` |
| `JOKIN_TOOLS_URL` | `jokins-tools-production.up.railway.app` |
| `CERTIFICADOS_URL` | `generador-certificados-production-ac44.up.railway.app` |
| `TXPR_URL` | `txpr-databases-production.up.railway.app` |
| `PRIONLAB_URL` | `web-production-5517e.up.railway.app` |
| `DNI_URL` | `dni-production.up.railway.app` |
| `WHATSAPP_FEEP_URL` | `whatsapp-feep-production.up.railway.app` |
| `ACTPRION_URL` | `cuestionario-prionico-production.up.railway.app` |
| `CLINICAL_SCALES_URL` | `clinical-rating-scales-production.up.railway.app` |
| `DONATION_URL` | `donation-instructions-production.up.railway.app` |

> Caddy elimina el prefijo de ruta antes de hacer el proxy (gracias a `handle_path`), así que el upstream recibe la petición **sin** el slug. Cada app interna debe estar preparada para servirse bajo su subpath (ver sección siguiente).

---

## Adaptar las apps internas al subpath

Caddy hace `strip-prefix` antes de reenviar, de modo que `/research/foo` llega al upstream como `/foo`. Sin embargo, **los assets y los redirects que genera la app deben incluir el prefijo**. Configuración recomendada por tecnología:

### Flask / Werkzeug
```python
from werkzeug.middleware.proxy_fix import ProxyFix

app.wsgi_app = ProxyFix(app.wsgi_app, x_prefix=1)

# Opción A — variable de entorno
app.config["APPLICATION_ROOT"] = "/research"

# Opción B — blueprint con url_prefix
bp = Blueprint("research", __name__, url_prefix="/research")
```

### Streamlit
Añade en el comando de arranque:
```
streamlit run app.py --server.baseUrlPath=/tools
```
O en `.streamlit/config.toml`:
```toml
[server]
baseUrlPath = "/tools"
```

### React / Vite (SPA)
En `vite.config.js`:
```js
export default defineConfig({ base: '/prionlab/' })
```
En el router (React Router v6):
```jsx
<BrowserRouter basename="/prionlab">
```

### Ficheros estáticos puros (HTML/CSS/JS)
Usa **rutas relativas** (`./style.css`, `./app.js`) en lugar de absolutas (`/style.css`), ya que el navegador resolverá los assets desde el subpath correcto.

### Next.js
En `next.config.js`:
```js
module.exports = { basePath: '/certificados' }
```

---

## Añadir una nueva herramienta

1. **Variable de entorno**: añade `NUEVA_APP_URL=nueva-app-production.up.railway.app` en Railway.
2. **Bloque en `Caddyfile`**:
   ```caddy
   handle_path /nueva-app/* {
       reverse_proxy {$NUEVA_APP_URL} {
           header_up Host {upstream_hostport}
       }
   }
   ```
3. **Tarjeta en `site/index.html`**: copia cualquier `<a class="card">` existente y ajusta título, descripción y ruta.
4. Haz commit y push — Railway redespliega automáticamente.

---

## Estructura del repositorio

```
Caddyfile          Configuración del reverse proxy
Dockerfile         Imagen caddy:2-alpine con Caddyfile + site/
railway.json       Build & deploy config para Railway
site/
  index.html       Landing con grid de herramientas
  style.css        Diseño responsive dark-mode
README.md          Este archivo
```
