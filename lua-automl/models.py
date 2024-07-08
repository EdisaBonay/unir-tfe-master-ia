from sqlalchemy import create_engine, Column, Integer, String, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "sqlite:///./models.db"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class ModelInfo(Base):
    __tablename__ = "model_info"

    id = Column(Integer, primary_key=True, index=True)
    dataset_name = Column(String, index=True)
    model_name = Column(String, index=True)
    model_path = Column(String, index=True)
    dataframe_structure = Column(Text)  # JSON string of DataFrame structure
    labels = Column(Text)  # JSON string of possible labels
    metrics = Column(Text)  # JSON string of model metrics
    distribution_plot = Column(String)  # Añadir campo para la ruta del gráfico de distribución
    silhouette_plot = Column(String)  # Añadir campo para la ruta del gráfico de silhouette

# Crear la tabla en la base de datos
Base.metadata.create_all(bind=engine)