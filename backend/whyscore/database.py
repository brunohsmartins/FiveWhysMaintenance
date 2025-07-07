from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# URL do SQLite local
DATABASE_URL = "sqlite:///./fivewhys.db"

engine = create_engine(
    DATABASE_URL, connect_args={"check_same_thread": False}
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Declarative base para os modelos
Base = declarative_base()

# Dependency para rotas
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

