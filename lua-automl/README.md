# AutoML LIBRA

API construida usando FastAPI y PyCaret, para integrar una solución de AutoML dentro del ERP LIBRA.

El código principal está en main.py.

Los modelos generados se guardan en la carpeta models.

Los gráficos generados se guardan en la carpeta plots.

El despliegue se realiza mediante docker-compose.

Se hace uso de sqlite para almacenar las peticiones e información de los modelos entrenados en el archivo models.db.

Con redeploy.sh se puede reejecutar el contenedor.