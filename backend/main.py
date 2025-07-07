from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from whyscore.routes import router as fivewhys_router
from dotenv import load_dotenv
import os

# Carrega as variáveis do .env
dotenv_path = os.path.join(os.path.dirname(__file__), '.env')
load_dotenv(dotenv_path)

app = FastAPI()

# Permite chamadas do Flutter Web
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Inclui as rotas da API
app.include_router(fivewhys_router)