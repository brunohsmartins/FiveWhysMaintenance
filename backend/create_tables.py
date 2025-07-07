# create_tables.py
from whyscore.schema      import Base        # <- Base de where você definiu o modelo
from whyscore.database    import engine      # <- engine que o app realmente injeta

print("Iniciando criação de tabelas no banco de dados...")
# Caminho absoluto do banco de dados:
from pathlib import Path
print("Caminho absoluto do banco de dados:", Path("fivewhys.db").resolve())

# CRIA de fato as tabelas
Base.metadata.create_all(bind=engine)

print("Tabelas criadas com sucesso no banco de dados.")
