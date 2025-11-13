# Proyecto IT Academy - Análisis de Datos de Empleo en España

## Descripción del Proyecto

Este proyecto realiza un análisis exhaustivo de los datos de empleo en España durante el período 2021-2024, incluyendo datos de paro registrado, contrataciones y población por municipio. El análisis incluye visualizaciones temporales, geográficas y comparativas para identificar tendencias y patrones en el mercado laboral español.

## 📊 Fuentes de Datos

### Datos de Paro
- **Fuente**: SEPE (Servicio Público de Empleo Estatal)
- **Período**: 2021-2024 (mensual)
- **Segmentación**: Por edad, sexo, sector y municipio
- **Archivos**: Múltiples archivos CSV en directorio `Paro/`

### Datos de Contrataciones
- **Fuente**: SEPE (Servicio Público de Empleo Estatal)
- **Período**: 2021-2024 (mensual)
- **Segmentación**: Por tipo de contrato, sexo, sector y municipio
- **Archivos**: Múltiples archivos CSV en directorio `Contrataciones/`

### Datos de Población
- **Fuente**: INE (Instituto Nacional de Estadística)
- **Período**: 2021-2024 (anual)
- **Segmentación**: Por sexo y municipio
- **Archivo**: `poblacion/poblacion.csv`

### Datos Geográficos
- **Fuente**: Instituto Geográfico Nacional (via Opendatasoft)
- **Contenido**: Coordenadas de municipios y provincias
- **Formato**: GeoJSON
- **Archivos**: `geojson/municipios.geojson`, `geojson/provincias.geojson`

## 🔧 Proceso de Análisis

### 1. Carga y Unificación de Datos
- Carga de múltiples archivos CSV de paro y contrataciones
- Unificación en DataFrames únicos
- Integración con datos de población y geográficos

### 2. Limpieza y Transformación
- Estandarización de nombres de columnas
- Conversión de formatos de fecha
- Manejo de valores especiales ("<5" → NaN → imputación)
- Cálculo de tasas de paro y contrataciones

### 3. Feature Engineering
- Creación de variables agregadas:
  - `Paro hombres` = Suma de paro por categorías de edad masculinas
  - `Paro mujeres` = Suma de paro por categorías de edad femeninas
  - `Tasa paro` = (Total paro / Población total) × 100
  - `Tasa contrataciones` = (Total contratos / Población total) × 100

## 📈 Visualizaciones Implementadas

### Visualizaciones Temporales
1. **Evolución del paro y contrataciones globales** - Tendencias generales 2021-2024
2. **Evolución por sexo** - Comparativa hombres vs mujeres
3. **Evolución por rango de edad** - Análisis por grupos de edad y sexo
4. **Evolución de contrataciones por tipo** - Indefinidos vs temporales
5. **Evolución por sector económico** - Agricultura, industria, construcción, servicios
6. **Evolución de tasas** - Tasa de paro vs tasa de contrataciones

### Visualizaciones Geográficas
- **Mapa interactivo** con Folium mostrando tasas de paro por municipio y provincia
- Capas separadas para visualización municipal y provincial
- Tooltips con información detallada al hacer hover

### Visualizaciones Comparativas
1. **Tasa de paro por comunidad autónoma** - Gráfico de barras comparativo
2. **Diferencia de paro por edad y sexo** - Gráfico divergente
3. **Diferencia de contrataciones por tipo y sexo** - Análisis de brechas

## 🎯 Hallazgos Principales

### Tendencias Generales
- Reducción constante del paro desde 2021 hasta 2024
- Efecto visible de la reforma laboral de 2021 en el aumento de contratos indefinidos
- Estacionalidad marcada en las contrataciones del sector servicios

### Diferencias por Sexo
- Mayor tasa de paro en mujeres en todas las franjas de edad
- Brecha más pronunciada en mayores de 45 años
- Reducción progresiva de la diferencia en contrataciones

### Distribución Geográfica
- Mayor tasa de paro en el sur de España
- Ceuta (11.4%) y Melilla (9.9%) con las tasas más altas
- Baleares (2%) y Soria (3%) con las tasas más bajas

## 🛠️ Tecnologías Utilizadas

- **Python 3.x**
- **Pandas** - Manipulación y análisis de datos
- **Plotly** - Visualizaciones interactivas
- **Folium** - Mapas interactivos
- **GeoPandas** - Procesamiento de datos geográficos
- **Jupyter Notebook** - Entorno de desarrollo

## 📁 Estructura del Proyecto

```
proyecto/
├── Paro/                    # Datos de paro por mes
├── Contrataciones/          # Datos de contrataciones por mes
├── poblacion/
│   └── poblacion.csv        # Datos de población
├── geojson/
│   ├── municipios.geojson   # Geometrías de municipios
│   └── provincias.geojson   # Geometrías de provincias
└── proyecto.pdf            # Notebook con el análisis completo
```

## ▶️ Ejecución del Código

1. **Requisitos previos**:
   ```bash
   pip install pandas numpy plotly geopandas folium
   ```

2. **Estructura de datos**: Asegurar que los directorios y archivos de datos estén en la ubicación correcta

3. **Ejecución**: Ejecutar las celdas del notebook en orden secuencial

## 📊 Métricas Calculadas

- **Tasa de paro**: Porcentaje de población en paro
- **Tasa de contrataciones**: Porcentaje de población con contratos
- **Agregaciones**: Totales por municipio, provincia, comunidad autónoma
- **Comparativas**: Diferencias por sexo, edad, tipo de contrato

## 🔍 Aplicaciones Prácticas

Este análisis permite:
- Identificar tendencias del mercado laboral
- Detectar desigualdades territoriales y demográficas
- Evaluar el impacto de políticas laborales
- Planificar estrategias de empleo a nivel regional y nacional

## 📄 Licencia y Uso

Los datos son de fuentes oficiales públicas (SEPE, INE) y el código está disponible para fines educativos y de análisis. Se recomienda citar las fuentes originales al utilizar los datos o resultados.
