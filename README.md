# Jokin Hub

Portal de acceso a 12 aplicaciones, organizadas por áreas y categorías, incluido el portal de la Fundación Española de Enfermedades Priónicas (FEEP). Las aplicaciones se abren en una pestaña nueva desde sus enlaces directos.

## Diseño

Interfaz clara con contraste suave con tarjetas amplias, iconos destacados y distribución adaptable a móviles. Las categorías de investigación clínica se abren con el ratón o el teclado.

## Despliegue en Railway

Conecta este repositorio a un servicio de Railway. El Dockerfile sirve la carpeta site con Nginx y start.sh configura el puerto mediante la variable PORT que proporciona Railway. railway.json define la construcción y la política de reinicio.

## Estructura

- site/index.html: tarjetas, categorías y comportamiento de la página.
- site/style.css: estilos y adaptación a pantallas pequeñas.
- site/favicon.svg: icono del portal.
- Dockerfile y start.sh: servidor de archivos estáticos.
- railway.json: configuración del despliegue.

## Añadir una herramienta

Añade un enlace con la clase card a la cuadrícula de su grupo en site/index.html, con icono, título, descripción y URL. Si creas una categoría, añade su botón y el panel con un identificador único.

El arrastre existente se mantiene en las tarjetas que ya lo admitían. La incorporación de tiradores de seis puntos queda pendiente para la siguiente fase.
