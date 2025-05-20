
</head>
<body>
<h1>ETL para la carga de <em>datasets</em> de Turismo Internacional en Argentina</h1>
<div style="display: flex; gap: 10px; font-family: sans-serif;">
  <a href="https://www.docker.com/" target="_blank" style="text-decoration: none;">
    <div style="background-color:#2496ed; color:white; padding:10px 16px; border-radius:6px; display:flex; align-items:center; gap:8px;">
      🐳 <strong>DOCKER</strong>
    </div>
  </a>
  
  <a href="https://www.postgresql.org/" target="_blank" style="text-decoration: none;">
    <div style="background-color:#336791; color:white; padding:10px 16px; border-radius:6px; display:flex; align-items:center; gap:8px;">
      🐘 <strong>POSTGRESQL</strong>
    </div>
  </a>

  <a href="https://superset.apache.org/" target="_blank" style="text-decoration: none;">
    <div style="background-color:#f44336; color:white; padding:10px 16px; border-radius:6px; display:flex; align-items:center; gap:8px;">
      🔗 <strong>APACHE SUPERSET</strong>
    </div>
  </a>

  <a href="https://www.pgadmin.org/" target="_blank" style="text-decoration: none;">
    <div style="background-color:#4479A1; color:white; padding:10px 16px; border-radius:6px; display:flex; align-items:center; gap:8px;">
      🐘 <strong>PGADMIN</strong>
    </div>
  </a>
</div>
<h2>Descarga de Datasets</h2>
  <p>Los datasets utilizados en este proyecto pueden descargarse desde el portal oficial de datos abiertos del Gobierno de Argentina:<br>
    <a href="https://datos.gob.ar/dataset/turismo-turismo-internacional---total-pais" target="_blank">https://datos.gob.ar/dataset/turismo-turismo-internacional---total-pais</a>
  </p>
  <p>Este portal proporciona información pública en formatos reutilizables, incluyendo datos relacionados con el Turismo Internacional - Total País en Argentina.</p>
    <h2>Resumen del Tutorial</h2>
  <p>Este tutorial guía al usuario a través de los pasos necesarios para desplegar una infraestructura ETL utilizando Docker, PostgreSQL, Apache Superset y pgAdmin. Se incluyen instrucciones detalladas para:</p>
  <ul>
    <li>Levantar los servicios con Docker.</li>
    <li>Configurar la conexión a la base de datos en Apache Superset.</li>
    <li>Ejecutar consultas SQL para analizar los datos de Turismo Internacional - Total País en Argentina.</li>
    <li>Crear gráficos y tableros interactivos para la visualización de datos.</li>
  </ul>
  
 <h2>Palabras Clave</h2>
<ul>
  <li>Docker</li>
  <li>PostgreSQL</li>
  <li>Apache Superset</li>
  <li>pgAdmin</li>
  <li>ETL</li>
  <li>Visualización de Datos</li>
</ul>
  <h2>Mantenido Por</h2>
  <p>Grupo 8 - Cátedra Base de Datos 2025</p>
  <h2>Descargo de Responsabilidad</h2>
  <p>El código proporcionado se ofrece "tal cual", sin garantía de ningún tipo, expresa o implícita. En ningún caso los autores o titulares de derechos de autor serán responsables de cualquier reclamo, daño u otra responsabilidad.</p>
  <h2>Descripción del Proyecto</h2>
  <p>Este proyecto implementa un proceso ETL (Extract, Transform, Load) para la carga y análisis de datos relacionados con datos del turismo internacional - Total país en Argentina. Utiliza herramientas modernas como Docker, PostgreSQL, Apache Superset y pgAdmin para facilitar la gestión, análisis y visualización de datos.</p>
   <p>Desarrollar una solución escalable y reproducible para analizar el turismo internacional - Total país en Argentina, permitiendo la exploración dinámica de datos por país de origen y país destino donde tenemos tipos de transportes, balanzas, períodos temporales y diferentes tipos de visitantes, con el fin de generar tableros interactivos y gráficos personalizados que apoyen la toma de decisiones en el sector turístico.
</p>
 <h2>Características Principales</h2>
<ul>
  <li><strong>Infraestructura Contenerizada:</strong> Uso de Docker para simplificar la configuración y despliegue.</li>
  <li><strong>Base de Datos Relacional:</strong> PostgreSQL para almacenar y gestionar los datos.</li>
  <li><strong>Visualización de Datos:</strong> Apache Superset para crear gráficos y tableros interactivos.</li>
  <li><strong>Gestión de Base de Datos:</strong> pgAdmin para administrar y consultar la base de datos.</li>
</ul>
<h2>Requisitos Previos</h2>
<p>Antes de comenzar, asegúrate de tener instalados los siguientes componentes:</p>
<ul>
  <li><a href="https://www.docker.com/" target="_blank">Docker</a></li>
  <li><a href="https://docs.docker.com/compose/" target="_blank">Docker Compose</a></li>
  <li>Navegador web para acceder a Apache Superset y pgAdmin.</li>
