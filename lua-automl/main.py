import logging
from fastapi import FastAPI, UploadFile, File, HTTPException, Form, Depends
from fastapi.responses import FileResponse
from pydantic import BaseModel
from pycaret.classification import setup, compare_models, save_model, load_model, predict_model, pull
from pycaret.clustering import setup as clustering_setup, create_model as clustering_create_model, save_model as clustering_save_model, pull as clustering_pull, predict_model as clustering_predict_model, plot_model as clus_plot_model
import pandas as pd
import os
import json
from sqlalchemy.orm import Session
from models import ModelInfo, SessionLocal, engine
import matplotlib.pyplot as plt
from shutil import move


# Configuración del logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

app = FastAPI()

# Directorio para guardar los modelos
MODEL_DIR = "models"
PLOTS_DIR = "plots"

if not os.path.exists(MODEL_DIR):
    os.makedirs(MODEL_DIR)
if not os.path.exists(PLOTS_DIR):
    os.makedirs(PLOTS_DIR)

class ModelIDInput(BaseModel):
    model_id: int

class PredictionRequest(BaseModel):
    model_id: int
    features: dict

# Dependencia de la sesión de base de datos
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post('/train')
async def train_model(file: UploadFile = File(...), params: str = Form(...), db: Session = Depends(get_db)):
    try:
        if not file.filename.endswith('.csv'):
            raise HTTPException(status_code=400, detail="The file must be a CSV.")
        
        logger.info("Reading CSV file...")
        # Convertir la cadena JSON a un diccionario
        params_dict = json.loads(params)
        task = params_dict.get('task')
        budget_time = params_dict.get('budget_time')
        target = params_dict.get('target')
        n_clusters = params_dict.get('n_clusters')
        
        if not task or not budget_time or (task == 'classification' and not target):
            raise HTTPException(status_code=400, detail="Parameters 'task', 'budget_time', and 'target' (for classification) are required.")
        
        try:
            data = pd.read_csv(file.file, quotechar='"', delimiter=";")
            logger.info(f"Dataset shape: {data.shape}")
            logger.info(f"Dataset head: {data.head()}")
        except pd.errors.ParserError as e:
            logger.error(f"Error parsing CSV file: {e}")
            raise HTTPException(status_code=400, detail=f"Error parsing CSV file: {e}")
        
        logger.info(f"Training model for task: {task}")
        if task == 'classification':
            s = setup(data, target=target, session_id=123, html=False)
            best_model = compare_models(budget_time=budget_time)
            model_name = f"best_classification_model_{len(os.listdir(MODEL_DIR))}"
            model_path = os.path.join(MODEL_DIR, model_name)
            save_model(best_model, model_path)
            logger.info("Classification model trained and saved.")

            # Extraer las métricas del mejor modelo
            metrics_df = pull()
            metrics = metrics_df.iloc[0].to_dict()

            # Guardar información del modelo en la base de datos
            dataframe_structure = data.dtypes.apply(lambda x: x.name).to_dict()
            labels = data[target].unique().tolist()

            model_info = ModelInfo(
                dataset_name=file.filename,
                model_name=model_name,
                model_path=model_path,
                dataframe_structure=json.dumps(dataframe_structure),
                labels=json.dumps(labels),
                metrics=json.dumps(metrics)
            )
            db.add(model_info)
            db.commit()
            db.refresh(model_info)

            return {"detail": "Classification model trained and saved.", "model_id": model_info.id}
        
        elif task == 'clustering':
            s = clustering_setup(data, session_id=123)
            kmeans = clustering_create_model('kmeans', num_clusters=n_clusters)

            model_name = f"best_clustering_model_{len(os.listdir(MODEL_DIR))}"
            model_path = os.path.join(MODEL_DIR, model_name)
            clustering_save_model(kmeans, model_path)
            logger.info("Clustering model trained and saved.")

            # Guardar información del modelo en la base de datos
            dataframe_structure = data.dtypes.apply(lambda x: x.name).to_dict()
            logger.info("Clustering model dataframe structure: {dataframe_structure}")
            # Extraer las métricas del mejor modelo
            metrics_df = clustering_pull()
            metrics = metrics_df.iloc[0].to_dict()
            logger.info("Clustering model metrics: {metrics}")

            model_info = ModelInfo(
                dataset_name=file.filename,
                model_name=model_name,
                model_path=model_path,
                dataframe_structure=json.dumps(dataframe_structure),
                labels=json.dumps([]),  # Clustering may not have labels
                metrics=json.dumps(metrics)
            )
            db.add(model_info)
            db.commit()
            db.refresh(model_info)

            # Generar y mover los gráficos de distribución y silhouette plot con el ID del modelo en los nombres de archivo
            distribution_plot_path = os.path.join(PLOTS_DIR, f"{model_info.id}_distribution.html")
            silhouette_plot_path = os.path.join(PLOTS_DIR, f"{model_info.id}_silhouette.png")

            clus_plot_model(kmeans, plot='distribution', save=True)
            if os.path.exists("Distribution Plot.png"):
                os.rename("Distribution Plot.png", distribution_plot_path)
            else:
                logger.error("Distribution plot not found after generation.")

            clus_plot_model(kmeans, plot='silhouette', save=True)
            if os.path.exists("Silhouette Plot.png"):
                os.rename("Silhouette Plot.png", silhouette_plot_path)
            else:
                logger.error("Silhouette plot not found after generation.")

            # Actualizar el registro del modelo en la base de datos con las rutas de los gráficos
            model_info.distribution_plot = distribution_plot_path
            model_info.silhouette_plot = silhouette_plot_path
            db.commit()
            db.refresh(model_info)

            return {"detail": "Clustering model trained and saved.", "model_id": model_info.id}
        
        else:
            raise HTTPException(status_code=400, detail="Invalid task. Must be 'classification' or 'clustering'.")
    
    except Exception as e:
        logger.error(f"Internal server error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post('/predict')
def predict(request: PredictionRequest, db: Session = Depends(get_db)):
    logger.info(f"Prediction request received for model ID: {request.model_id}")
    try:
        model_info = db.query(ModelInfo).filter(ModelInfo.id == request.model_id).first()
        if not model_info:
            raise HTTPException(status_code=404, detail="Model not found. Train a model first.")

        model_path = model_info.model_path
        model = load_model(model_path)
        input_data = pd.DataFrame([request.features])
        #guardamos en el logger el head del dataframe
        logger.info(f"Input data: {input_data.head()}")
        if model_info.model_name.startswith("best_clustering_model"):
            prediction = clustering_predict_model(model, data=input_data)
            logger.info(f"Prediction made: {prediction.iloc[0]['Cluster']}")
            #quitar la palabra Cluster del resultado de la predicción
            resultado_prediction = prediction.iloc[0]['Cluster']
            prediction_return = int(resultado_prediction.replace("Cluster ", ""))
        else:
            prediction = predict_model(model, data=input_data)
            logger.info(f"Prediction made: {prediction['prediction_label'][0]}")
            prediction_return = int(prediction['prediction_label'][0])

        return {'prediction': prediction_return}
    
    except Exception as e:
        logger.error(f"Internal server error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get('/model_info/{model_id}')
def model_info(model_id: int, db: Session = Depends(get_db)):
    try:
        model_info = db.query(ModelInfo).filter(ModelInfo.id == model_id).first()
        if not model_info:
            raise HTTPException(status_code=404, detail="Model not found.")
        
        model = load_model(model_info.model_path)
        logger.info("Model info retrieved.")
        return {
            "model_id": model_info.id,
            "dataset_name": model_info.dataset_name,
            "model_name": model_info.model_name,
            "model_path": model_info.model_path,
            "dataframe_structure": json.loads(model_info.dataframe_structure),
            "labels": json.loads(model_info.labels),
            "metrics": json.loads(model_info.metrics),
            "model_details": str(model)
        }
    
    except Exception as e:
        logger.error(f"Internal server error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get('/model_info/{model_id}/distribution_plot')
def get_distribution_plot(model_id: int, db: Session = Depends(get_db)):
    try:
        model_info = db.query(ModelInfo).filter(ModelInfo.id == model_id).first()
        if not model_info or not model_info.distribution_plot:
            raise HTTPException(status_code=404, detail="Distribution plot not found.")
        
        return FileResponse(model_info.distribution_plot, media_type='image/png')
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")

@app.get('/model_info/{model_id}/silhouette_plot')
def get_silhouette_plot(model_id: int, db: Session = Depends(get_db)):
    try:
        model_info = db.query(ModelInfo).filter(ModelInfo.id == model_id).first()
        if not model_info or not model_info.silhouette_plot:
            raise HTTPException(status_code=404, detail="Silhouette plot not found.")
        
        return FileResponse(model_info.silhouette_plot, media_type='image/png')
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")

@app.get('/')
def read_root():
    logger.info("Root endpoint accessed.")
    return {"message": "Welcome to PyCaret API"}