</ul>
<h2>Servicios Definidos en Docker Compose</h2>
<p>El archivo <code>docker-compose.yml</code> define los siguientes servicios:</p>
<h2>Servicios Definidos en Docker Compose</h2>
<p>El archivo <code>docker-compose.yml</code> define los siguientes servicios:</p>

<ol>
  <li><strong>Base de Datos (PostgreSQL):</strong></li>
</ol>
  <pre><code>networks:
  net:
    external: false

volumes:
  postgres-db:
    external: false

services:
  db:
    image: postgres:alpine
    env_file:
      - .env.db
    restart: unless-stopped
    environment:
      - POSTGRES_INITDB_ARGS=--auth-host=md5 --auth-local=trust
    healthcheck:
      test: [ "CMD-SHELL", "pg_isready" ]
      interval: 10s
      timeout: 2s
      retries: 5
    ports:
      - 5432:5432
    volumes:
      - postgres-db:/var/lib/postgresql/data
      - ./scripts:/docker-entrypoint-initdb.d
      - ./DATOS:/DATOS
    networks:
      - net
  </code></pre>

<ol start="2">
  <li><strong>Apache Superset:</strong></li>
</ol>
  <pre><code>image: apache/superset:4.0.0
restart: unless-stopped
env_file:
  - .env.db
ports:
  - 8088:8088
depends_on:
  db:
    condition: service_healthy
networks:
  - net
  </code></pre>

<ol start="3">
  <li><strong>pgAdmin:</strong></li>
</ol>
  <pre><code>image: dpage/pgadmin4
restart: unless-stopped
env_file:
  - .env.db
ports:
  - 5050:80
depends_on:
  db:
    condition: service_healthy
networks:
  - net
  </code></pre>

<h2>Instrucciones de Configuración</h2>
<ol>
  <li><strong>Clonar el repositorio:</strong></li>
</ol>
  <pre><code>git clone &lt;URL_DEL_REPOSITORIO&gt;
cd ETL-Turismo
  </code></pre>
<ol start="2">
  <li><strong>Configurar el archivo <code>.env.db</code>:</strong> Crea un archivo <code>.env.db</code> en la raíz del proyecto con las siguientes variables de entorno:</li>
</ol>
  <pre><code><span style="color:#999">#Definimos cada variable</span>
<span style="color:#f08d49">DATABASE_HOST</span>=<span style="color:#ccc">db</span>
<span style="color:#f08d49">DATABASE_PORT</span>=<span style="color:#ccc">5432</span>
<span style="color:#f08d49">DATABASE_NAME</span>=<span style="color:#ccc">postgres</span>
<span style="color:#f08d49">DATABASE_USER</span>=<span style="color:#ccc">postgres</span>
<span style="color:#f08d49">DATABASE_PASSWORD</span>=<span style="color:#ccc">postgres</span>
<span style="color:#f08d49">POSTGRES_INITDB_ARGS</span>=<span style="color:#6ab0f3">"--auth-host=scram-sha-256 --auth-local=trust"</span>
<span style="color:#999"># Configuración para inicializar postgres</span>
<span style="color:#f08d49">POSTGRES_PASSWORD</span>=<span style="color:#6ab0f3">${DATABASE_PASSWORD}</span>
<span style="color:#f08d49">PGUSER</span>=<span style="color:#6ab0f3">${DATABASE_USER}</span>
<span style="color:#999"># Configuración para inicializar pgadmin</span>
<span style="color:#f08d49">PGADMIN_DEFAULT_EMAIL</span>=<span style="color:#6ab0f3">postgres@postgresql.com</span>
<span style="color:#f08d49">PGADMIN_DEFAULT_PASSWORD</span>=<span style="color:#6ab0f3">${DATABASE_PASSWORD}</span>
<span style="color:#999"># Configuración para inicializar superset</span>
<span style="color:#f08d49">SUPERSET_SECRET_KEY</span>=<span style="color:#6ab0f3">your_secret_key_here</span>
  </code></pre>
<ol start="3">
  <li><strong>Levantar los servicios:</strong> Ejecuta los siguientes comandos para iniciar los contenedores:</li>
<pre><code>docker compose up -d
. init.sh
</code></pre>
</ol>
<ol start="4">
  <li><strong>Acceso a las herramientas:>:</strong></li>
  <ul>
        <li>
            Apache Superset: <a href="http://localhost:8088/">http://localhost:8088/</a><br>
            Credenciales predeterminadas: <span class="credentials">admin/admin</span>
        </li>
        <li>
            pgAdmin: <a href="http://localhost:5050/">http://localhost:5050/</a><br>
            Configura la conexión a PostgreSQL utilizando las credenciales definidas en el archivo <span class="file">.env.db</span>.
        </li>
    </ul>
</ol>
<h2>Uso del Proyecto</h2>
<h3>1. Configuración de la Base de Datos</h3>
        <p>Accede a Apache Superset y crea una conexión a la base de datos PostgreSQL en la sección <span class="settings-text">Settings</span>. Asegúrate de que la conexión sea exitosa antes de proceder.</p>
<h3>2. Consultas SQL</h3>
  <h4>Consulta 1: Top 5 países que más turistas enviaron a Argentina</h4>
    <pre><code>SELECT p.nombre, SUM(tnr.viajes_de_turistas_no_residentes) AS total_viajes
  FROM turismo_no_residentes tnr
  JOIN pais p ON tnr.id_pais_origen = p.id
  GROUP BY p.nombre
  ORDER BY total_viajes DESC
  LIMIT 5;
    </code></pre>
  <h4>Consulta 2: Ranking de países con mayor diferencia entre residentes que los visitan y turistas que envían</h4>
     <pre><code>SELECT p.nombre,
    COALESCE(SUM(tr.viajes_de_turistas_residentes), 0) AS emisivo,
    COALESCE(SUM(tnr.viajes_de_turistas_no_residentes), 0) AS receptivo,
    COALESCE(SUM(tnr.viajes_de_turistas_no_residentes), 0) -       COALESCE(SUM(tr.viajes_de_turistas_residentes), 0) AS diferencia
    FROM pais p
    LEFT JOIN turismo_residentes tr ON tr.id_pais_destino = p.id
    LEFT JOIN turismo_no_residentes tnr ON tnr.id_pais_origen = p.id
    GROUP BY p.nombre
    ORDER BY diferencia DESC;
      </code></pre>
  <h4>Consulta 3: Países con mayor déficit o superávit turístico</h4>
    <pre><code> SELECT p.nombre, SUM(bt.balanza) AS saldo
  FROM balanza_turistica bt
  JOIN pais p ON bt.id_pais = p.id
  GROUP BY p.nombre
  ORDER BY saldo DESC;
    </code></pre>
  <h4>Consulta 4: Distribución por medio de transporte utilizado para viajes al exterior</h4>
    <pre><code>SELECT mt.nombre AS medio, SUM(viajes_de_turistas_residentes) AS total
  FROM turismo_residentes tr
  JOIN medio_transporte mt ON tr.id_medio_de_transporte = mt.id
  GROUP BY mt.nombre
  ORDER BY total DESC;
    </code></pre>
  <h3>3. Creación de Gráficos y Tableros</h3>
  <ol>
  <li><strong>Ejecuta las consultas en <code>SQL Lab</code> de Apache Superset.</strong></li>
</ol>
 <ol start="2">
  <li><strong>Haz clic en el botón <code>CREATE CHART</code> para crear gráficos interactivos.</strong></li>
</ol>
<ol start="3">
  <li><strong>Configura el tipo de gráfico y las dimensiones necesarias.</strong></li>
</ol>
<ol start="4">
  <li><strong>Guarda el gráfico en un tablero con el botón <code>SAVE</code>.</strong></li>
</ol>
  <h2>Estructura del Proyecto</h2>
    <pre><code>
  ETL-Turismo/
    ├── docker-compose.yml       # Configuración de Docker Compose
    ├──scripts                   #Carpeta contenedora del script de la base de datos
    ├── init.sh                  # Script de inicialización de base de datos
    ├──env.db                    #Variables de entorno
    ├── DATOS/                   # Carpeta para almacenar datasets
    └── README.md                # Documentación del proyecto
    </code></pre>

  ---
<h4>👥AUTORES</h4>
<table><tr><td align="center"><a href="https://github.com/celestecst"><img src="https://avatars.githubusercontent.com/u/185005959?v=4"width="112"/><br><sub><b>Celeste Olmedo</b></sub></a></td>
<td align="center"><a href="https://github.com/aldanaamante"><img src="https://avatars.githubusercontent.com/u/117917749?v=4" width="112"/><br><sub><b>Aldana Amante</b></sub></a></td>
<td align="center"><a href="https://github.com/TadeoBaricco"><img src="https://avatars.githubusercontent.com/u/180180907?v=4" width="112"/><br><sub><b>Tadeo Baricco</b></sub></a></td>
<td align="center"><a href="https://github.com/LuisinaRodriguez"><img src="https://avatars.githubusercontent.com/u/204231813?v=4" width="112"/><br><sub><b>Luisina Rodriguez</b></sub></a></td>
<td align="center"><a href="https://github.com/MiliiCuello19"><img src="https://avatars.githubusercontent.com/u/181528589?v=4" width="112"/><br><sub><b>Milagros Cuello</b></sub></a></td>
<td align="center"><a href="https://github.com/luubertello"><img src="https://avatars.githubusercontent.com/u/209468073?v=4" width="112"/><br><sub><b>Luciana Bertello</b></sub></a></td>
<td align="center"><a href="https://github.com/viksvik"><img src="https://avatars.githubusercontent.com/u/204233867?v=4" width="112"/><br><sub><b>Victoria Ocanto</b></sub></a></td>
</tr></table>

  
</body>
</html>

